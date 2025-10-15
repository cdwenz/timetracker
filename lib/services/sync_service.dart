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

  static const String baseUrl = 'https://timetracker-nest-mvp-production.up.railway.app/api';
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;
  
  // Estado del servicio
  SyncStatus _status = SyncStatus.idle;
  String _lastSyncMessage = '';
  DateTime? _lastSyncTime;
  Timer? _periodicSyncTimer;
  bool _isInitialized = false;
  int _pendingSyncCount = 0;
  int _failedSyncCount = 0;
  bool _hasNotifiedPendingSync = false;
  bool _allowAutoSync = true;
  StreamSubscription<bool>? _connectivitySubscription;

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
      await updateSyncStats();

      // Configurar sincronización periódica
      _startPeriodicSync();

      // Escuchar cambios de conectividad para notificar registros pendientes
      _setupConnectivityListener();

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
      if (ConnectivityService().isConnected && _status != SyncStatus.syncing && _allowAutoSync) {
        print('⏰ Sincronización periódica automática...');
        syncPendingEntries();
      }
    });
    print('⏰ Sincronización periódica configurada cada ${syncInterval.inMinutes} minutos');
  }

  /// Configurar listener de conectividad para notificar registros pendientes
  void _setupConnectivityListener() {
    final connectivityService = ConnectivityService();
    
    // Escuchar cambios de conectividad
    connectivityService.addListener(() {
      if (connectivityService.isConnected) {
        _onConnectivityRestored();
      } else {
        _hasNotifiedPendingSync = false; // Reset para próxima conexión
      }
    });
  }

  /// Manejar cuando se restablece la conectividad
  void _onConnectivityRestored() async {
    // Solo notificar una vez por sesión de reconexión
    if (_hasNotifiedPendingSync) return;
    
    try {
      // Forzar actualización de estadísticas
      await updateSyncStats();
      
      print('🔍 Conectividad restablecida - Verificando registros pendientes:');
      print('   Pendientes: $_pendingSyncCount');
      print('   Fallidos: $_failedSyncCount');
      
      // Si hay registros pendientes o fallidos, mostrar notificación
      if ((_pendingSyncCount > 0 || _failedSyncCount > 0)) {
        final totalPending = _pendingSyncCount + _failedSyncCount;
        _updateStatus(SyncStatus.idle, 
          '¡Conexión restablecida! Tienes $totalPending registro(s) pendiente(s) de sincronizar');
        
        _hasNotifiedPendingSync = true;
        
        print('📢 Notificación: $totalPending registros pendientes detectados');
        
        // Pausar sincronización automática para dar tiempo al usuario
        pauseAutoSync(duration: const Duration(seconds: 30));
        
        // Programar sincronización después del periodo de pausa
        Timer(const Duration(seconds: 30), () {
          if (ConnectivityService().isConnected && _status != SyncStatus.syncing) {
            print('🔄 Iniciando sincronización automática tras periodo de gracia...');
            syncPendingEntries();
          }
        });
      } else {
        print('✅ No hay registros pendientes para sincronizar');
      }
    } catch (e) {
      print('⚠️ Error al verificar registros pendientes: $e');
    }
  }

  /// Actualizar estadísticas de sincronización
  Future<void> updateSyncStats() async {
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
        _updateStatus(SyncStatus.failed, 'Token requerido para sincronización');
        return false;
      }

      // Obtener entradas pendientes y fallidas
      final pendingEntries = await LocalDatabase.getUnsyncedEntries();
      final failedEntries = await LocalDatabase.getFailedSyncEntries();
      
      final allEntries = [...pendingEntries, ...failedEntries];
      
      if (allEntries.isEmpty) {
        _updateStatus(SyncStatus.success, 'No hay entradas para sincronizar');
        await updateSyncStats();
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
      await updateSyncStats();

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

      print('📷 Respuesta del servidor para entry ${entry.id}: ${response.statusCode}');

      if (response.statusCode == 201) {
        // ✅ Éxito: Parsear respuesta para obtener ID del servidor
        final responseData = jsonDecode(response.body);
        final serverId = responseData['id']?.toString() ??
                        responseData['_id']?.toString() ?? 
                        'unknown';

        // Marcar como sincronizado en la base de datos local
        await LocalDatabase.markAsSynced(entry.id!, serverId);
        
        print('✅ Entry ${entry.id} sincronizado exitosamente (server ID: $serverId)');
        return true;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // ❌ Errores 4xx: Problema del cliente (datos inválidos, falta organización, etc.)
        // Estos NO deben reintentarse - marcar como fallidos permanentemente
        final errorBody = response.body;
        print('❌ Error del cliente para entry ${entry.id}:');
        print('   Status Code: ${response.statusCode}');
        print('   Response Body: $errorBody');
        
        String errorMsg = 'Error del cliente: ${response.statusCode}';
        try {
          final errorData = jsonDecode(errorBody);
          errorMsg = errorData['message'] ?? errorMsg;
        } catch (e) {
          // Si no se puede parsear, usar mensaje genérico
        }
        
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
        
        // Marcar como fallido permanentemente (no reintentar)
        await LocalDatabase.markSyncFailedPermanently(entry.id!, errorMsg);
        print('   ⚠️ Entry marcado como fallo permanente (no se reintentará)');
        
        return false;
      } else {
        // ⚠️ Errores 5xx o de conectividad: Estos SÍ pueden reintentarse
        final errorBody = response.body;
        print('⚠️ Error del servidor para entry ${entry.id}:');
        print('   Status Code: ${response.statusCode}');
        print('   Response Body: $errorBody');
        print('   Este error puede reintentarse más tarde');
        
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
    // Reanudar sincronización automática cuando usuario sincroniza manualmente
    resumeAutoSync();
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
      await updateSyncStats();
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

  /// Pausar sincronización automática temporalmente (para que usuario vea notificaciones)
  void pauseAutoSync({Duration? duration}) {
    _allowAutoSync = false;
    print('⏸️ Sincronización automática pausada');
    
    if (duration != null) {
      Timer(duration, () {
        _allowAutoSync = true;
        print('▶️ Sincronización automática reanudada');
      });
    }
  }

  /// Reanudar sincronización automática
  void resumeAutoSync() {
    _allowAutoSync = true;
    print('▶️ Sincronización automática reanudada manualmente');
  }

  /// Limpiar recursos
  @override
  void dispose() {
    _periodicSyncTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}