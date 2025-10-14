import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'connectivity_service.dart';

class AuthService {
  // Configuración para diferentes plataformas
  static String get baseUrl {
    // Usando la IP local real para que funcione en emuladores y dispositivos físicos
    return 'http://192.168.0.109:8000/api';

    // Alternativas comentadas:
    // Para emulador Android (no funciona si backend está en localhost):
    // return 'http://10.0.2.2:8000/api';

    // Para desarrollo web:
    // return 'http://localhost:8000/api';
  }

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
        await prefs.setString('userId', user['id']);
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

  /// Guardar credenciales de forma segura para uso offline
  static Future<void> _saveCredentialsForOffline(
      String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // En producción, estas credenciales deberían estar encriptadas
    await prefs.setString('offline_email', email);
    await prefs.setString(
        'offline_password_hash', password.hashCode.toString());
    await prefs.setString(
        'offline_login_date', DateTime.now().toIso8601String());
  }

  /// Intentar login offline usando credenciales guardadas
  static Future<bool> _tryOfflineLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Verificar si tiene credenciales offline válidas
      final hasValidOfflineLogin =
          prefs.getBool('hasValidOfflineLogin') ?? false;
      if (!hasValidOfflineLogin) {
        print('❌ No hay credenciales offline válidas');
        return false;
      }

      final offlineEmail = prefs.getString('offline_email');
      final offlinePasswordHash = prefs.getString('offline_password_hash');
      final offlineLoginDate = prefs.getString('offline_login_date');

      // Verificar que las credenciales coincidan
      if (offlineEmail != email ||
          offlinePasswordHash != password.hashCode.toString()) {
        print('❌ Credenciales offline no coinciden');
        return false;
      }

      // Verificar que el login offline no sea muy antiguo (ej: 30 días)
      final loginDate = DateTime.parse(offlineLoginDate!);
      final daysSinceLastLogin = DateTime.now().difference(loginDate).inDays;

      if (daysSinceLastLogin > 30) {
        print('❌ Login offline expirado (${daysSinceLastLogin} días)');
        await _clearOfflineCredentials();
        return false;
      }

      // Login offline exitoso - mantener datos existentes
      await prefs.setBool('isLoggedIn', true);
      print('✅ Login offline exitoso');
      print('ℹ️ Usando datos guardados del último login online');

      return true;
    } catch (e) {
      print('❌ Error en login offline: $e');
      return false;
    }
  }

  static Future<String?> requestPasswordReset(String email) async {
    final uri = Uri.parse('$baseUrl/auth/forgot-password');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      try {
        final data = jsonDecode(res.body);
        // el backend devuelve { ok: true, reset_link: "..." }
        return (data is Map && data['reset_link'] is String)
            ? data['reset_link'] as String
            : null;
      } catch (_) {
        return null;
      }
    }

    try {
      final data = jsonDecode(res.body);
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : null;
      throw Exception(msg ?? 'No se pudo enviar el email de recuperación');
    } catch (_) {
      throw Exception('No se pudo enviar el email de recuperación');
    }
  }

  /// Limpiar credenciales offline
  static Future<void> _clearOfflineCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('offline_email');
    await prefs.remove('offline_password_hash');
    await prefs.remove('offline_login_date');
    await prefs.setBool('hasValidOfflineLogin', false);
  }

  /// Verificar si tiene login offline válido
  static Future<bool> hasValidOfflineLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasValidOfflineLogin') ?? false;
  }

  /// Logout que también limpia credenciales offline
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _clearOfflineCredentials();
    print('🚪 Logout completado');
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

      print('📝 Enviando registro para: $email');
      print('🔗 URL: $url');

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

      print('📋 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Registro exitoso');
        return true;
      } else {
        print('❌ Error en registro - Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('💥 Excepción en register: $e');
      return false;
    }
  }

  static Future<String?> currentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<String?> currentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<String?> currentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }
}
