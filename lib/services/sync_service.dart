import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tracking_entry.dart';
import 'local_database.dart';
import 'connectivity_service.dart';

/// Estados de sincronización
enum SyncStatus {
  idle,      // Sin actividad
  syncing,   // Sincronizando
  success,   // Éxito
  failed,    // Error
  paused,    // Pausado
}

/// Servicio de sincronización offline/online
class SyncService extends ChangeNotifier {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const Duration syncInterval = Duration(minutes: 5);
  static const int maxRetryAttempts = 3;
  
  // Estado del servicio
  SyncStatus _status = SyncStatus.idle;
  String _lastSyncMessage = '';
  DateTime? _lastSyncTime;
  Timer? _periodicSyncTimer;
  bool _isInitialized = false;
  int _pendingSyncCount = 0;
  int _failedSyncCount = 0;

  // Getters públicos
  SyncStatus get status => _status;
  String get lastSyncMessage => _lastSyncMessage;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingSyncCount => _pendingSyncCount;
  int get failedSyncCount => _failedSyncCount;
  bool get isInitialized => _isInitialized;

  /// Inicializar el servicio de sincronización
  Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      _updateStatus(SyncStatus.idle, 'Inicializando servicio de sincronización...');
      
      // Inicializar base de datos
      await LocalDatabase.database;
      
      // Obtener estadísticas iniciales
      await _updateSyncStats();

      // Configurar sincronización periódica
      _startPeriodicSync();

      _isInitialized = true;
      _updateStatus(SyncStatus.idle, 'Servicio de sincronización inicializado');
      
