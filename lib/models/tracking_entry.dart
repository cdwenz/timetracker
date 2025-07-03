
class TrackingEntry {
  final int? id;
  final String person;
  final String country;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final List<String> tasks;
  final String description;
  final bool synced; // para saber si ya fue subido a la nube

  TrackingEntry({
    this.id,
    required this.person,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.tasks,
    required this.description,
    this.synced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person': person,
      'country': country,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'tasks': tasks.join(','),
      'description': description,
      'synced': synced ? 1 : 0,
    };
  }

  factory TrackingEntry.fromMap(Map<String, dynamic> map) {
    return TrackingEntry(
      id: map['id'],
      person: map['person'],
      country: map['country'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      tasks: (map['tasks'] as String).split(','),
      description: map['description'],
      synced: map['synced'] == 1,
    );
  }
}
