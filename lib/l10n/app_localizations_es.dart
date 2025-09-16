// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TimeTracker';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get showPasswordTooltip => 'Mostrar';

  @override
  String get hidePasswordTooltip => 'Ocultar';

  @override
  String get loginButton => 'Entrar';

  @override
  String get registerLink => '¿No tienes cuenta? Regístrate';

  @override
  String get offlineModeMessage =>
      'Modo offline - Usando credenciales guardadas';

  @override
  String get internetRequiredMessage =>
      'Sin conexión - Se requiere internet para el primer login';

  @override
  String get offlineFirstLoginMessage =>
      'Sin conexión. Necesitas hacer login online primero para usar la app offline.';

  @override
  String get incorrectCredentials => 'Credenciales incorrectas';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get registerButton => 'Registrarme';

  @override
  String get registrationSuccess =>
      'Registro exitoso. Por favor, inicia sesión.';

  @override
  String get allFieldsRequired => 'Todos los campos son obligatorios';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registrationError => 'Hubo un problema al registrarse';

  @override
  String homeGreeting(String name) {
    return '¡Hola, $name!';
  }

  @override
  String get startTrackingButton => 'Comenzar Registro';

  @override
  String get menuTitle => 'Menú';

  @override
  String get homeMenuItem => 'Inicio';

  @override
  String get accountMenuItem => 'Cuenta';

  @override
  String get reportsMenuItem => 'Reportes';

  @override
  String get logoutMenuItem => 'Cerrar Sesión';

  @override
  String get offlineModeTitle => '📱 Modo Sin Conexión';

  @override
  String get offlineModeDescription =>
      'Sin conexión a internet. Los registros se guardarán localmente.';

  @override
  String get loginRequiredTitle => '🔐 Necesitas hacer login online';

  @override
  String loginRequiredMessage(int count) {
    return 'Tienes $count registros pendientes. Para sincronizar necesitas cerrar sesión y hacer login con internet.';
  }

  @override
  String get logoutAndLoginButton => 'Cerrar sesión y hacer login';

  @override
  String get syncErrorTitle => '⚠️ Registros con error de sincronización';

  @override
  String get pendingSyncTitle => '📤 Registros pendientes de sincronizar';

  @override
  String syncErrorMessage(int failedCount, int pendingCount) {
    return 'Tienes $failedCount registros con errores y $pendingCount pendientes';
  }

  @override
  String pendingSyncMessage(int pendingCount) {
    return 'Tienes $pendingCount registros esperando sincronización';
  }

  @override
  String get synchronizing => 'Sincronizando...';

  @override
  String get syncNowButton => 'Sincronizar Ahora';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get logoutDialogTitle => 'Cerrar Sesión';

  @override
  String get logoutDialogMessage =>
      'Para sincronizar tus registros pendientes necesitas cerrar sesión y hacer login nuevamente con conexión a internet.\\n\\n¿Deseas cerrar sesión ahora?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String logoutErrorMessage(String error) {
    return 'Error al cerrar sesión: $error';
  }

  @override
  String get step1Title => 'Paso 1 de 7';

  @override
  String get step1Question => '¿Qué hiciste hoy?';

  @override
  String get step1Description =>
      'Escribe una breve descripción de la actividad que realizaste.';

  @override
  String get step1Placeholder => 'Ej: Ayudé a un traductor piaroa a...';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get step1Validation => 'Por favor completa la nota.';

  @override
  String get step2Title => 'Paso 2 de 7';

  @override
  String get step2Question => '¿A quién ayudaste hoy?';

  @override
  String get recipientLabel => 'Destinatario';

  @override
  String get supportedCountryLabel => 'País Soportado';

  @override
  String get countryPlaceholder => 'Ej: AR, Estados Unidos, etc.';

  @override
  String get workingLanguageLabel => 'Idioma de Trabajo';

  @override
  String get languagePlaceholder => 'Ej: es, en, portugués...';

  @override
  String get recipientValidation => 'Completa el destinatario.';

  @override
  String get countryValidation => 'El país soportado es requerido';

  @override
  String get languageValidation => 'El idioma de trabajo es requerido';

  @override
  String get savingButton => 'Guardando...';

  @override
  String get continueButton => 'Continuar';

  @override
  String get step3Title => 'Paso 3 de 7';

  @override
  String get step3Question => '¿Cuál es tu nombre?';

  @override
  String get step3Description =>
      'Este nombre se usará para registrar tu participación.';

  @override
  String get step3Placeholder => 'Ej: Juan Pérez';

  @override
  String get step3Validation => 'Completa tu nombre.';

  @override
  String get step4Title => 'Paso 4 de 7';

  @override
  String get step4Question => '¿Cuándo ocurrió?';

  @override
  String get step4Description =>
      'Selecciona la fecha de inicio y fin de la actividad.';

  @override
  String get startDateLabel => 'Inicio';

  @override
  String get endDateLabel => 'Fin';

  @override
  String get selectDateButton => 'Seleccionar';

  @override
  String get step4Validation => 'Por favor, completa ambas fechas.';

  @override
  String get step5Title => 'Paso 5 de 7';

  @override
  String get step5Question => '¿En qué horario fue?';

  @override
  String get step5Description =>
      'Selecciona la hora de inicio y fin de la actividad.';

  @override
  String get startTimeLabel => 'Hora de inicio';

  @override
  String get endTimeLabel => 'Hora de fin';

  @override
  String get step5Validation => 'Por favor, completa ambos horarios.';

  @override
  String get step6Title => 'Paso 6 de 7';

  @override
  String get step6Question => '¿Qué tareas realizaste?';

  @override
  String get step6Description =>
      'Selecciona una o más tareas realizadas y escribe detalles si deseas.';

  @override
  String get additionalDetailsPlaceholder => 'Detalles adicionales...';

  @override
  String get step6Validation => 'Selecciona al menos una tarea.';

  @override
  String get step7Title => 'Paso 7 de 7';

  @override
  String get step7Question => 'Resumen de tu actividad';

  @override
  String get noteLabel => 'Nota';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get timeLabel => 'Horario';

  @override
  String get tasksLabel => 'Tareas';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get finishButton => 'Finalizar';

  @override
  String get successMessage => 'Registro enviado correctamente.';

  @override
  String get errorMessage => 'Error al enviar el registro.';

  @override
  String get taskMAST => 'MAST';

  @override
  String get taskBTTSupport => 'Soporte BTT (Writer, Orature, USFM, Recorder)';

  @override
  String get taskTraining => 'Entrenamiento';

  @override
  String get taskTechnicalSupport => 'Soporte Técnico';

  @override
  String get taskVMAST => 'V-Mast';

  @override
  String get taskTranscribe => 'Transcribir';

  @override
  String get taskQualityAssurance => 'Procesos de Aseguramiento de Calidad';

  @override
  String get taskIhadiDevelopment => 'Desarrollo de software Ihadi';

  @override
  String get taskAI => 'IA';

  @override
  String get taskSpecialAssignment => 'Asignación Especial';

  @override
  String get taskRevision => 'Revisión';

  @override
  String get taskOther => 'Otro';

  @override
  String get reportsTitle => 'Reportes';

  @override
  String get selectRangeTooltip => 'Seleccionar rango';

  @override
  String get reloadTooltip => 'Recargar';

  @override
  String roleLabel(String role) {
    return 'Rol: $role';
  }

  @override
  String scopeLabel(String scope) {
    return 'Ámbito: $scope';
  }

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleFieldManager => 'Gerente de Campo';

  @override
  String get roleUser => 'Usuario';

  @override
  String get scopeAll => 'Todos';

  @override
  String get scopeMyTeam => 'Mi Equipo';

  @override
  String get scopeMyRecords => 'Mis Registros';

  @override
  String get searchPlaceholder => 'Buscar por nombre, nota, etc.';

  @override
  String get noTrackingsMessage => 'No hay registros para mostrar';

  @override
  String loadReportsError(String error) {
    return 'No se pudieron cargar los reportes: $error';
  }

  @override
  String get accountTitle => 'Mi Cuenta';

  @override
  String get defaultUserName => 'Usuario';

  @override
  String get guestRole => 'Invitado';

  @override
  String get verifyingAuthStatus => 'Verificando estado de autenticación...';

  @override
  String userCountryLabel(String country) {
    return 'País: $country';
  }

  @override
  String userRoleLabel(String role) {
    return 'Rol: $role';
  }

  @override
  String get countryFieldLabel => 'País';

  @override
  String get nameRequiredValidation => 'El nombre es requerido';

  @override
  String get saveChangesButton => 'Guardar Cambios';

  @override
  String get profileUpdatedMessage => 'Perfil actualizado';

  @override
  String saveErrorMessage(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String genericErrorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get loadingMessage => 'Cargando...';

  @override
  String get noDataMessage => 'Sin datos';

  @override
  String get closeTooltip => 'Cerrar';

  @override
  String get reportDetailTitle => 'Detalle del Reporte';

  @override
  String get mainDataSection => 'Datos Principales';

  @override
  String get personLabel => 'Persona';

  @override
  String get supportCountryLabel => 'País Soporte';

  @override
  String get workingLanguageModalLabel => 'Idioma de Trabajo';

  @override
  String get datesAndTimesSection => 'Fechas y Horarios';

  @override
  String get startLabel => 'Inicio';

  @override
  String get endLabel => 'Fin';

  @override
  String get startTimeModalLabel => 'Hora Inicio';

  @override
  String get endTimeModalLabel => 'Hora Fin';

  @override
  String get tasksSection => 'Tareas';

  @override
  String get listLabel => 'Lista';

  @override
  String get descriptionModalLabel => 'Descripción';

  @override
  String get noteSection => 'Nota';

  @override
  String noteDetailLabel(Object note) {
    return 'Nota: $note';
  }

  @override
  String countryDetailLabel(Object country) {
    return 'País: $country';
  }

  @override
  String languageDetailLabel(Object language) {
    return 'Idioma: $language';
  }

  @override
  String timeDetailLabel(Object time) {
    return 'Horario: $time';
  }

  @override
  String tasksDetailLabel(Object tasks) {
    return 'Tareas: $tasks';
  }

  @override
  String get noteDetailPrefix => 'Nota';

  @override
  String get countryDetailPrefix => 'País';

  @override
  String get languageDetailPrefix => 'Idioma';

  @override
  String get timeDetailPrefix => 'Horario';

  @override
  String get tasksDetailPrefix => 'Tareas';

  @override
  String get trackingFallback => 'Registro';

  @override
  String get languageSelectionTitle => 'Idioma';

  @override
  String connectedStatus(String connectionType) {
    return 'Conectado ($connectionType)';
  }

  @override
  String get disconnectedStatus => 'Sin conexión';

  @override
  String get readyToSync => 'Listo para sincronizar';

  @override
  String get syncing => 'Sincronizando...';

  @override
  String get lastSyncSuccess => 'Última sincronización exitosa';

  @override
  String get syncError => 'Error en sincronización';

  @override
  String get syncPaused => 'Sincronización pausada';

  @override
  String get syncStatusTitle => 'Estado de Sincronización';

  @override
  String get connectivityTitle => 'Conectividad';

  @override
  String get statusLabel => 'Estado';

  @override
  String get connectedLabel => 'Conectado';

  @override
  String get disconnectedLabel => 'Desconectado';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get syncTitle => 'Sincronización';

  @override
  String get pendingEntriesLabel => 'Entradas pendientes';

  @override
  String get failedEntriesLabel => 'Entradas fallidas';

  @override
  String get syncButton => 'Sincronizar';

  @override
  String get closeButton => 'Cerrar';

  @override
  String pendingCountLabel(int count) {
    return '$count pendientes';
  }

  @override
  String failedCountLabel(int count) {
    return '$count fallidos';
  }

  @override
  String get fewSecondsAgo => 'Hace unos segundos';

  @override
  String minutesAgo(int minutes) {
    return 'Hace $minutes minutos';
  }

  @override
  String hoursAgo(int hours) {
    return 'Hace $hours horas';
  }

  @override
  String get noAccessToken => 'No hay token de acceso';

  @override
  String httpError(int statusCode, String message) {
    return 'Error $statusCode: $message';
  }

  @override
  String get emptyFieldValue => '-';

  @override
  String get app_name => 'TimeTracker';

  @override
  String get login_title => 'Iniciar sesión';

  @override
  String get login_button => 'Iniciar sesión';

  @override
  String get logout_button => 'Cerrar sesión';

  @override
  String report_items_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '1 entrada',
      zero: 'Sin entradas',
    );
    return '$_temp0';
  }

  @override
  String get date_format_hint => 'MMM d, y • HH:mm';
}
