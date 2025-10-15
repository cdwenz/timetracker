import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://timetracker-nest-mvp-production.up.railway.app/api";

  static Future<http.Response> login(String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  static Future<dynamic> getRequest(String endpoint,
      {Map<String, dynamic>? query}) async {
    // Construcción de la URL con parámetros
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters:
          query?.map((key, value) => MapEntry(key, value.toString())),
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    print("uri: $uri"); // Para depuración

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // si guardás el token JWT en algún lado, ponelo acá:
        'Authorization': 'Bearer $token',
      },
    );

    print("Response body: ${response.body}"); // Para depuración

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error ${response.statusCode}: ${response.reasonPhrase}\n${response.body}');
    }
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token'); // tu clave actual

    if (token == null || token.isEmpty) {
      throw Exception('Sesión no válida. Iniciá sesión nuevamente.');
    }

    final uri = Uri.parse('$baseUrl/auth/change-password');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // ok
      return;
    }

    // parsea el error del backend (Nest suele enviar { message })
    try {
      final data = jsonDecode(res.body);
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : 'No se pudo actualizar la contraseña';
      throw Exception(msg);
    } catch (_) {
      throw Exception('No se pudo actualizar la contraseña');
    }
  }
  // Otros métodos: register, fetchLogs, createLog, etc.
}
