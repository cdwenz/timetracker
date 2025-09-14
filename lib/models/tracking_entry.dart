
class TrackingEntry {
  final int? id;
  final String? serverId; // ID del servidor cuando se sincroniza
  final String person;
  final String country;
  final String workingLanguage;
  final String recipient;
  final String note;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final List<String> tasks;
  final String description;
  final bool synced; // para saber si ya fue subido a la nube
  final DateTime lastModified;
  final String syncStatus; // 'pending', 'synced', 'failed'

  TrackingEntry({
    this.id,
    this.serverId,
    required this.person,
    required this.country,
    required this.workingLanguage,
    required this.recipient,
    required this.note,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.tasks,
    required this.description,
    this.synced = false,
    DateTime? lastModified,
    this.syncStatus = 'pending',
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverId': serverId,
      'person': person,
      'country': country,
      'workingLanguage': workingLanguage,
      'recipient': recipient,
      'note': note,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'tasks': tasks.join(','),
      'description': description,
      'synced': synced ? 1 : 0,
      'lastModified': lastModified.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  factory TrackingEntry.fromMap(Map<String, dynamic> map) {
    return TrackingEntry(
      id: map['id'],
      serverId: map['serverId'],
      person: map['person'],
      country: map['country'],
      workingLanguage: map['workingLanguage'],
      recipient: map['recipient'],
      note: map['note'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      tasks: (map['tasks'] as String).split(',').where((t) => t.isNotEmpty).toList(),
      description: map['description'],
      synced: map['synced'] == 1,
      lastModified: DateTime.parse(map['lastModified']),
      syncStatus: map['syncStatus'] ?? 'pending',
    );
  }

  // Método para crear una copia con cambios
  TrackingEntry copyWith({
    int? id,
    String? serverId,
    String? person,
    String? country,
    String? workingLanguage,
    String? recipient,
    String? note,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    List<String>? tasks,
    String? description,
    bool? synced,
    DateTime? lastModified,
    String? syncStatus,
  }) {
    return TrackingEntry(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      person: person ?? this.person,
      country: country ?? this.country,
      workingLanguage: workingLanguage ?? this.workingLanguage,
      recipient: recipient ?? this.recipient,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tasks: tasks ?? this.tasks,
      description: description ?? this.description,
      synced: synced ?? this.synced,
      lastModified: lastModified ?? this.lastModified,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
