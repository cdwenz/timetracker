import 'package:flutter/material.dart';

class TrackingData extends ChangeNotifier {
  String? personName;
  String? country;
  String? language;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTimeOfDay;
  TimeOfDay? endTimeOfDay;
  List<String> tasks = [];
  String taskDescription = '';

  // Nuevos campos para step_01 y step_02
  String? note;
  String? recipient;
  String? supportedCountry;
  String? workingLanguage;

  void setNote(String newNote) {
    note = newNote;
    notifyListeners();
  }

  void setRecipient(String newRecipient) {
    recipient = newRecipient;
    notifyListeners();
  }

  void setSupportedCountry(String value) {
    supportedCountry = value;
    notifyListeners();
  }

  void setWorkingLanguage(String value) {
    workingLanguage = value;
    notifyListeners();
  }

  void setPersonName(String name) {
    personName = name;
    notifyListeners();
  }

  void setStartEndDates(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  void setStartEndTimesOfDay(TimeOfDay start, TimeOfDay end) {
    startTimeOfDay = start;
    endTimeOfDay = end;
    notifyListeners();
  }

  void setTasksAndDescription(List<String> selectedTasks, String description) {
    tasks = selectedTasks;
    taskDescription = description;
    notifyListeners();
  }

  void clear() {
    personName = null;
    country = null;
    language = null;
    startDate = null;
    endDate = null;
    startTimeOfDay = null;
    endTimeOfDay = null;
    tasks = [];
    taskDescription = '';
    note = null;
    recipient = null;
    supportedCountry = null;
    workingLanguage = null;

    notifyListeners();
  }

  Map<String, String?> toMap() {
    return {
      'note': note,
      'recipient': recipient,
      'personName': personName,
      'supportedCountry': supportedCountry,
      'workingLanguage': workingLanguage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTimeOfDay': startTimeOfDay?.format24(),
      'endTimeOfDay': endTimeOfDay?.format24(),
      'tasks': tasks.isNotEmpty ? tasks.join(', ') : null,
      'taskDescription': taskDescription.isNotEmpty ? taskDescription : null,
    };
  }
}

// Util para formatear TimeOfDay en formato HH:mm
extension TimeOfDayExtension on TimeOfDay {
  String format24() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
