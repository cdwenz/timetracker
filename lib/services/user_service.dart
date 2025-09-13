// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'auth_service.dart'; // Debe exponer: static const baseUrl = 'https://tu.api';

// Representa la respuesta de GET /auth/me
class UserMe {
  final String id;
  final String name;
  final String email;
  final String role;
  final String country;
  final String createdAt;

  UserMe({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.country,
    required this.createdAt,
  });

  factory UserMe.fromMeResponse(Map<String, dynamic> json) {
    return UserMe(
      id: json['id'] as String,
      name: (json['name'] ?? '') as String,
      email: json['email'] as String,
      role: json['role'] as String,
      country: json['country'] as String? ?? '',
      createdAt: json['createdAt'] as String,
    );
  }
}

class UserService {
  static String get _base =>
      AuthService.baseUrl; // ej: https://api.sushionline.ar

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // usa la key que ya guardás en el login
    return prefs.getString('access_token') ?? prefs.getString('token');
  }

  /// GET /auth/me (token en Authorization: Bearer xxx)
  static Future<UserMe> getMe() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de acceso');
    }

    final uri = Uri.parse('$_base/auth/me');
    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("token: ${res.body}"); // Depuración

    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    return UserMe.fromMeResponse(data);
  }

  /// Si ya tenías endpoints de perfil, dejalos.
  /// Ejemplo de actualización de perfil (ajustá URL según tu backend):
  static Future<UserProfile> updateProfile(UserProfile profile) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No hay token de acceso');
    }

    // Cambiá esta ruta si tu backend expone otra (p.ej. /users/profile, /profile, etc.)
    final uri = Uri.parse('$_base/users/profile');
    final res = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }
}
