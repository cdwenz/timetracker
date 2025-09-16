// lib/services/reports_metrics_service.dart
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'auth_service.dart';

/// Filtros para la pantalla de detalle
enum ReportsDetailFilter { team, me, compare, trend }

/// DTOs simples para la UI del dashboard
class ReportsDashboardData {
  final int teamCount;
  final int meCount;
  final List<DailyCompare> dailyCompare; // barras: Yo vs Equipo (por día)
  final List<DailyPoint> myTrend; // línea: Yo (por día)

  ReportsDashboardData({
    required this.teamCount,
    required this.meCount,
    required this.dailyCompare,
    required this.myTrend,
  });
}

class DailyCompare {
  final DateTime day;
  final int myCount;
  final int teamCount;
  DailyCompare(this.day, this.myCount, this.teamCount);
}

class DailyPoint {
  final DateTime day;
  final int count;
  DailyPoint(this.day, this.count);
}

/// Servicio **nuevo** para métricas del Dashboard de Reports.
/// No modifica tu `time_tracker_service.dart`.
class ReportsMetricsService {
  final ApiService _api;
  ReportsMetricsService(this._api);

  // ====== Helpers de fechas ======
  String _isoDateOnly(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  ({DateTime from, DateTime to}) last30DaysRange() {
    final now = DateTime.now();
    final to = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final from = to.subtract(const Duration(days: 29));
    return (from: from, to: to);
  }

  List<DateTime> _daysRange(DateTime fromDate, DateTime toDate) {
    final base = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final end = DateTime(toDate.year, toDate.month, toDate.day);
    final days = end.difference(base).inDays + 1;
    return List<DateTime>.generate(days, (i) => base.add(Duration(days: i)));
  }

  // ====== HTTP base ======
  Future<List<Map<String, dynamic>>> _fetchEntries({
    String? userId,
    required DateTime fromDate,
    required DateTime toDate,
    String? supportedCountry,
    int page = 1,
    int pageSize = 100,
  }) async {
    final query = <String, dynamic>{
      'fromDate': _isoDateOnly(fromDate),
      'toDate': _isoDateOnly(toDate),
      'page': page,
      'pageSize': pageSize,
      if (userId != null && userId.isNotEmpty) 'userId': userId,
      if (supportedCountry != null && supportedCountry.isNotEmpty)
        'supportedCountry': supportedCountry,
    };

    print("QUERY: $query");

    final json = await ApiService.getRequest('/time-tracker', query: query);

    print("RESPONSE JSON: $json");

    // Tolerante a { result | results | data | items | entries | timeEntries } o List
    if (json is Map<String, dynamic>) {
      final candidates = [
        json['result'],
        json['results'],
        json['data'],
        json['items'],
        json['entries'],
        json['timeEntries'],
      ];
      for (final c in candidates) {
        if (c is List) return c.cast<Map<String, dynamic>>();
      }
    }
    if (json is List) return json.cast<Map<String, dynamic>>();
    return <Map<String, dynamic>>[];
  }

  Map<String, int> _countByDay(List<Map<String, dynamic>> list) {
    final map = <String, int>{};
    for (final e in list) {
      final raw = (e['startDate'] ?? e['createdAt'] ?? '').toString();
      if (raw.isEmpty) continue;
      final dt = DateTime.tryParse(raw);
      if (dt == null) continue;
      final k = _isoDateOnly(dt);
      map[k] = (map[k] ?? 0) + 1;
    }
    return map;
  }

  // ====== API pública para el dashboard ======
  Future<ReportsDashboardData> loadDashboardLast30Days({
    String? supportedCountry,
  }) async {
    final uid = await AuthService.currentUserId();
    if (uid == null || uid.isEmpty) {
      throw Exception(
          'No se pudo obtener el userId actual (AuthService.currentUserId).');
    }

    final range = last30DaysRange();
    final from = range.from;
    final to = range.to;

    final team = await _fetchEntries(
      fromDate: from,
      toDate: to,
      supportedCountry: supportedCountry,
    );
    final mine = await _fetchEntries(
      userId: uid,
      fromDate: from,
      toDate: to,
      supportedCountry: supportedCountry,
    );

    final teamCount = team.length;
    final meCount = mine.length;

    final teamByDay = _countByDay(team);
    final meByDay = _countByDay(mine);
    final days = _daysRange(from, to);

    final dailyCompare = <DailyCompare>[];
    final myTrend = <DailyPoint>[];

    for (final day in days) {
      final k = _isoDateOnly(day);
      final myC = meByDay[k] ?? 0;
      final teamC = teamByDay[k] ?? 0;
      dailyCompare.add(DailyCompare(day, myC, teamC));
      myTrend.add(DailyPoint(day, myC));
    }

    return ReportsDashboardData(
      teamCount: teamCount,
      meCount: meCount,
      dailyCompare: dailyCompare,
      myTrend: myTrend,
    );
  }

  // ====== API pública para la pantalla de detalle ======
  Future<List<Map<String, dynamic>>> loadDetailLast30Days({
    required ReportsDetailFilter filter,
    String? supportedCountry,
  }) async {
    final range = last30DaysRange();
    final from = range.from;
    final to = range.to;

    switch (filter) {
      case ReportsDetailFilter.team:
        return _fetchEntries(
          fromDate: from,
          toDate: to,
          supportedCountry: supportedCountry,
        );

      case ReportsDetailFilter.me:
      case ReportsDetailFilter.compare:
      case ReportsDetailFilter.trend:
        final uid = await AuthService.currentUserId();
        if (uid == null || uid.isEmpty) {
          throw Exception('No se pudo obtener el userId actual.');
        }
        return _fetchEntries(
          userId: uid,
          fromDate: from,
          toDate: to,
          supportedCountry: supportedCountry,
        );
    }
  }
}
