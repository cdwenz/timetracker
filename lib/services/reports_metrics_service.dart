// lib/services/reports_metrics_service.dart
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'auth_service.dart';
import 'reports_service.dart';
import '../models/regional_reports_models.dart';

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
    bool? myTeam, // Nuevo parámetro para filtrar por equipo
    int page = 1,
    int pageSize = 100,
  }) async {
    final query = <String, dynamic>{
      'fromDate': _isoDateOnly(fromDate),
      'toDate': _isoDateOnly(toDate),
      'page': page,
      'pageSize': pageSize,
      'returnMeta': false,  // Devolver array simple sin metadatos
      if (userId != null && userId.isNotEmpty) 'userId': userId,  // Backend filtra por userId
      if (supportedCountry != null && supportedCountry.isNotEmpty)
        'supportedCountry': supportedCountry,
      if (myTeam == true) 'myTeam': 'true', // Nuevo filtro de equipo
    };

    print("🔍 FETCHING ENTRIES:");
    print("   Query: $query");

    final json = await ApiService.getRequest('/time-tracker', query: query);

    print("📥 API RESPONSE:");
    print("   Type: ${json.runtimeType}");
    print("   Content: $json");

    // Tolerante a { data, result, results, items, entries, timeEntries } o List
    if (json is Map<String, dynamic>) {
      final candidates = [
        json['data'],        // NestJS usa 'data' por defecto
        json['result'],
        json['results'],
        json['items'],
        json['entries'],
        json['timeEntries'],
      ];
      for (final c in candidates) {
        if (c is List) return c.cast<Map<String, dynamic>>();
      }
      
      // Si no hay array, podría estar en el root level
      if (json['meta'] != null && json['data'] is List) {
        return (json['data'] as List).cast<Map<String, dynamic>>();
      }
    }
    if (json is List) {
      final result = json.cast<Map<String, dynamic>>();
      print("✅ PARSED AS LIST: ${result.length} items");
      if (result.isNotEmpty) {
        print("   First item keys: ${result.first.keys.toList()}");
      }
      return result;
    }
    
    print("❌ NO VALID DATA FOUND - returning empty list");
    return <Map<String, dynamic>>[];
  }

  Map<String, int> _countByDay(List<Map<String, dynamic>> list) {
    final map = <String, int>{};
    print("🗓️ COUNTING BY DAY: ${list.length} entries");
    for (final e in list) {
      // Campos de fecha del backend NestJS: startDate, createdAt, updatedAt
      final raw = (e['startDate'] ?? e['createdAt'] ?? e['updatedAt'] ?? e['date'] ?? '').toString();
      if (raw.isEmpty) continue;
      final dt = DateTime.tryParse(raw);
      if (dt == null) continue;
      final k = _isoDateOnly(dt);
      map[k] = (map[k] ?? 0) + 1;
      print("   Entry: $k -> ${map[k]}");
    }
    print("   Final counts: $map");
    return map;
  }

  // ====== Helpers para lógica temporal de filtrado ======
  
  /// Filtra registros que pertenecen al usuario actual
  List<Map<String, dynamic>> _filterMyEntries(
    List<Map<String, dynamic>> allEntries, 
    String uid
  ) {
    final userIdInt = int.tryParse(uid);
    return allEntries.where((entry) {
      final entryUserId = entry['userId'] is int 
          ? entry['userId'] 
          : int.tryParse(entry['userId']?.toString() ?? '') ??
            int.tryParse(entry['createdBy']?.toString() ?? '') ??
            int.tryParse(entry['user_id']?.toString() ?? '');
      return entryUserId == userIdInt;
    }).toList();
  }
  
  /// Filtra registros del "equipo" según el rol del usuario
  List<Map<String, dynamic>> _filterTeamEntries(
    List<Map<String, dynamic>> allEntries, 
    String uid, 
    String? userRole
  ) {
    print("⚠️  BACKEND LIMITATION: Current backend restricts FIELD_MANAGER to own records only");
    print("⚠️  EXPECTED: FIELD_MANAGER should see team records, but backend needs fix");
    
    if (userRole == 'ADMIN') {
      // ADMIN puede ver todos los registros de la organización
      print("✅ ADMIN: Showing all organization records");
      return allEntries;
    } else if (userRole == 'FIELD_MANAGER') {
      // 🚨 PROBLEMA: Backend actual limita FIELD_MANAGER a sus propios registros
      // 📝 TODO: Una vez arreglado el backend, aquí debería mostrar registros del equipo
      print("🚨 FIELD_MANAGER: Should see team records, but backend limits to own records");
      print("📝 See TEAM_FILTERING_CHANGES.md for backend fix needed");
      return _filterMyEntries(allEntries, uid);
    } else {
      // USER solo ve sus propios registros (comportamiento correcto)
      print("✅ USER: Correctly showing only own records");
      return _filterMyEntries(allEntries, uid);
    }
  }
  
  /// Descripción de la lógica de filtrado para logs
  String _getFilteringLogicDescription(String? userRole) {
    if (userRole == 'ADMIN') {
      return 'ADMIN - Yo: sólo míos, Equipo: todos (correcto)';
    } else if (userRole == 'FIELD_MANAGER') {
      return 'FIELD_MANAGER - Yo y Equipo: sólo míos (🚨 BACKEND BUG)';
    } else {
      return '${userRole ?? "USER"} - Yo y Equipo: sólo míos (correcto)';
    }
  }

  // ====== API pública para el dashboard ======
  Future<ReportsDashboardData> loadDashboardLast30Days({
    String? supportedCountry,
  }) async {
    final uid = await AuthService.currentUserId();
    final userRole = await AuthService.currentUserRole();
    
    if (uid == null || uid.isEmpty) {
      throw Exception(
          'No se pudo obtener el userId actual (AuthService.currentUserId).');
    }

    final range = last30DaysRange();
    final from = range.from;
    final to = range.to;

    print("📊 DASHBOARD DATA (REAL BACKEND CALLS):");
    print("   Current user ID: $uid");
    print("   Current user role: $userRole");

    // Obtener MIS datos (llamada sin myTeam)
    final mine = await _fetchEntries(
      userId: uid, // FILTRAR POR MI USUARIO
      fromDate: from,
      toDate: to,
      supportedCountry: supportedCountry,
      myTeam: false, // Explícitamente NO pedir datos del equipo
    );
    
    // Obtener datos del EQUIPO (llamada con myTeam=true)
    final team = await _fetchEntries(
      userId: userRole == 'ADMIN' ? null : uid, // ADMIN ve todos, otros solo equipo
      fromDate: from,
      toDate: to,
      supportedCountry: supportedCountry,
      myTeam: true, // Pedir datos del equipo
    );
    
    print("   My entries: ${mine.length}");
    print("   Team entries: ${team.length}");
    
    if (mine.length == team.length) {
      print("⚠️  WARNING: Same count - possible backend limitation or no team membership");
    } else {
      print("✅ SUCCESS: Different counts - backend working correctly");
    }

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
    final uid = await AuthService.currentUserId();
    final userRole = await AuthService.currentUserRole();
    
    if (uid == null || uid.isEmpty) {
      throw Exception('No se pudo obtener el userId actual.');
    }
    
    final range = last30DaysRange();
    final from = range.from;
    final to = range.to;

    print("🔍 DETAIL DATA (REAL BACKEND CALLS):");
    print("   Filter: $filter");
    print("   User ID: $uid, Role: $userRole");

    switch (filter) {
      case ReportsDetailFilter.team:
        // Datos del equipo - llamada con myTeam=true
        final teamEntries = await _fetchEntries(
          userId: userRole == 'ADMIN' ? null : uid, // ADMIN ve todos
          fromDate: from,
          toDate: to,
          supportedCountry: supportedCountry,
          myTeam: true, // Pedir datos del equipo
        );
        print("   Returning team entries: ${teamEntries.length}");
        return teamEntries;

      case ReportsDetailFilter.me:
      case ReportsDetailFilter.compare:
      case ReportsDetailFilter.trend:
        // Solo mis datos - llamada sin myTeam
        final myEntries = await _fetchEntries(
          userId: uid, // FILTRAR POR MI USUARIO
          fromDate: from,
          toDate: to,
          supportedCountry: supportedCountry,
          myTeam: false, // Solo mis datos
        );
        print("   Returning my entries: ${myEntries.length}");
        return myEntries;
    }
  }

  // ====== API para reportes regionales ======

  /// Obtiene el dashboard completo con datos regionales según el rol del usuario
  Future<DashboardSummary?> loadEnhancedDashboard({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
  }) async {
    final userRole = await AuthService.currentUserRole();
    
    // Solo roles con acceso a reportes regionales
    if (!['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole)) {
      return null;
    }

    try {
      final dashboard = await ReportsService.getDashboardSummary(
        startDate: startDate,
        endDate: endDate,
        countries: countries,
        languages: languages,
      );
      return dashboard;
    } catch (e) {
      print('Error loading enhanced dashboard: $e');
      return null;
    }
  }

  /// Obtiene las regiones disponibles según el rol del usuario
  Future<List<RegionInfo>> getAccessibleRegions() async {
    final userRole = await AuthService.currentUserRole();
    
    if (!['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole)) {
      return [];
    }

    try {
      return await ReportsService.getAvailableRegions();
    } catch (e) {
      print('Error loading accessible regions: $e');
      return [];
    }
  }

  /// Obtiene el resumen de una región específica (con validación de acceso)
  Future<RegionalSummary?> getRegionalSummary(
    String regionId, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
  }) async {
    final userRole = await AuthService.currentUserRole();
    
    if (!['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole)) {
      throw Exception('Sin permisos para acceder a reportes regionales');
    }

    try {
      return await ReportsService.getRegionalSummary(
        regionId,
        startDate: startDate,
        endDate: endDate,
        countries: countries,
        languages: languages,
      );
    } catch (e) {
      print('Error loading regional summary: $e');
      return null;
    }
  }

  /// Compara múltiples regiones (con validación de acceso)
  Future<RegionalComparison?> compareRegions(
    List<String> regionIds, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
  }) async {
    final userRole = await AuthService.currentUserRole();
    
    if (!['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole)) {
      throw Exception('Sin permisos para comparar regiones');
    }

    if (regionIds.length < 2 || regionIds.length > 10) {
      throw Exception('Se requieren entre 2 y 10 regiones para comparar');
    }

    try {
      return await ReportsService.getRegionalComparison(
        regionIds,
        startDate: startDate,
        endDate: endDate,
        countries: countries,
        languages: languages,
      );
    } catch (e) {
      print('Error comparing regions: $e');
      return null;
    }
  }

  /// Obtiene el desglose por países
  Future<CountryBreakdown?> getCountryBreakdown({
    String? regionId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
  }) async {
    final userRole = await AuthService.currentUserRole();
    
    if (!['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole)) {
      return null;
    }

    try {
      return await ReportsService.getCountryBreakdown(
        regionId: regionId,
        startDate: startDate,
        endDate: endDate,
        countries: countries,
        take: 50, // Más datos para análisis
      );
    } catch (e) {
      print('Error loading country breakdown: $e');
      return null;
    }
  }

  /// Obtiene la distribución de idiomas
  Future<LanguageDistribution?> getLanguageDistribution({
    String? regionId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
  }) async {
    final userRole = await AuthService.currentUserRole();
    
    if (!['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole)) {
      return null;
    }

    try {
      return await ReportsService.getLanguageDistribution(
        regionId: regionId,
        startDate: startDate,
        endDate: endDate,
        countries: countries,
        languages: languages,
        take: 50, // Más datos para análisis
      );
    } catch (e) {
      print('Error loading language distribution: $e');
      return null;
    }
  }

  /// Verifica si el usuario actual puede acceder a reportes regionales
  Future<bool> canAccessRegionalReports() async {
    final userRole = await AuthService.currentUserRole();
    return ['SUPER', 'ADMIN', 'REGIONAL_MANAGER', 'FIELD_MANAGER'].contains(userRole);
  }

  /// Obtiene una descripción del tipo de acceso del usuario actual
  Future<String> getUserAccessDescription() async {
    final userRole = await AuthService.currentUserRole();
    
    switch (userRole) {
      case 'SUPER':
        return 'Acceso completo a todas las organizaciones y regiones';
      case 'ADMIN':
        return 'Acceso completo a toda la organización';
      case 'REGIONAL_MANAGER':
        return 'Acceso a las regiones que maneja';
      case 'FIELD_MANAGER':
        return 'Acceso a las regiones de sus equipos';
      default:
        return 'Acceso solo a datos personales';
    }
  }
}
