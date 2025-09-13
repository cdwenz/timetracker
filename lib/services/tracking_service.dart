import 'package:flutter/foundation.dart';

class TrackingService with ChangeNotifier {
  // Notas por paso (lo que ya tenías)
  List<String> stepNotes = List.filled(10, '');

  // Campos nuevos que pide el backend (los guardamos acá)
  String? recipient;
  String? supportedCountry;
  String? workingLanguage;

  // ===== Notas =====
  void saveStepNote(int stepIndex, String note) {
    if (stepIndex >= 0 && stepIndex < stepNotes.length) {
      stepNotes[stepIndex] = note;
      notifyListeners();
    }
  }

  List<String> getAllNotes() => stepNotes;

  // ===== Setters de campos =====
  void setRecipient(String value) {
    recipient = value;
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

  // Para enviar en Step 7 (útil)
  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'supportedCountry': supportedCountry,
      'workingLanguage': workingLanguage,
      'notes': stepNotes,
    };
  }

  void resetTracking() {
    stepNotes = List.filled(10, '');
    recipient = null;
    supportedCountry = null;
    workingLanguage = null;
    notifyListeners();
  }
}
