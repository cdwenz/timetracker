import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tracking_entry.dart';

class LocalDatabase {
  static Database? _db;
  static const String _databaseName = 'tracking.db';
  static const int _databaseVersion = 2;
  
  // Tabla de tracking entries
  static const String _trackingTable = 'tracking_entries';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        // Crear tabla de tracking entries
        await db.execute('''
          CREATE TABLE $_trackingTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            serverId TEXT,
            person TEXT NOT NULL,
            country TEXT NOT NULL,
            workingLanguage TEXT NOT NULL,
            recipient TEXT NOT NULL,
            note TEXT NOT NULL,
            startDate TEXT NOT NULL,
            endDate TEXT NOT NULL,
            startTime TEXT NOT NULL,
            endTime TEXT NOT NULL,
            tasks TEXT NOT NULL,
            description TEXT NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0,
            lastModified TEXT NOT NULL,
            syncStatus TEXT NOT NULL DEFAULT 'pending'
          )
        ''');

        // Crear tabla de sincronización
        await db.execute('''
          CREATE TABLE sync_status (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tableName TEXT NOT NULL,
            lastSyncTime TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migrar de versión 1 a 2
          await db.execute('ALTER TABLE tracking ADD COLUMN serverId TEXT');
          await db.execute('ALTER TABLE tracking ADD COLUMN workingLanguage TEXT DEFAULT ""');
          await db.execute('ALTER TABLE tracking ADD COLUMN recipient TEXT DEFAULT ""');
          await db.execute('ALTER TABLE tracking ADD COLUMN note TEXT DEFAULT ""');
          await db.execute('ALTER TABLE tracking ADD COLUMN lastModified TEXT DEFAULT ""');
          await db.execute('ALTER TABLE tracking ADD COLUMN syncStatus TEXT DEFAULT "pending"');
        }
      },
    );
  }

  // CRUD Operations para TrackingEntry
  
  /// Insertar un nuevo tracking entry
  static Future<int> insertTracking(TrackingEntry entry) async {
    final db = await database;
    try {
      final id = await db.insert(_trackingTable, entry.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('✅ Tracking entry insertado localmente con ID: $id');
      return id;
    } catch (e) {
      print('❌ Error al insertar tracking entry: $e');
      rethrow;
    }
  }

  /// Obtener todos los tracking entries
  static Future<List<TrackingEntry>> getAllTrackingEntries() async {
    final db = await database;
    try {
      final maps = await db.query(_trackingTable, orderBy: 'lastModified DESC');
      return maps.map((map) => TrackingEntry.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error al obtener tracking entries: $e');
      return [];
    }
  }

  /// Obtener entries no sincronizados
  static Future<List<TrackingEntry>> getUnsyncedEntries() async {
    final db = await database;
    try {
      final maps = await db.query(
        _trackingTable,
        where: 'synced = ? OR syncStatus = ?',
        whereArgs: [0, 'pending'],
        orderBy: 'lastModified ASC',
      );
      return maps.map((map) => TrackingEntry.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error al obtener entries no sincronizados: $e');
      return [];
    }
  }

  /// Obtener entries fallidos en sincronización
  static Future<List<TrackingEntry>> getFailedSyncEntries() async {
    final db = await database;
    try {
      final maps = await db.query(
        _trackingTable,
        where: 'syncStatus = ?',
        whereArgs: ['failed'],
        orderBy: 'lastModified ASC',
      );
      return maps.map((map) => TrackingEntry.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error al obtener entries fallidos: $e');
      return [];
    }
  }

  /// Marcar como sincronizado
  static Future<void> markAsSynced(int localId, String serverId) async {
    final db = await database;
    try {
      await db.update(
        _trackingTable,
        {
          'synced': 1,
          'serverId': serverId,
          'syncStatus': 'synced',
          'lastModified': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [localId],
      );
      print('✅ Entry marcado como sincronizado: local=$localId, server=$serverId');
    } catch (e) {
      print('❌ Error al marcar como sincronizado: $e');
      rethrow;
    }
  }

  /// Marcar sincronización como fallida
  static Future<void> markSyncFailed(int localId) async {
    final db = await database;
    try {
      await db.update(
        _trackingTable,
        {
          'syncStatus': 'failed',
          'lastModified': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [localId],
      );
      print('⚠️ Entry marcado como sincronización fallida: $localId');
    } catch (e) {
      print('❌ Error al marcar sync fallido: $e');
      rethrow;
    }
  }

  /// Actualizar tracking entry
  static Future<void> updateTrackingEntry(TrackingEntry entry) async {
    final db = await database;
    try {
      await db.update(
        _trackingTable,
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
      print('✅ Tracking entry actualizado: ${entry.id}');
    } catch (e) {
      print('❌ Error al actualizar tracking entry: $e');
      rethrow;
    }
  }

  /// Eliminar tracking entry
  static Future<void> deleteTrackingEntry(int id) async {
    final db = await database;
    try {
      await db.delete(
        _trackingTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('✅ Tracking entry eliminado: $id');
    } catch (e) {
      print('❌ Error al eliminar tracking entry: $e');
      rethrow;
    }
  }

  /// Obtener estadísticas de sincronización
  static Future<Map<String, int>> getSyncStats() async {
    final db = await database;
    try {
      final total = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_trackingTable')) ?? 0;
      final synced = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_trackingTable WHERE synced = 1')) ?? 0;
      final pending = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_trackingTable WHERE syncStatus = "pending"')) ?? 0;
      final failed = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_trackingTable WHERE syncStatus = "failed"')) ?? 0;
      
      return {
        'total': total,
        'synced': synced,
        'pending': pending,
        'failed': failed,
      };
    } catch (e) {
      print('❌ Error al obtener estadísticas de sync: $e');
      return {'total': 0, 'synced': 0, 'pending': 0, 'failed': 0};
    }
  }

  /// Limpiar entries sincronizados más antiguos de X días
  static Future<void> cleanOldSyncedEntries({int daysOld = 30}) async {
    final db = await database;
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final deletedCount = await db.delete(
        _trackingTable,
        where: 'synced = 1 AND lastModified < ?',
        whereArgs: [cutoffDate.toIso8601String()],
      );
      print('🧹 Limpieza: $deletedCount entries sincronizados antiguos eliminados');
    } catch (e) {
      print('❌ Error en limpieza de entries antiguos: $e');
    }
  }

  /// Cerrar base de datos
  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      print('🔐 Base de datos local cerrada');
    }
  }

  /// Reset completo de la base de datos (solo para desarrollo)
  static Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
    
    await deleteDatabase(path);
    print('🔄 Base de datos reseteada completamente');
  }
}
