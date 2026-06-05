import '../models/tracking_entry.dart';

/// Web stub: no hay sqflite en navegador. Esta app en web envia los reportes
/// directamente al backend; no hay cola offline.
class LocalDatabase {
  static Future<dynamic> get database async => null;

  static Future<int> insertTracking(TrackingEntry entry) async => 0;

  static Future<List<TrackingEntry>> getAllTrackingEntries() async => const [];

  static Future<List<TrackingEntry>> getUnsyncedEntries() async => const [];

  static Future<List<TrackingEntry>> getFailedSyncEntries() async => const [];

  static Future<void> markAsSynced(int localId, String serverId) async {}

  static Future<void> markSyncFailed(int localId) async {}

  static Future<void> markSyncFailedPermanently(int localId, String errorMsg) async {}

  static Future<void> updateTrackingEntry(TrackingEntry entry) async {}

  static Future<void> deleteTrackingEntry(int id) async {}

  static Future<Map<String, int>> getSyncStats() async => const {
        'total': 0,
        'synced': 0,
        'pending': 0,
        'failed': 0,
        'failed_permanent': 0,
      };

  static Future<void> cleanOldSyncedEntries({int daysOld = 30}) async {}

  static Future<void> close() async {}

  static Future<void> resetDatabase() async {}
}
