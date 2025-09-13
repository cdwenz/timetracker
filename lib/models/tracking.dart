// lib/models/tracking.dart
class Tracking {
  final String id;
  final String? userId;
  final String? userName;
  final String? note;
  final String? recipient;
  final String? personName;
  final String? supportedCountry;
  final String? workingLanguage;
  final String? startDate;      // ISO string
  final String? endDate;        // ISO string
  final String? startTimeOfDay; // "HH:mm"
  final String? endTimeOfDay;   // "HH:mm"
  final List<String> tasks;
  final String? taskDescription;

  Tracking({
    required this.id,
    this.userId,
    this.userName,
    this.note,
    this.recipient,
    this.personName,
    this.supportedCountry,
    this.workingLanguage,
    this.startDate,
    this.endDate,
    this.startTimeOfDay,
    this.endTimeOfDay,
    this.tasks = const [],
    this.taskDescription,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    List<String> _parseTasks(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) {
        return raw.map((e) => e.toString()).toList();
      }
      if (raw is String) {
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    return Tracking(
      id: (json['id'] ?? '').toString(),
      userId: json['userId']?.toString(),
      userName: json['userName']?.toString(),
      note: json['note']?.toString(),
      recipient: json['recipient']?.toString(),
      personName: json['personName']?.toString(),
      supportedCountry: json['supportedCountry']?.toString(),
      workingLanguage: json['workingLanguage']?.toString(),
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      startTimeOfDay: json['startTimeOfDay']?.toString(),
      endTimeOfDay: json['endTimeOfDay']?.toString(),
      tasks: _parseTasks(json['tasks']),
      taskDescription: json['taskDescription']?.toString(),
    );
  }
}
