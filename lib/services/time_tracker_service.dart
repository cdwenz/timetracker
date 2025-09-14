import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TimeTrackerService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<bool> submitTimeTracker({
    required String supportedPerson,
    required String supportedCountry,
    required String workingLanguage,
    required String startDate,
    required String endDate,
    required String recipient,
    required String note,
    required String startTimeOfDay,
    required String endTimeOfDay,
    required List<String> tasks,
    required String taskDescription,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/time-tracker'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'personName': supportedPerson,
          'supportedCountry': supportedCountry,
          'workingLanguage': workingLanguage,
          'startDate': startDate,
          'endDate': endDate,
          'recipient': recipient,
          'note': note,
          'startTimeOfDay': startTimeOfDay,
          'endTimeOfDay': endTimeOfDay,
          'tasks': tasks,
          'taskDescription': taskDescription,
        }),
      );

      print('API response: ${response.statusCode} ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      print('Error al enviar time-tracker: $e');
      return false;
    }
  }
}
