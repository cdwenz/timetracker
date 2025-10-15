import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Offline support
import '../models/tracking_entry.dart';
import 'local_database.dart';
import 'connectivity_service.dart';
import 'sync_service.dart';

class TimeTrackerService {
  static const String baseUrl = 'https://timetracker-nest-mvp-production.up.railway.app/api';

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
      // Verificar conectividad PRIMERO
      final isConnected = await ConnectivityService.quickConnectivityCheck();
      
      if (isConnected) {
        // CON INTERNET: Enviar directamente al servidor
        print('📡 Enviando directamente al servidor (hay conexión)...');
        
        final result = await _submitDirectlyWithErrorHandling(
          supportedPerson: supportedPerson,
          supportedCountry: supportedCountry,
          workingLanguage: workingLanguage,
          startDate: startDate,
          endDate: endDate,
          recipient: recipient,
          note: note,
          startTimeOfDay: startTimeOfDay,
          endTimeOfDay: endTimeOfDay,
          tasks: tasks,
          taskDescription: taskDescription,
        );
        
        if (result['success'] == true) {
          print('✅ Entry enviado exitosamente al servidor');
          return true;
        } else if (result['shouldSaveLocally'] == true) {
          print('⚠️ Error de conectividad, guardando localmente...');
          return await _saveLocallyAsFallback(
            supportedPerson, supportedCountry, workingLanguage, startDate,
            endDate, recipient, note, startTimeOfDay, endTimeOfDay, tasks, taskDescription
          );
        } else {
          print('❌ Error del servidor: ${result['error']}');
          // TODO: Mostrar error al usuario en la UI
          throw Exception(result['error'] ?? 'Error desconocido del servidor');
        }
      } else {
        // SIN INTERNET: Guardar localmente para sincronizar después
        print('📵 Sin conexión - Guardando localmente para sincronización posterior');
        return await _saveLocallyAsFallback(
          supportedPerson, supportedCountry, workingLanguage, startDate,
          endDate, recipient, note, startTimeOfDay, endTimeOfDay, tasks, taskDescription
        );
      }
      
    } catch (e) {
      print('❌ Error en submitTimeTracker: $e');
      return false;
    }
  }

  /// Enviar directamente al servidor con manejo de errores detallado
  static Future<Map<String, dynamic>> _submitDirectlyWithErrorHandling({
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        return {
          'success': false,
          'shouldSaveLocally': false,
          'error': 'No hay token de autenticación disponible'
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/time-tracker'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'personName': supportedPerson,
          'supportedCountry': supportedCountry,
          'workingLanguage': workingLanguage,
          'startDate': startDate,
          'endDate': endDate,
          'recipient': recipient,
          'note': note,
          'startTimeOfDay': startTimeOfDay,
          'endTimeOfDay': endTimeOfDay,
          'tasks': tasks,
          'taskDescription': taskDescription,
        }),
      ).timeout(const Duration(seconds: 30));

      print('API response: ${response.statusCode} ${response.body}');
      
      if (response.statusCode == 201) {
        return {'success': true};
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Errores 4xx: Problema del cliente (datos inválidos, autenticación, etc.)
        // NO deben guardarse localmente
        String errorMsg = 'Error del cliente: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorMsg;
        } catch (e) {
          // Si no se puede parsear, usar mensaje genérico
        }
        
        return {
          'success': false,
          'shouldSaveLocally': false,
          'error': errorMsg
        };
      } else {
        // Errores 5xx o otros: Problema del servidor
        // Estos SÍ pueden guardarse localmente para reintentar
        return {
          'success': false,
          'shouldSaveLocally': true,
          'error': 'Error del servidor: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('❌ Error de conectividad: $e');
      // Error de conectividad/timeout: guardar localmente
      return {
        'success': false,
        'shouldSaveLocally': true,
        'error': 'Error de conexión: $e'
      };
    }
  }


  /// Guardar localmente como respaldo (solo cuando falla el envío directo o no hay internet)
  static Future<bool> _saveLocallyAsFallback(
    String supportedPerson, String supportedCountry, String workingLanguage,
    String startDate, String endDate, String recipient, String note,
    String startTimeOfDay, String endTimeOfDay, List<String> tasks, String taskDescription
  ) async {
    try {
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

      final localId = await LocalDatabase.insertTracking(trackingEntry);
      print('✅ Entry guardado localmente con ID: $localId');
      
      // Solo notificar al SyncService cuando guardamos localmente
      SyncService().updateSyncStats();
      
      return true;
    } catch (e) {
      print('❌ Error al guardar localmente: $e');
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
