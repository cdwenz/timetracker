// lib/services/reports_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihadi_time_tracker/models/tracking.dart';
import 'package:ihadi_time_tracker/utils/jwt_helper.dart';

class ReportsService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? prefs.getString('token');
  }

  static Future<String> _getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final fromPrefs = prefs.getString('user_role') ?? prefs.getString('role');
    if (fromPrefs != null) return fromPrefs;

    final token = await _getToken();
    if (token != null) {
      final r = JwtHelper.getRole(token);
      if (r != null) return r;
    }
    return 'USER';
  }

  /// Obtiene trackings según el rol:
  ///  - ADMIN: scope=all
  ///  - FIELD_MANAGER: scope=team
  ///  - USER: scope=self
  static Future<List<Tracking>> fetchTrackings({
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    final role = await _getRole();
    final token = await _getToken();

    String scope;
    switch (role) {
      case 'ADMIN':
        scope = 'all';
        break;
      case 'FIELD_MANAGER':
        scope = 'team';
        break;
      case 'USER':
      default:
        scope = 'self';
        break;
    }

    final params = <String, String>{'scope': scope};
    if (from != null) params['from'] = from.toIso8601String();
    if (to != null) params['to'] = to.toIso8601String();
    if (search != null && search.trim().isNotEmpty) params['q'] = search.trim();

    final uri = Uri.parse('$baseUrl/time-tracker').replace(queryParameters: params);
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      List list;
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      } else if (data is Map && data['trackings'] is List) {
        list = data['trackings'];
      } else if (data is Map && data['items'] is List) {
        list = data['items'];
      } else {
        list = [];
      }
      return list.map<Tracking>((e) => Tracking.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    throw Exception('Error ${res.statusCode}: ${res.body}');
  }
}
