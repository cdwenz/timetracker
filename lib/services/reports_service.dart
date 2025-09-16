// lib/services/reports_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihadi_time_tracker/models/tracking.dart';

class ReportsService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

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
