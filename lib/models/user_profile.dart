// lib/models/user_profile.dart
class UserProfile {
  final int id;  // ID numérico del usuario
  String name;
  final String email; // normalmente no editable
  String? workingLanguage;   // ej: "es", "en"
  String? supportedCountry;  // ej: "AR", "CL"

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.workingLanguage,
    this.supportedCountry,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        workingLanguage: json['workingLanguage'],
        supportedCountry: json['supportedCountry'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'workingLanguage': workingLanguage,
        'supportedCountry': supportedCountry,
      };
}
