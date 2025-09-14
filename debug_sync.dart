import 'package:flutter/material.dart';
import 'lib/services/sync_service.dart';
import 'lib/services/connectivity_service.dart';
import 'lib/services/local_database.dart';
import 'lib/services/time_tracker_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔧 INICIANDO DEBUG DE SINCRONIZACIÓN...\n');
  
  try {
    // 1. Verificar conectividad
    print('📡 1. Verificando conectividad...');
    final isConnected = await ConnectivityService.quickConnectivityCheck();
    print('   Estado de conexión: ${isConnected ? "✅ CONECTADO" : "❌ SIN CONEXIÓN"}');
    
    // 2. Verificar token de autenticación
    print('\n🔐 2. Verificando token de autenticación...');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      print('   Token: ✅ Disponible (${token.substring(0, 20)}...)');
    } else {
      print('   Token: ❌ NO DISPONIBLE');
    }
    
    // 3. Verificar base de datos local
    print('\n💾 3. Verificando base de datos local...');
    final stats = await LocalDatabase.getSyncStats();
    print('   Total entries: ${stats['total']}');
    print('   Sincronizadas: ${stats['synced']}');
    print('   Pendientes: ${stats['pending']}');
    print('   Fallidas: ${stats['failed']}');
    
    // 4. Obtener entradas pendientes
    print('\n📋 4. Obteniendo entradas pendientes...');
    final pendingEntries = await LocalDatabase.getUnsyncedEntries();
    print('   Entradas pendientes encontradas: ${pendingEntries.length}');
    
    if (pendingEntries.isNotEmpty) {
      for (int i = 0; i < (pendingEntries.length > 3 ? 3 : pendingEntries.length); i++) {
        final entry = pendingEntries[i];
        print('   Entry ${i + 1}: ID=${entry.id}, Status=${entry.syncStatus}, Person=${entry.person}');
      }
    }
    
    // 5. Probar sincronización si hay conexión y token
    if (isConnected && token != null && pendingEntries.isNotEmpty) {
      print('\n🔄 5. Probando sincronización...');
      
      final syncService = SyncService();
      await syncService.initialize();
      
      print('   Iniciando sincronización forzada...');
      final syncResult = await syncService.forcSync();
      
      print('   Resultado de sincronización: ${syncResult ? "✅ ÉXITO" : "❌ FALLO"}');
      print('   Estado final: ${syncService.status}');
      print('   Mensaje: ${syncService.lastSyncMessage}');
      
      // Verificar estadísticas después de sync
      final newStats = await LocalDatabase.getSyncStats();
      print('\n   📊 Estadísticas después del sync:');
      print('   Sincronizadas: ${newStats['synced']}');
      print('   Pendientes: ${newStats['pending']}');
      print('   Fallidas: ${newStats['failed']}');
      
    } else {
      print('\n⚠️ 5. No se puede probar sincronización:');
      if (!isConnected) print('   - Sin conexión a internet');
      if (token == null) print('   - Sin token de autenticación');
      if (pendingEntries.isEmpty) print('   - No hay entradas pendientes');
    }
    
    print('\n🎉 DEBUG COMPLETADO');
    
  } catch (e) {
    print('❌ ERROR EN DEBUG: $e');
    print('Stack trace: ${StackTrace.current}');
  }
}