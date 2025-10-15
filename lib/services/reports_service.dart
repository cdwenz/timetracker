// lib/services/reports_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihadi_time_tracker/models/tracking.dart';
import '../models/regional_reports_models.dart';

class ReportsService {
  static const String baseUrl = 'https://timetracker-nest-mvp-production.up.railway.app/api';

  // ==== Helpers de sesión ====
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // Soporta ambos nombres por compatibilidad
    return prefs.getString('access_token') ?? prefs.getString('token');
  }

  static Map<String, String> _authHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  static Uri _buildUri(String path, Map<String, dynamic?> params) {
    final qp = <String, String>{};
    params.forEach((k, v) {
      if (v == null) return;
      if (v is DateTime) {
        // El backend espera YYYY-MM-DD (ajusta si necesita ISO)
        qp[k] = v.toIso8601String().split('T').first;
      } else if (v is List) {
        // Para listas, unir con comas (formato esperado por el backend)
        qp[k] = v.join(',');
      } else {
        qp[k] = v.toString();
      }
    });
    return Uri.parse('$baseUrl$path').replace(queryParameters: qp);
  }

  // ==== Modelo de respuesta paginada ====
  // Útil si tu backend devuelve total, page, pageSize. Si no, los dejamos con fallback.
  static PaginatedTrackers _parsePaginated(dynamic jsonBody) {
    // Intentamos detectar la lista en distintos contenedores
    List items;
    if (jsonBody is List) {
      items = jsonBody;
    } else if (jsonBody is Map && jsonBody['items'] is List) {
      items = jsonBody['items'];
    } else if (jsonBody is Map && jsonBody['data'] is List) {
      items = jsonBody['data'];
    } else if (jsonBody is Map && jsonBody['trackings'] is List) {
      items = jsonBody['trackings'];
    } else if (jsonBody is Map && jsonBody['records'] is List) {
      items = jsonBody['records'];
    } else {
      items = const [];
    }

    final list = items
        .map<Tracking>((e) => Tracking.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Extra meta si existe
    int? total;
    int? page;
    int? pageSize;

    if (jsonBody is Map) {
      total = (jsonBody['total'] ?? jsonBody['count']) is int
          ? (jsonBody['total'] ?? jsonBody['count']) as int
          : null;
      page = jsonBody['page'] is int ? jsonBody['page'] as int : null;
      pageSize =
          jsonBody['pageSize'] is int ? jsonBody['pageSize'] as int : null;
    }

    return PaginatedTrackers(
      items: list,
      total: total ?? list.length,
      page: page ?? 1,
      pageSize: pageSize ?? list.length,
    );
  }

  /// Consulta de trackers con filtros y paginación.
  ///
  /// - [userId]       : UUID del usuario (opcional)
  /// - [fromDate]/[toDate] : Rango de fechas (opcional) — formato YYYY-MM-DD
  /// - [supportedCountry]  : Código de país (ej: 'AR') (opcional)
  /// - [page]/[pageSize]   : Paginación (por defecto 1/20)
  ///
  /// Devuelve una estructura con items + total + page + pageSize.
  static Future<PaginatedTrackers> fetchTrackers({
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
    String? supportedCountry,
    int page = 1,
    int pageSize = 20,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final uri = _buildUri('/time-tracker', {
      'userId': userId,
      'fromDate': fromDate,
      'toDate': toDate,
      'supportedCountry': supportedCountry,
      'page': page,
      'pageSize': pageSize,
    });

    final res = await http.get(uri, headers: _authHeaders(token));

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      // Algunos endpoints devuelven { ok, message, result }, otros directo la data
      final body = decoded is Map && decoded.containsKey('result')
          ? decoded['result']
          : decoded is Map && decoded.containsKey('data')
              ? decoded['data']
              : decoded;

      return _parsePaginated(body);
    }

    if (res.statusCode == 401) {
      // Si tenés refresh flow, acá podrías dispararlo y reintentar.
      throw Exception('No autorizado (401). Verificá el token.');
    }

    throw Exception('Error ${res.statusCode}: ${res.body}');
  }

  // ==== Nuevos métodos para reportes regionales ====

  /// Helper para parsear respuestas de reportes
  static T _parseReportResponse<T>(http.Response response, T Function(Map<String, dynamic>) parser) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded.containsKey('data')) {
        return parser(decoded['data'] as Map<String, dynamic>);
      }
      return parser(decoded as Map<String, dynamic>);
    }

    if (response.statusCode == 401) {
      throw Exception('No autorizado (401). Verificá el token.');
    }

    if (response.statusCode == 403) {
      throw Exception('Sin permisos para acceder a este recurso.');
    }

    throw Exception('Error ${response.statusCode}: ${response.body}');
  }

  /// Obtiene el resumen de una región específica
  static Future<RegionalSummary> getRegionalSummary(
    String regionId, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
    List<String>? userIds,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final uri = _buildUri('/reports/regional-summary/$regionId', {
      'startDate': startDate,
      'endDate': endDate,
      'countries': countries,
      'languages': languages,
      'userIds': userIds,
    });

    final response = await http.get(uri, headers: _authHeaders(token));
    
    return _parseReportResponse(response, (data) => RegionalSummary.fromJson(data));
  }

  /// Compara múltiples regiones
  static Future<RegionalComparison> getRegionalComparison(
    List<String> regionIds, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
  }) async {
    if (regionIds.isEmpty || regionIds.length > 10) {
      throw Exception('Se requieren entre 1 y 10 regiones para la comparación');
    }

    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final uri = _buildUri('/reports/regional-comparison', {
      'regionIds': regionIds,
      'startDate': startDate,
      'endDate': endDate,
      'countries': countries,
      'languages': languages,
    });

    final response = await http.get(uri, headers: _authHeaders(token));
    
    return _parseReportResponse(response, (data) => RegionalComparison.fromJson(data));
  }

  /// Obtiene el desglose por países
  static Future<CountryBreakdown> getCountryBreakdown({
    String? regionId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    int skip = 0,
    int take = 20,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final path = regionId != null 
        ? '/reports/country-breakdown/$regionId' 
        : '/reports/country-breakdown';
    
    final uri = _buildUri(path, {
      'startDate': startDate,
      'endDate': endDate,
      'countries': countries,
      'skip': skip,
      'take': take,
    });

    final response = await http.get(uri, headers: _authHeaders(token));
    
    return _parseReportResponse(response, (data) => CountryBreakdown.fromJson(data));
  }

  /// Obtiene la distribución de idiomas
  static Future<LanguageDistribution> getLanguageDistribution({
    String? regionId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? countries,
    List<String>? languages,
    int skip = 0,
    int take = 20,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final path = regionId != null 
        ? '/reports/language-distribution/$regionId' 
        : '/reports/language-distribution';
    
    final uri = _buildUri(path, {
      'startDate': startDate,
      'endDate': endDate,
      'countries': countries,
      'languages': languages,
      'skip': skip,
      'take': take,
    });

    final response = await http.get(uri, headers: _authHeaders(token));
    
    return _parseReportResponse(response, (data) => LanguageDistribution.fromJson(data));
  }

  /// Obtiene el resumen del dashboard
  static Future<DashboardSummary> getDashboardSummary({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? regionIds,
    List<String>? countries,
    List<String>? languages,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final uri = _buildUri('/reports/dashboard-summary', {
      'startDate': startDate,
      'endDate': endDate,
      'regionIds': regionIds,
      'countries': countries,
      'languages': languages,
    });

    final response = await http.get(uri, headers: _authHeaders(token));
    
    return _parseReportResponse(response, (data) => DashboardSummary.fromJson(data));
  }

  /// Obtiene las regiones disponibles para el usuario actual
  static Future<List<RegionInfo>> getAvailableRegions() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de sesión');
    }

    final uri = _buildUri('/regions', {'mine': 'true'});
    final response = await http.get(uri, headers: _authHeaders(token));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final items = decoded is Map && decoded.containsKey('items') 
          ? decoded['items'] as List
          : decoded as List;
      
      return items
          .cast<Map<String, dynamic>>()
          .map((json) => RegionInfo.fromJson(json))
          .toList();
    }

    throw Exception('Error al obtener regiones: ${response.statusCode}');
  }

  /// Obtiene los países únicos de los datos
  static Future<List<String>> getAvailableCountries({String? regionId}) async {
    try {
      final breakdown = await getCountryBreakdown(
        regionId: regionId,
        take: 100, // Obtener muchos para tener lista completa
      );
      return breakdown.countries.map((c) => c.country).toList();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene los idiomas únicos de los datos
  static Future<List<String>> getAvailableLanguages({String? regionId}) async {
    try {
      final distribution = await getLanguageDistribution(
        regionId: regionId,
        take: 100, // Obtener muchos para tener lista completa
      );
      return distribution.languages.map((l) => l.language).toList();
    } catch (e) {
      return [];
    }
  }
}

// Contenedor paginado para la UI
class PaginatedTrackers {
  final List<Tracking> items;
  final int total;
  final int page;
  final int pageSize;

  PaginatedTrackers({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}
