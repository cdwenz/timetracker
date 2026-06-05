// Re-export condicional: en web usa el stub no-op (sqflite no existe en navegador).
export 'local_database_io.dart' if (dart.library.html) 'local_database_web.dart';