      print('🔄 SyncService inicializado correctamente');
    } catch (e) {
      _updateStatus(SyncStatus.failed, 'Error al inicializar: $e');
      print('❌ Error al inicializar SyncService: $e');
    }
  }

  /// Iniciar sincronización periódica automática
  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(syncInterval, (timer) {
      if (ConnectivityService().isConnected && _status != SyncStatus.syncing) {
        syncPendingEntries();
      }
    });
    print('⏰ Sincronización periódica configurada cada ${syncInterval.inMinutes} minutos');
  }

  /// Actualizar estadísticas de sincronización
  Future<void> _updateSyncStats() async {
    try {
      final stats = await LocalDatabase.getSyncStats();
      _pendingSyncCount = stats['pending'] ?? 0;
      _failedSyncCount = stats['failed'] ?? 0;
      notifyListeners();
    } catch (e) {
      print('⚠️ Error al actualizar estadísticas de sync: $e');
    }
  }

  /// Actualizar estado y notificar
  void _updateStatus(SyncStatus status, String message) {
    _status = status;
    _lastSyncMessage = message;
    if (status == SyncStatus.success || status == SyncStatus.failed) {
      _lastSyncTime = DateTime.now();
    }
    notifyListeners();
    print('🔄 Sync: [$status] $message');
  }

  /// Obtener token de autenticación
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      if (token != null) {
        return token;
      }
      
      print('⚠️ No hay token disponible para sincronización');
      print('💡 Sugerencia: Haz login online para obtener un token válido');
      return null;
    } catch (e) {
      print('❌ Error al obtener token: $e');
      return null;
    }
  }

  /// Sincronizar todas las entradas pendientes
  Future<bool> syncPendingEntries() async {
    if (_status == SyncStatus.syncing) {
      print('⚠️ Sincronización ya en progreso');
      return false;
    }

    if (!ConnectivityService().isConnected) {
      _updateStatus(SyncStatus.failed, 'Sin conexión a internet');
      return false;
    }

    try {
      _updateStatus(SyncStatus.syncing, 'Sincronizando entradas pendientes...');

      final token = await _getAuthToken();
      if (token == null) {
        _updateStatus(SyncStatus.failed, 'Necesitas hacer login online para sincronizar');
        return false;
      }

      // Obtener entradas pendientes y fallidas
      final pendingEntries = await LocalDatabase.getUnsyncedEntries();
      final failedEntries = await LocalDatabase.getFailedSyncEntries();
      
      final allEntries = [...pendingEntries, ...failedEntries];
      
      if (allEntries.isEmpty) {
        _updateStatus(SyncStatus.success, 'No hay entradas para sincronizar');
        await _updateSyncStats();
        return true;
      }

      print('📤 Sincronizando ${allEntries.length} entradas...');

      int successCount = 0;
      int failureCount = 0;

      // Sincronizar cada entrada
      for (final entry in allEntries) {
        try {
          final success = await _syncSingleEntry(entry, token);
          if (success) {
            successCount++;
          } else {
            failureCount++;
            await LocalDatabase.markSyncFailed(entry.id!);
          }
        } catch (e) {
          print('❌ Error sincronizando entry ${entry.id}: $e');
          failureCount++;
          await LocalDatabase.markSyncFailed(entry.id!);
        }

        // Pequeña pausa entre sincronizaciones para no sobrecargar
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Actualizar estadísticas
      await _updateSyncStats();

      if (failureCount == 0) {
        _updateStatus(SyncStatus.success, 
          'Sincronización completada: $successCount entradas enviadas');
      } else {
        _updateStatus(SyncStatus.failed, 
          'Sincronización parcial: $successCount exitosas, $failureCount fallidas');
      }

      return failureCount == 0;

    } catch (e) {
      _updateStatus(SyncStatus.failed, 'Error en sincronización: $e');
      print('❌ Error en syncPendingEntries: $e');
      return false;
    }
  }

  /// Sincronizar una entrada individual
  Future<bool> _syncSingleEntry(TrackingEntry entry, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/time-tracker'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'personName': entry.person,
          'supportedCountry': entry.country,
          'workingLanguage': entry.workingLanguage,
          'startDate': entry.startDate,
          'endDate': entry.endDate,
          'recipient': entry.recipient,
          'note': entry.note,
          'startTimeOfDay': entry.startTime,
          'endTimeOfDay': entry.endTime,
          'tasks': entry.tasks,
          'taskDescription': entry.description,
          // Agregar metadatos de offline sync
          'syncMetadata': {
            'localId': entry.id,
            'localLastModified': entry.lastModified.toIso8601String(),
          }
        }),
      ).timeout(const Duration(seconds: 30));

      print('📡 Respuesta del servidor para entry ${entry.id}: ${response.statusCode}');

      if (response.statusCode == 201) {
        // Parsear respuesta para obtener ID del servidor
        final responseData = jsonDecode(response.body);
        final serverId = responseData['id']?.toString() ?? 
                        responseData['_id']?.toString() ?? 
                        'unknown';

        // Marcar como sincronizado en la base de datos local
        await LocalDatabase.markAsSynced(entry.id!, serverId);
        
        print('✅ Entry ${entry.id} sincronizado exitosamente (server ID: $serverId)');
        return true;
      } else {
        final errorBody = response.body;
        print('❌ Error del servidor para entry ${entry.id}:');
        print('   Status Code: ${response.statusCode}');
        print('   Response Body: $errorBody');
        
        // Log del payload enviado para debugging
        final payload = {
          'personName': entry.person,
          'supportedCountry': entry.country,
          'workingLanguage': entry.workingLanguage,
          'startDate': entry.startDate,
          'endDate': entry.endDate,
          'recipient': entry.recipient,
          'note': entry.note,
          'startTimeOfDay': entry.startTime,
          'endTimeOfDay': entry.endTime,
          'tasks': entry.tasks,
          'taskDescription': entry.description,
        };
        print('   Payload enviado: ${jsonEncode(payload)}');
        return false;
      }

    } catch (e) {
      print('❌ Error en _syncSingleEntry: $e');
      return false;
    }
  }

  /// Forzar sincronización inmediata
  Future<bool> forcSync() async {
    print('🚀 Forzando sincronización inmediata...');
    return await syncPendingEntries();
  }

  /// Reintentar entradas fallidas
  Future<bool> retryFailedEntries() async {
    if (!ConnectivityService().isConnected) {
      _updateStatus(SyncStatus.failed, 'Sin conexión para reintentar');
      return false;
    }

    try {
      _updateStatus(SyncStatus.syncing, 'Reintentando entradas fallidas...');
      
      final failedEntries = await LocalDatabase.getFailedSyncEntries();
      
      if (failedEntries.isEmpty) {
        _updateStatus(SyncStatus.success, 'No hay entradas fallidas para reintentar');
        return true;
      }

      // Cambiar estado a pending antes de reintentar
      for (final entry in failedEntries) {
        final updatedEntry = entry.copyWith(syncStatus: 'pending');
        await LocalDatabase.updateTrackingEntry(updatedEntry);
      }

      return await syncPendingEntries();

    } catch (e) {
      _updateStatus(SyncStatus.failed, 'Error al reintentar: $e');
      return false;
    }
  }

  /// Pausar sincronización automática
  void pauseSync() {
    _periodicSyncTimer?.cancel();
    _updateStatus(SyncStatus.paused, 'Sincronización automática pausada');
  }

  /// Reanudar sincronización automática
  void resumeSync() {
    if (_status == SyncStatus.paused) {
      _startPeriodicSync();
      _updateStatus(SyncStatus.idle, 'Sincronización automática reanudada');
    }
  }

  /// Limpiar entradas sincronizadas antiguas
  Future<void> cleanOldEntries({int daysOld = 30}) async {
    try {
      await LocalDatabase.cleanOldSyncedEntries(daysOld: daysOld);
      await _updateSyncStats();
      print('🧹 Limpieza de entradas antiguas completada');
    } catch (e) {
      print('❌ Error en limpieza: $e');
    }
  }

  /// Obtener información detallada del estado de sincronización
  Map<String, dynamic> getDetailedSyncInfo() {
    return {
      'status': _status.toString(),
      'lastSyncMessage': _lastSyncMessage,
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
      'pendingSyncCount': _pendingSyncCount,
      'failedSyncCount': _failedSyncCount,
      'isInitialized': _isInitialized,
      'periodicSyncActive': _periodicSyncTimer?.isActive ?? false,
      'connectivityStatus': ConnectivityService().isConnected,
    };
  }

  /// Verificar si necesita sincronización urgente
  bool needsUrgentSync() {
    return _pendingSyncCount > 10 || _failedSyncCount > 5;
  }

  /// Limpiar recursos
  @override
  void dispose() {
    _periodicSyncTimer?.cancel();
    super.dispose();
  }
}