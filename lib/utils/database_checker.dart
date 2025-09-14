import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/local_database.dart';
import '../models/tracking_entry.dart';

/// Utilidad para verificar el estado de la base de datos offline
class DatabaseChecker {
  
  /// Verificar y mostrar todas las entradas en la base de datos
  static Future<void> checkDatabaseStatus() async {
    try {
      print('🔍 ===== VERIFICACIÓN DE BASE DE DATOS OFFLINE =====');
      
      // Obtener estadísticas generales
      final stats = await LocalDatabase.getSyncStats();
      print('\n📊 ESTADÍSTICAS GENERALES:');
      print('   Total de entradas: ${stats['total']}');
      print('   Sincronizadas: ${stats['synced']}');
      print('   Pendientes: ${stats['pending']}');
      print('   Fallidas: ${stats['failed']}');
      
      // Obtener todas las entradas
      final allEntries = await LocalDatabase.getAllTrackingEntries();
      print('\n📝 TODAS LAS ENTRADAS (${allEntries.length}):');
      
      if (allEntries.isEmpty) {
        print('   ❌ No se encontraron entradas en la base de datos');
        return;
      }
      
      for (int i = 0; i < allEntries.length; i++) {
        final entry = allEntries[i];
        print('\n   --- ENTRADA ${i + 1} ---');
        print('   ID Local: ${entry.id}');
        print('   ID Servidor: ${entry.serverId ?? 'N/A'}');
        print('   Persona: ${entry.person}');
        print('   País: ${entry.country}');
        print('   Idioma: ${entry.workingLanguage}');
        print('   Destinatario: ${entry.recipient}');
        print('   Nota: ${entry.note}');
        print('   Fecha inicio: ${entry.startDate}');
        print('   Fecha fin: ${entry.endDate}');
        print('   Hora inicio: ${entry.startTime}');
        print('   Hora fin: ${entry.endTime}');
        print('   Tareas: ${entry.tasks.join(', ')}');
        print('   Descripción: ${entry.description}');
        print('   Sincronizado: ${entry.synced ? '✅ SÍ' : '❌ NO'}');
        print('   Estado: ${entry.syncStatus}');
        print('   Última modificación: ${entry.lastModified}');
      }
      
      // Verificar entradas pendientes específicamente
      final pendingEntries = await LocalDatabase.getUnsyncedEntries();
      print('\n⏳ ENTRADAS PENDIENTES DE SINCRONIZACIÓN (${pendingEntries.length}):');
      
      if (pendingEntries.isNotEmpty) {
        for (int i = 0; i < pendingEntries.length; i++) {
          final entry = pendingEntries[i];
          print('   ${i + 1}. ID: ${entry.id} | Persona: ${entry.person} | Estado: ${entry.syncStatus}');
        }
        print('\n   ✅ ¡Perfecto! Hay entradas guardadas offline esperando sincronización');
      } else {
        print('   ✅ No hay entradas pendientes (todas están sincronizadas)');
      }
      
      // Verificar entradas fallidas
      final failedEntries = await LocalDatabase.getFailedSyncEntries();
      if (failedEntries.isNotEmpty) {
        print('\n❌ ENTRADAS CON SINCRONIZACIÓN FALLIDA (${failedEntries.length}):');
        for (int i = 0; i < failedEntries.length; i++) {
          final entry = failedEntries[i];
          print('   ${i + 1}. ID: ${entry.id} | Persona: ${entry.person}');
        }
      }
      
      print('\n🎉 VERIFICACIÓN COMPLETADA');
      
    } catch (e) {
      print('❌ Error durante la verificación: $e');
    }
  }
  
  /// Verificar la estructura de la base de datos
  static Future<void> checkDatabaseStructure() async {
    try {
      print('\n🏗️ VERIFICANDO ESTRUCTURA DE BASE DE DATOS...');
      
      final db = await LocalDatabase.database;
      
      // Verificar si existe la tabla
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tracking_entries'"
      );
      
      if (tables.isEmpty) {
        print('❌ La tabla tracking_entries no existe');
        return;
      }
      
      print('✅ Tabla tracking_entries encontrada');
      
      // Obtener información de las columnas
      final columns = await db.rawQuery("PRAGMA table_info(tracking_entries)");
      print('\n📋 ESTRUCTURA DE LA TABLA:');
      
      for (final column in columns) {
        print('   - ${column['name']} (${column['type']}) ${column['notnull'] == 1 ? 'NOT NULL' : 'NULL'}');
      }
      
      // Verificar el archivo de base de datos
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'tracking.db'));
      
      if (await dbFile.exists()) {
        final size = await dbFile.length();
        print('\n💾 ARCHIVO DE BASE DE DATOS:');
        print('   Ubicación: ${dbFile.path}');
        print('   Tamaño: ${(size / 1024).toStringAsFixed(2)} KB');
        print('   ✅ El archivo existe y tiene contenido');
      } else {
        print('❌ El archivo de base de datos no existe');
      }
      
    } catch (e) {
      print('❌ Error verificando estructura: $e');
    }
  }
  
  /// Verificación completa
  static Future<void> fullCheck() async {
    await checkDatabaseStructure();
    await checkDatabaseStatus();
  }
}