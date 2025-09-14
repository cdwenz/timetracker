import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tracking_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'timetracker_offline.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla para tracking entries offline
    await db.execute('''
      CREATE TABLE tracking_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local_id TEXT NOT NULL UNIQUE,
        server_id TEXT,
        person_name TEXT NOT NULL,
        supported_country TEXT NOT NULL,
        working_language TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        start_time_of_day TEXT,
        end_time_of_day TEXT,
        tasks TEXT NOT NULL,
        task_description TEXT,
        note TEXT,
        recipient TEXT,
        user_id TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced_at TEXT,
        retry_count INTEGER DEFAULT 0
      )
    ''');

    // Tabla para configuraciones offline
    await db.execute('''
      CREATE TABLE sync_metadata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Índices para optimizar consultas
    await db.execute('CREATE INDEX idx_sync_status ON tracking_entries(sync_status)');
    await db.execute('CREATE INDEX idx_created_at ON tracking_entries(created_at)');
    await db.execute('CREATE INDEX idx_server_id ON tracking_entries(server_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Para futuras versiones
    if (oldVersion < newVersion) {
      // Aquí irían las migraciones
    }
  }

  // ================== TRACKING ENTRIES ==================

  /// Insertar un nuevo tracking entry offline
  Future<int> insertTrackingEntry(Map<String, dynamic> entry) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    entry['created_at'] = now;
    entry['updated_at'] = now;
    entry['sync_status'] = 'pending';
    
    return await db.insert('tracking_entries', entry);
  }

  /// Obtener todos los tracking entries (con filtros opcionales)
  Future<List<Map<String, dynamic>>> getTrackingEntries({
    String? syncStatus,
    int? limit,
    String? orderBy,
  }) async {
    final db = await database;
    
    String sql = 'SELECT * FROM tracking_entries';
    List<dynamic> whereArgs = [];
    
    if (syncStatus != null) {
      sql += ' WHERE sync_status = ?';
      whereArgs.add(syncStatus);
    }
    
    sql += ' ORDER BY ${orderBy ?? 'created_at DESC'}';
    
    if (limit != null) {
      sql += ' LIMIT ?';
      whereArgs.add(limit);
    }
    
    return await db.rawQuery(sql, whereArgs);
  }

  /// Obtener entries pendientes de sincronización
  Future<List<Map<String, dynamic>>> getPendingEntries() async {
    return await getTrackingEntries(syncStatus: 'pending');
  }

  /// Marcar entry como sincronizado
  Future<int> markAsSynced(int localId, String serverId) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.update(
      'tracking_entries',
      {
        'server_id': serverId,
        'sync_status': 'synced',
        'synced_at': now,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  /// Marcar entry como error de sincronización
  Future<int> markAsSyncError(int localId, [String? errorMsg]) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.update(
      'tracking_entries',
      {
        'sync_status': 'error',
        'updated_at': now,
        'retry_count': Sqflite.firstIntValue(await db.rawQuery(
          'SELECT retry_count FROM tracking_entries WHERE id = ?', 
          [localId]
        )) ?? 0 + 1,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  /// Reintentar sincronización (marcar como pending)
  Future<int> retrySync(int localId) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.update(
      'tracking_entries',
      {
        'sync_status': 'pending',
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  /// Eliminar entry
  Future<int> deleteTrackingEntry(int localId) async {
    final db = await database;
    return await db.delete(
      'tracking_entries',
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  // ================== METADATA ==================

  /// Guardar metadata de sincronización
  Future<void> setMetadata(String key, String value) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    await db.insert(
      'sync_metadata',
      {'key': key, 'value': value, 'updated_at': now},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtener metadata
  Future<String?> getMetadata(String key) async {
    final db = await database;
    final result = await db.query(
      'sync_metadata',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    
    return result.isNotEmpty ? result.first['value'] as String : null;
  }

  // ================== UTILIDADES ==================

  /// Obtener estadísticas de sincronización
  Future<Map<String, int>> getSyncStats() async {
    final db = await database;
    
    final pending = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM tracking_entries WHERE sync_status = ?', 
      ['pending']
    )) ?? 0;
    
    final synced = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM tracking_entries WHERE sync_status = ?', 
      ['synced']
    )) ?? 0;
    
    final errors = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM tracking_entries WHERE sync_status = ?', 
      ['error']
    )) ?? 0;
    
    return {
      'pending': pending,
      'synced': synced,
      'error': errors,
      'total': pending + synced + errors,
    };
  }

  /// Limpiar base de datos (para testing o reset)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('tracking_entries');
    await db.delete('sync_metadata');
  }

  /// Cerrar base de datos
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}