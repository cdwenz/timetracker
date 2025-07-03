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

  void setPersonName(String name) {
    personName = name;
    notifyListeners();
  }

  void setCountry(String c) {
    country = c;
    notifyListeners();
  }

  void setLanguage(String l) {
    language = l;
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

  Map<String, String?> toMap() {
    return {
      'personName': personName,
      'country': country,
      'language': language,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTimeOfDay': startTimeOfDay?.toString(),
      'endTimeOfDay': endTimeOfDay?.toString(),
      'tasks': tasks.isNotEmpty ? tasks.join(', ') : null,
      'taskDescription': taskDescription.isNotEmpty ? taskDescription : null,
    };
  }
}
