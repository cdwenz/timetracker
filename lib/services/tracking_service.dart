
class TrackingService {
  // Almacenamiento de notas de cada paso
  List<String> stepNotes = List.filled(10, '');

  // Método para guardar nota de un paso específico
  void saveStepNote(int stepIndex, String note) {
    if (stepIndex >= 0 && stepIndex < 10) {
      stepNotes[stepIndex] = note;
    }
  }

  // Método para obtener todas las notas
  List<String> getAllNotes() {
    return stepNotes;
  }

  // Método para resetear tracking
  void resetTracking() {
    stepNotes = List.filled(10, '');
  }
}