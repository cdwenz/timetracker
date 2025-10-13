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
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordInstruction =>
      'Ingresá tu correo y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get emailRequired => 'Ingresá tu correo';

  @override
  String get invalidEmail => 'Correo inválido';

  @override
  String get sendButton => 'Enviar';

  @override
  String get forgotPasswordSent => 'Revisá tu correo';

  @override
  String get forgotPasswordErrorGeneric =>
      'No se pudo enviar el email de recuperación';

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
  String get taskRefinement => 'Refinamiento';

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
  String get myTrackingsOnly => 'Solo mis trackings';

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
  String get security => 'Seguridad';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get changePasswordSubtitle => 'Actualizá tu contraseña';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get currentPasswordLabel => 'Contraseña actual';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get repeatNewPasswordLabel => 'Repetir nueva contraseña';

  @override
  String get changePasswordSubmit => 'Actualizar';

  @override
  String get changePasswordSuccess => 'Contraseña actualizada ✅';

  @override
  String get changePasswordErrorGeneric =>
      'No se pudo actualizar la contraseña';

  @override
  String get changePasswordValidationCurrentRequired =>
      'Ingresá tu contraseña actual';

  @override
  String changePasswordValidationMinLength(Object min) {
    return 'Mínimo $min caracteres';
  }

  @override
  String get changePasswordValidationRepeatMismatch => 'No coincide';

  @override
  String get loadingMessage => 'Cargando...';

  @override
  String get noDataMessage => 'Sin datos';

  @override
  String get closeTooltip => 'Cerrar';

  @override
  String get reportDetailTitle => 'Detalle del reporte';

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

  @override
  String get reportsScreenTitle => 'Reportes';

  @override
  String get teamCardTitle => 'Equipo';

  @override
  String get meCardTitle => 'Yo';

  @override
  String get teamCardSubtitle => 'Reportes último mes';

  @override
  String get meCardSubtitle => 'Reportes último mes';

  @override
  String get teamCardSubtitleAdmin => 'Reportes organización (vista ADMIN)';

  @override
  String get teamCardSubtitleNonAdmin => 'Igual que \'Yo\' (acceso limitado)';

  @override
  String meCardSubtitleRole(Object role) {
    return 'Mis reportes ($role)';
  }

  @override
  String get dailyComparisonTitle => 'COMPARACIÓN DIARIA:';

  @override
  String get myEvolutionTitle => 'Evolución (Yo)';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String get period => 'Período';

  @override
  String get noReportsInPeriod => 'Sin reportes en el período';

  @override
  String reportIdLabel(String id) {
    return 'Reporte $id…';
  }

  @override
  String reportDateUserLabel(String date, String userId) {
    return 'Fecha: $date • Usuario: $userId…';
  }

  @override
  String reportIdField(String id) {
    return '• ID: $id';
  }

  @override
  String reportUserField(String userId) {
    return '• Usuario: $userId';
  }

  @override
  String reportStartDateField(String startDate) {
    return '• Fecha inicio: $startDate';
  }

  @override
  String reportOrganizationField(String organizationId) {
    return '• Organización: $organizationId';
  }

  @override
  String reportProjectField(String projectId) {
    return '• Proyecto: $projectId';
  }

  @override
  String reportNotesField(String notes) {
    return '• Notas: $notes';
  }

  @override
  String get unknownValue => '—';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get trackingTileTitle => 'Seguimiento';

  @override
  String get trackingTileSubtitle => 'Iniciar y detener';

  @override
  String get reportsTileTitle => 'Reportes';

  @override
  String get reportsTileSubtitle => 'Tiempos y métricas';

  @override
  String get accountTileTitle => 'Cuenta';

  @override
  String get accountTileSubtitle => 'Perfil y sesión';

  @override
  String get enhancedReportsTitle => 'Reportes Avanzados';

  @override
  String get advancedReportsTooltip => 'Reportes Avanzados';

  @override
  String get basicReportsTitle => 'Reportes Básicos';

  @override
  String get regionalReportsTitle => 'Reportes Regionales';

  @override
  String get regionalSummaryTitle => 'RESUMEN REGIONAL:';

  @override
  String get regionalComparisonTitle => 'Comparación de Regiones';

  @override
  String get countryBreakdownTitle => 'Desglose por Países';

  @override
  String get languageDistributionTitle => 'Distribución de Idiomas';

  @override
  String get regionalDashboard => 'Panel regional';

  @override
  String get roleBasedAccess => 'Acceso basado en roles';

  @override
  String get accessLevel => 'Nivel de Acceso';

  @override
  String get availableReports => 'Reportes Disponibles';

  @override
  String get selectRegionForDetails =>
      'Selecciona una región para ver detalles';

  @override
  String get compareRegions => 'Comparar Regiones';

  @override
  String get viewCountryBreakdown => 'Ver Desglose por Países';

  @override
  String get analyzeLanguageDistribution => 'Analizar Distribución de Idiomas';

  @override
  String get activeFiltersTitle => 'Filtros Activos';

  @override
  String get clearFilters => 'Limpiar Filtros';

  @override
  String get filterByRegion => 'Filtrar por Región';

  @override
  String get filterByDates => 'Filtrar por fechas';

  @override
  String get allRegions => 'Todas las regiones';

  @override
  String get selectRegions => 'Seleccionar Regiones';

  @override
  String get selectAtLeast2Regions =>
      'Selecciona al menos 2 regiones para comparar';

  @override
  String selectedRegionsCount(int count) {
    return 'Regiones Seleccionadas ($count/10)';
  }

  @override
  String get totalHours => 'Total Horas';

  @override
  String get totalEntries => 'Total Entradas';

  @override
  String get activeUsers => 'Usuarios Activos';

  @override
  String get totalLanguages => 'Total Idiomas';

  @override
  String get totalCountries => 'Total Países';

  @override
  String get totalRegions => 'Regiones';

  @override
  String get averagePerRegion => 'Promedio/Región';

  @override
  String get averagePerCountry => 'Promedio/País';

  @override
  String get averagePerLanguage => 'Promedio/Idioma';

  @override
  String get topCountries => 'Principales Países';

  @override
  String get languageBreakdown => 'Distribución de Idiomas';

  @override
  String get performanceMetrics => 'Indicadores de Rendimiento';

  @override
  String get comparisonSummary => 'Resumen de Comparación';

  @override
  String get detailedMetrics => 'Métricas Detalladas';

  @override
  String get performanceHighlights => 'Destacados de Rendimiento';

  @override
  String get mainMetrics => 'Métricas Principales';

  @override
  String get mostUsed => 'Más Usado';

  @override
  String get leastUsed => 'Menos Usado';

  @override
  String get mostActive => 'Más Activo';

  @override
  String get leastActive => 'Menos Activo';

  @override
  String get bestPerformance => 'Mejor Rendimiento';

  @override
  String get worstPerformance => 'Menor Rendimiento';

  @override
  String get hoursPerUser => 'Horas/Usuario';

  @override
  String get entriesPerUser => 'Entradas/Usuario';

  @override
  String languagesUsed(Object languages) {
    return 'Idiomas utilizados: $languages';
  }

  @override
  String get countriesWithActivity => 'Países con Actividad';

  @override
  String get languagesWithActivity => 'Idiomas con Actividad';

  @override
  String get periodInformation => 'Información del Período';

  @override
  String fromDate(String date) {
    return 'Desde: $date';
  }

  @override
  String toDate(String date) {
    return 'Hasta: $date';
  }

  @override
  String regionScope(String region) {
    return 'Región: $region';
  }

  @override
  String get allRegionsScope => 'Alcance: Todas las regiones';

  @override
  String filteredCountry(String country) {
    return 'País filtrado: $country';
  }

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get noDataForRegion => 'No hay datos disponibles para esta región';

  @override
  String get loadingData => 'Cargando datos...';

  @override
  String get refreshData => 'Actualizar';

  @override
  String get exportReport => 'Exportar Reporte';

  @override
  String get generateReport => 'Generar Reporte';

  @override
  String get exportToPDF => 'Exportar a PDF';

  @override
  String get exportToExcel => 'Exportar a Excel';

  @override
  String get exportToCSV => 'Exportar a CSV';

  @override
  String get shareReport => 'Compartir Reporte';

  @override
  String get distributionChart => 'Gráfico de Distribución';

  @override
  String get comparisonChart => 'Gráfico de Comparación';

  @override
  String get detailsTable => 'Tabla de Detalles';

  @override
  String get statisticsInsights => 'Estadísticas e Insights';

  @override
  String get regionalDistribution => 'Distribución por regiones:';

  @override
  String get selectItemsToExport => 'Seleccionar elementos a exportar';

  @override
  String get exportOptions => 'Opciones de Exportación';

  @override
  String get includeCharts => 'Incluir gráficos';

  @override
  String get includeRawData => 'Incluir datos sin procesar';

  @override
  String get includeSummary => 'Incluir resumen';

  @override
  String get exportSuccess => 'Reporte exportado exitosamente';

  @override
  String exportError(String error) {
    return 'Error exportando reporte: $error';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get compare => 'Comparar';

  @override
  String get apply => 'Aplicar';

  @override
  String get reset => 'Restablecer';

  @override
  String get advancedReportsScreenTitle => 'Reportes Avanzados';

  @override
  String get userAccessLevelTitle => 'Tu nivel de acceso';

  @override
  String get personalDashboardTitle => 'Dashboard Personal (últimos 30 días)';

  @override
  String get myEntriesTitle => 'Mis Entradas';

  @override
  String get teamTitle => 'Equipo';

  @override
  String get totalHoursTitle => 'Total Horas';

  @override
  String get activeUsersTitle => 'Usuarios Activos';

  @override
  String get activeRegionsTitle => 'Regiones Activas';

  @override
  String get mostActiveRegionsTitle => 'Regiones Más Activas';

  @override
  String get advancedReportsTitle => 'Reportes Avanzados';

  @override
  String get compareRegionsTitle => 'Comparar Regiones';

  @override
  String get byCountriesTitle => 'Por Países';

  @override
  String get byLanguagesTitle => 'Por Idiomas';

  @override
  String get compareRegionsSubtitle => 'Analizar múltiples regiones';

  @override
  String get byCountriesSubtitle => 'Desglose por países';

  @override
  String get byLanguagesSubtitle => 'Distribución de idiomas';

  @override
  String get dailyComparisonSubtitle => 'Yo vs Equipo';

  @override
  String availableRegionsTitle(Object count) {
    return 'Regiones Disponibles ($count)';
  }

  @override
  String get regionalAccessEnabled => 'Acceso a reportes regionales habilitado';

  @override
  String get teamReportsIncludingYours =>
      'Reportes del equipo (incluyendo los tuyos)';

  @override
  String get noBasicDashboardData =>
      'No hay datos de dashboard básico disponibles';

  @override
  String get noRegionalData => 'No hay datos regionales disponibles';

  @override
  String get analysisMultipleRegions => 'Análisis de múltiples regiones';

  @override
  String get at2RegionsRequired =>
      'Se necesitan al menos 2 regiones para comparar';

  @override
  String get updateData => 'Actualizar datos';

  @override
  String get hours => 'Horas';

  @override
  String get dashboardComplete => 'Dashboard Completo';

  @override
  String get generalSummaryMetrics => 'Resumen general y métricas básicas';

  @override
  String get regionalDataComparisons => 'Datos regionales y comparaciones';

  @override
  String get noBasicDashboardDataAvailable =>
      'No hay datos de dashboard básico disponibles';

  @override
  String get noRegionalDataAvailable =>
      'No hay datos regionales disponibles - La lista de regiones está vacía';

  @override
  String get needAtLeast2RegionsCompare =>
      'Se necesitan al menos 2 regiones para comparar';

  @override
  String get updateDataTooltip => 'Actualizar datos';

  @override
  String get myReports => 'Mis Reportes';

  @override
  String get teamReports => 'Reportes del Equipo';

  @override
  String get userRole => 'Usuario';

  @override
  String get meLabel => 'Yo';

  @override
  String get teamLabel => 'Equipo';

  @override
  String errorLoadingReports(Object error) {
    return 'Error cargando reportes: $error';
  }

  @override
  String get dashboardReport => 'Reporte de Dashboard';

  @override
  String get basicDashboardReport => 'Reporte de Dashboard Básico';

  @override
  String get generated => 'Generado';

  @override
  String get user => 'Usuario';

  @override
  String get role => 'Rol';

  @override
  String get unknown => 'Desconocido';

  @override
  String get dashboardMetrics => 'Métricas del Dashboard';

  @override
  String get teamCount => 'Contador del Equipo';

  @override
  String get meCount => 'Mi Contador';

  @override
  String get dailyComparison => 'Comparación Diaria';

  @override
  String get day => 'Día';

  @override
  String get myCount => 'Mi Contador';

  @override
  String get myTrend => 'Mi Tendencia';

  @override
  String get count => 'Contador';

  @override
  String get regionalDashboardReport => 'Reporte de Dashboard Regional';

  @override
  String get summary => 'Resumen';

  @override
  String get regionalSummary => 'Resumen Regional';

  @override
  String get country => 'País';

  @override
  String get percentage => 'Porcentaje';

  @override
  String get topLanguages => 'Principales Idiomas';

  @override
  String get language => 'Idioma';

  @override
  String get dashboardMetricsTitle => 'MÉTRICAS DEL DASHBOARD:';

  @override
  String get myTrendTitle => 'MI TENDENCIA:';

  @override
  String get topCountriesTitle => 'PRINCIPALES PAÍSES:';

  @override
  String get topLanguagesTitle => 'PRINCIPALES IDIOMAS:';

  @override
  String get regionalComparison => 'Comparación de Regiones';

  @override
  String errorComparingRegions(Object error) {
    return 'Error comparando regiones: $error';
  }

  @override
  String get regionalComparisonReportSubject =>
      'Reporte de Comparación Regional';

  @override
  String selectedRegions(Object count) {
    return 'Regiones Seleccionadas ($count/10)';
  }

  @override
  String get selectAtLeast2RegionsToCompare =>
      'Selecciona al menos 2 regiones para comparar';

  @override
  String get regions => 'Regiones';

  @override
  String get totalHoursComparison => 'Comparación de Horas Totales';

  @override
  String get region => 'Región';

  @override
  String get entries => 'Entradas';

  @override
  String get users => 'Usuarios';

  @override
  String get hrsPerUser => 'Hrs/Usuario';

  @override
  String get topCountry => 'País Principal';

  @override
  String get topLanguage => 'Idioma Principal';

  @override
  String get selectRegionsDialog => 'Seleccionar Regiones';

  @override
  String selectBetween2And10Regions(Object count) {
    return 'Selecciona entre 2 y 10 regiones ($count seleccionadas)';
  }

  @override
  String get countryBreakdown => 'Desglose por Países';

  @override
  String errorLoadingData(Object error) {
    return 'Error cargando datos: $error';
  }

  @override
  String get countryBreakdownReportSubject => 'Reporte de Desglose por Países';

  @override
  String get activeFilters => 'Filtros Activos';

  @override
  String get selectedRegion => 'Región seleccionada';

  @override
  String countries(Object countries) {
    return 'Países: $countries';
  }

  @override
  String get generalSummary => 'Resumen General';

  @override
  String get countryDistribution => 'Distribución por Países (Top 10)';

  @override
  String countryDetails(Object count) {
    return 'Detalle por Países ($count)';
  }

  @override
  String get averageHrsPerUser => 'Promedio hrs/usuario';

  @override
  String get averageEntriesPerUser => 'Promedio entradas/usuario';

  @override
  String get averageHoursPerCountry => 'Promedio Horas/País';

  @override
  String get activeCountries => 'Países Activos';

  @override
  String from(Object date) {
    return 'Desde: $date';
  }

  @override
  String to(Object date) {
    return 'Hasta: $date';
  }

  @override
  String get languageDistribution => 'Distribución de Idiomas';

  @override
  String errorLoadingLanguageData(Object error) {
    return 'Error cargando datos: $error';
  }

  @override
  String get languageDistributionReportSubject =>
      'Reporte de Distribución de Idiomas';

  @override
  String languages(Object languages) {
    return 'Idiomas: $languages';
  }

  @override
  String get hoursPerLanguage => 'Horas por Idioma';

  @override
  String languageDetails(Object count) {
    return 'Detalle por Idiomas ($count)';
  }

  @override
  String countriesWhereUsed(Object countries) {
    return 'Países donde se usa: $countries';
  }

  @override
  String get regionalLanguageDistribution =>
      'Distribución Regional por Idiomas (Top 5)';

  @override
  String get averageHoursPerLanguage => 'Promedio Horas/Idioma';

  @override
  String get activeLanguages => 'Idiomas Activos';

  @override
  String countryFiltered(Object country) {
    return 'País filtrado: $country';
  }

  @override
  String get regionalSummaryReport => 'Reporte de Resumen Regional';

  @override
  String get regionalComparisonReport => 'Reporte de Comparación Regional';

  @override
  String get countryBreakdownReport => 'Reporte de Desglose por Países';

  @override
  String get languageDistributionReport => 'Reporte de Distribución de Idiomas';

  @override
  String get topCountriesLabel => 'Principales Países';

  @override
  String get languageBreakdownLabel => 'Desglose de Idiomas';

  @override
  String get countryDetailsLabel => 'Detalles por Países';

  @override
  String get languageDetailsLabel => 'Detalles por Idiomas';

  @override
  String get regionalDataLabel => 'Datos Regionales';

  @override
  String get rank => 'Rango';

  @override
  String get avgHoursPerUser => 'Prom Horas/Usuario';

  @override
  String get avgEntriesPerUser => 'Prom Entradas/Usuario';

  @override
  String get languageColumn => 'Idiomas';

  @override
  String get countryColumn => 'Países';

  @override
  String get averageHoursPerRegion => 'Promedio de Horas por Región';

  @override
  String get generalSummaryAndMetrics => 'Resumen general y métricas básicas';

  @override
  String get regionalDataAndComparisons => 'Datos regionales y comparaciones';

  @override
  String get noRegionalDataAvailableMessage =>
      'No hay datos regionales disponibles';

  @override
  String get atLeast2RegionsRequired =>
      'Se necesitan al menos 2 regiones para comparar';
}
