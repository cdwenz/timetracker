import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Offline support
import '../models/tracking_entry.dart';
import 'local_database.dart';
import 'connectivity_service.dart';

class TimeTrackerService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<bool> submitTimeTracker({
    required String supportedPerson,
    required String supportedCountry,
    required String workingLanguage,
    required String startDate,
    required String endDate,
    required String recipient,
    required String note,
    required String startTimeOfDay,
    required String endTimeOfDay,
    required List<String> tasks,
    required String taskDescription,
  }) async {
    try {
      // Crear entry para la base de datos local
      final trackingEntry = TrackingEntry(
        person: supportedPerson,
        country: supportedCountry,
        workingLanguage: workingLanguage,
        recipient: recipient,
        note: note,
        startDate: startDate,
        endDate: endDate,
        startTime: startTimeOfDay,
        endTime: endTimeOfDay,
        tasks: tasks,
        description: taskDescription,
        synced: false,
        syncStatus: 'pending',
      );

      // Guardar localmente primero (siempre)
      final localId = await LocalDatabase.insertTracking(trackingEntry);
      print('✅ Entry guardado localmente con ID: $localId');

      // Verificar conectividad
      final isConnected = await ConnectivityService.quickConnectivityCheck();
      
      if (isConnected) {
        // Intentar enviar inmediatamente si hay conexión
        print('📡 Intentando enviar inmediatamente (hay conexión)...');
        final success = await _syncSingleEntry(trackingEntry.copyWith(id: localId));
        
        if (success) {
          print('✅ Entry enviado exitosamente al servidor');
          return true;
        } else {
          print('⚠️ Entry guardado localmente, se sincronizará cuando esté disponible');
          return true; // Devolvemos true porque está guardado localmente
        }
      } else {
        print('📵 Sin conexión - Entry guardado para sincronización posterior');
        return true; // Devolvemos true porque está guardado localmente
      }
      
    } catch (e) {
      print('❌ Error en submitTimeTracker: $e');
      return false;
    }
  }

  /// Sincronizar una entrada individual con el servidor
  static Future<bool> _syncSingleEntry(TrackingEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print('❌ No hay token de autenticación disponible');
        return false;
      }

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
        }),
      ).timeout(const Duration(seconds: 30));

      print('API response: ${response.statusCode} ${response.body}');
      
      if (response.statusCode == 201) {
        // Parsear respuesta para obtener ID del servidor
        final responseData = jsonDecode(response.body);
        final serverId = responseData['id']?.toString() ?? 
                        responseData['_id']?.toString() ?? 
                        'unknown';
        
        // Marcar como sincronizado en la base de datos local
        if (entry.id != null) {
          await LocalDatabase.markAsSynced(entry.id!, serverId);
        }
        
        return true;
      } else {
        // Marcar como fallido si el entry tiene ID
        if (entry.id != null) {
          await LocalDatabase.markSyncFailed(entry.id!);
        }
        return false;
      }
    } catch (e) {
      print('❌ Error al sincronizar entry: $e');
      // Marcar como fallido si el entry tiene ID
      if (entry.id != null) {
        await LocalDatabase.markSyncFailed(entry.id!);
      }
      return false;
    }
  }

  /// Obtener todas las entradas locales (sincronizadas y pendientes)
  static Future<List<TrackingEntry>> getAllLocalEntries() async {
    try {
      return await LocalDatabase.getAllTrackingEntries();
    } catch (e) {
      print('❌ Error al obtener entries locales: $e');
      return [];
    }
  }

  /// Obtener solo las entradas pendientes de sincronización
  static Future<List<TrackingEntry>> getPendingEntries() async {
    try {
      return await LocalDatabase.getUnsyncedEntries();
    } catch (e) {
      print('❌ Error al obtener entries pendientes: $e');
      return [];
    }
  }

  /// Obtener estadísticas de sincronización
  static Future<Map<String, int>> getSyncStats() async {
    try {
      return await LocalDatabase.getSyncStats();
    } catch (e) {
      print('❌ Error al obtener estadísticas: $e');
      return {'total': 0, 'synced': 0, 'pending': 0, 'failed': 0};
    }
  }
}
