import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

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

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // si guardás el token JWT en algún lado, ponelo acá:
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error ${response.statusCode}: ${response.reasonPhrase}\n${response.body}');
    }
  }

  // Otros métodos: register, fetchLogs, createLog, etc.
}
