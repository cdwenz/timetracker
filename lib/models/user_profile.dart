// lib/models/user_profile.dart
class UserProfile {
  final String id;
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
        id: json['id'].toString(),
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
