// Script simple para verificar el estado de la base de datos
// Ejecutar con: flutter run check_database.dart

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  print('🔍 ===== VERIFICANDO BASE DE DATOS OFFLINE =====');
  
  try {
    // Obtener path de la base de datos
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tracking.db');
    print('📁 Path de la base de datos: $path');
    
    // Verificar si existe el archivo
    final dbFile = File(path);
    if (!await dbFile.exists()) {
      print('❌ El archivo de base de datos no existe');
      return;
    }
    
    final size = await dbFile.length();
    print('💾 Tamaño del archivo: ${(size / 1024).toStringAsFixed(2)} KB');
    
    // Abrir base de datos
    final db = await openDatabase(path);
    
    // Verificar si existe la tabla
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'"
    );
    print('\n📋 Tablas encontradas:');
    for (final table in tables) {
      print('   - ${table['name']}');
    }
    
    // Verificar estructura de tracking_entries
    try {
      final columns = await db.rawQuery("PRAGMA table_info(tracking_entries)");
      print('\n🏗️ Estructura de tracking_entries:');
      for (final column in columns) {
        print('   - ${column['name']} (${column['type']})');
      }
    } catch (e) {
      print('⚠️ Tabla tracking_entries no encontrada');
    }
    
    // Contar registros
    int totalCount = 0;
    try {
      totalCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM tracking_entries')
      ) ?? 0;
      print('\n📊 Total de registros: $totalCount');
      
      if (totalCount > 0) {
        // Mostrar algunos registros
        final records = await db.query(
          'tracking_entries',
          orderBy: 'lastModified DESC',
          limit: 5
        );
        
        print('\n📝 Últimos 5 registros:');
        for (int i = 0; i < records.length; i++) {
          final record = records[i];
          print('   ${i + 1}. ID: ${record['id']}');
          print('      Persona: ${record['person']}');
          print('      País: ${record['country']}');
          print('      Fecha: ${record['startDate']}');
          print('      Estado: ${record['syncStatus']}');
          print('      Sincronizado: ${record['synced'] == 1 ? 'SÍ' : 'NO'}');
          print('      Modificado: ${record['lastModified']}');
          print('      ---');
        }
        
        // Estadísticas
        final syncedCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM tracking_entries WHERE synced = 1')
        ) ?? 0;
        final pendingCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM tracking_entries WHERE syncStatus = "pending"')
        ) ?? 0;
        final failedCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM tracking_entries WHERE syncStatus = "failed"')
        ) ?? 0;
        
        print('\n📈 Estadísticas:');
        print('   ✅ Sincronizados: $syncedCount');
        print('   ⏳ Pendientes: $pendingCount');
        print('   ❌ Fallidos: $failedCount');
        print('   📊 Total: $totalCount');
      }
      
    } catch (e) {
      print('❌ Error al consultar registros: $e');
    }
    
    await db.close();
    
    print('\n🎉 VERIFICACIÓN COMPLETADA');
    
    if (totalCount > 0) {
      print('✅ ¡La funcionalidad offline está funcionando!');
      print('✅ Hay registros guardados en la base de datos local');
    } else {
      print('ℹ️ No hay registros en la base de datos (esto es normal si no has hecho ningún tracking)');
    }
    
  } catch (e) {
    print('❌ Error durante la verificación: $e');
  }
}