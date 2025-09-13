// lib/utils/jwt_helper.dart
import 'dart:convert';

class JwtHelper {
  static String? _decodeBase64(String str) {
    try {
      String output = str.replaceAll('-', '+').replaceAll('_', '/');
      switch (output.length % 4) {
        case 0:
          break;
        case 2:
          output += '==';
          break;
        case 3:
          output += '=';
          break;
        default:
          return null;
      }
      return utf8.decode(base64.decode(output));
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = _decodeBase64(parts[1]);
    if (payload == null) return null;
    try {
      final map = jsonDecode(payload);
      if (map is Map<String, dynamic>) return map;
      return null;
    } catch (_) {
      return null;
    }
  }

  static String? getRole(String token) {
    final payload = decodePayload(token);
    if (payload == null) return null;
    if (payload['role'] is String) return payload['role'];
    if (payload['roles'] is List && (payload['roles'] as List).isNotEmpty) {
      return (payload['roles'] as List).first.toString();
    }
    return null;
  }
}
