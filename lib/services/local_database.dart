// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/tracking_entry.dart';

// class LocalDatabase {
//   static Database? _db;

//   static Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await _initDB();
//     return _db!;
//   }

//   static Future<Database> _initDB() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'tracking.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE tracking (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             person TEXT,
//             country TEXT,
//             startDate TEXT,
//             endDate TEXT,
//             startTime TEXT,
//             endTime TEXT,
//             tasks TEXT,
//             description TEXT,
//             synced INTEGER
//           )
//         ''');
//       },
//     );
//   }

//   static Future<void> insertTracking(TrackingEntry entry) async {
//     final db = await database;
//     await db.insert('tracking', entry.toMap());
//   }

//   static Future<List<TrackingEntry>> getUnsyncedEntries() async {
//     final db = await database;
//     final maps = await db.query('tracking', where: 'synced = ?', whereArgs: [0]);
//     return maps.map((e) => TrackingEntry.fromMap(e)).toList();
//   }

//   static Future<void> markAsSynced(int id) async {
//     final db = await database;
//     await db.update('tracking', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
//   }
// }
