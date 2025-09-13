import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000/api';

static Future<bool> login(String email, String password) async {
  try {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];
      final token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('name', user['name']);
      await prefs.setString('email', user['email']);
      await prefs.setString('role', user['role'] ?? '');
      await prefs.setString('access_token', token);

      return true;
    } else {
      print('Error login: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Excepción en login: $e');
    return false;
  }
}


  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String country,
    String role = 'FIELD_MANAGER',
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'country': country,
          'role': role,
        }),
      );

      print(response.body); // Para depuración

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Excepción en register: $e');
      return false;
    }
  }
}
