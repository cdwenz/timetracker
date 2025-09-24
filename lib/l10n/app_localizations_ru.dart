// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'TimeTracker';

  @override
  String get loginTitle => 'Войти';

  @override
  String get emailLabel => 'Электронная Почта';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get showPasswordTooltip => 'Показать';

  @override
  String get hidePasswordTooltip => 'Скрыть';

  @override
  String get loginButton => 'Войти';

  @override
  String get registerLink => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get offlineModeMessage =>
      'Оффлайн режим - Используются сохранённые данные';

  @override
  String get internetRequiredMessage =>
      'Нет соединения - Интернет необходим для первого входа';

  @override
  String get offlineFirstLoginMessage =>
      'Нет соединения. Вам нужно войти онлайн сначала, чтобы использовать приложение оффлайн.';

  @override
  String get incorrectCredentials => 'Неверные учётные данные';

  @override
  String get createAccount => 'Создать Аккаунт';

  @override
  String get nameLabel => 'Имя';

  @override
  String get confirmPasswordLabel => 'Подтвердить Пароль';

  @override
  String get registerButton => 'Зарегистрироваться';

  @override
  String get registrationSuccess => 'Регистрация успешна. Пожалуйста, войдите.';

  @override
  String get allFieldsRequired => 'Все поля обязательны';

  @override
  String get passwordMismatch => 'Пароли не совпадают';

  @override
  String get registrationError => 'Возникла проблема при регистрации';

  @override
  String homeGreeting(String name) {
    return 'Привет, $name!';
  }

  @override
  String get startTrackingButton => 'Начать Запись';

  @override
  String get menuTitle => 'Меню';

  @override
  String get homeMenuItem => 'Главная';

  @override
  String get accountMenuItem => 'Аккаунт';

  @override
  String get reportsMenuItem => 'Отчёты';

  @override
  String get logoutMenuItem => 'Выйти';

  @override
  String get offlineModeTitle => '📱 Оффлайн Режим';

  @override
  String get offlineModeDescription =>
      'Нет подключения к интернету. Записи будут сохранены локально.';

  @override
  String get loginRequiredTitle => '🔐 Необходим вход онлайн';

  @override
  String loginRequiredMessage(int count) {
    return 'У вас $count ожидающих записей. Для синхронизации нужно выйти и войти с интернетом.';
  }

  @override
  String get logoutAndLoginButton => 'Выйти и войти';

  @override
  String get syncErrorTitle => '⚠️ Записи с ошибкой синхронизации';

  @override
  String get pendingSyncTitle => '📤 Записи ожидают синхронизации';

  @override
  String syncErrorMessage(int failedCount, int pendingCount) {
    return 'У вас $failedCount записей с ошибками и $pendingCount ожидающих';
  }

  @override
  String pendingSyncMessage(int pendingCount) {
    return 'У вас $pendingCount записей ожидают синхронизации';
  }

  @override
  String get synchronizing => 'Синхронизация...';

  @override
  String get syncNowButton => 'Синхронизировать Сейчас';

  @override
  String get retryButton => 'Повторить';

  @override
  String get logoutDialogTitle => 'Выйти';

  @override
  String get logoutDialogMessage =>
      'Чтобы синхронизировать ожидающие записи, вам нужно выйти и войти снова с подключением к интернету.\\n\\nВы хотите выйти сейчас?';

  @override
  String get cancelButton => 'Отменить';

  @override
  String logoutErrorMessage(String error) {
    return 'Ошибка при выходе: $error';
  }

  @override
  String get step1Title => 'Шаг 1 из 7';

  @override
  String get step1Question => 'Что вы делали сегодня?';

  @override
  String get step1Description =>
      'Напишите краткое описание выполненной деятельности.';

  @override
  String get step1Placeholder => 'Пример: Я помог переводчику пиароа...';

  @override
  String get nextButton => 'Далее';

  @override
  String get step1Validation => 'Пожалуйста, заполните заметку.';

  @override
  String get step2Title => 'Шаг 2 из 7';

  @override
  String get step2Question => 'Кому вы помогали сегодня?';

  @override
  String get recipientLabel => 'Получатель';

  @override
  String get supportedCountryLabel => 'Поддерживаемая Страна';

  @override
  String get countryPlaceholder => 'Пример: AR, США, и т.д.';

  @override
  String get workingLanguageLabel => 'Рабочий Язык';

  @override
  String get languagePlaceholder => 'Пример: es, en, португальский...';

  @override
  String get recipientValidation => 'Заполните получателя.';

  @override
  String get countryValidation => 'Поддерживаемая страна обязательна';

  @override
  String get languageValidation => 'Рабочий язык обязателен';

  @override
  String get savingButton => 'Сохранение...';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get step3Title => 'Шаг 3 из 7';

  @override
  String get step3Question => 'Как вас зовут?';

  @override
  String get step3Description =>
      'Это имя будет использовано для записи вашего участия.';

  @override
  String get step3Placeholder => 'Пример: Иван Петров';

  @override
  String get step3Validation => 'Заполните ваше имя.';

  @override
  String get step4Title => 'Шаг 4 из 7';

  @override
  String get step4Question => 'Когда это произошло?';

  @override
  String get step4Description =>
      'Выберите дату начала и окончания деятельности.';

  @override
  String get startDateLabel => 'Начало';

  @override
  String get endDateLabel => 'Конец';

  @override
  String get selectDateButton => 'Выбрать';

  @override
  String get step4Validation => 'Пожалуйста, заполните обе даты.';

  @override
  String get step5Title => 'Шаг 5 из 7';

  @override
  String get step5Question => 'В какое время это было?';

  @override
  String get step5Description =>
      'Выберите время начала и окончания деятельности.';

  @override
  String get startTimeLabel => 'Время начала';

  @override
  String get endTimeLabel => 'Время окончания';

  @override
  String get step5Validation => 'Пожалуйста, заполните оба времени.';

  @override
  String get step6Title => 'Шаг 6 из 7';

  @override
  String get step6Question => 'Какие задачи вы выполняли?';

  @override
  String get step6Description =>
      'Выберите одну или несколько выполненных задач и напишите детали, если хотите.';

  @override
  String get additionalDetailsPlaceholder => 'Дополнительные детали...';

  @override
  String get step6Validation => 'Выберите хотя бы одну задачу.';

  @override
  String get step7Title => 'Шаг 7 из 7';

  @override
  String get step7Question => 'Краткое изложение вашей деятельности';

  @override
  String get noteLabel => 'Заметка';

  @override
  String get dateLabel => 'Дата';

  @override
  String get timeLabel => 'Время';

  @override
  String get tasksLabel => 'Задачи';

  @override
  String get descriptionLabel => 'Описание';

  @override
  String get finishButton => 'Завершить';

  @override
  String get successMessage => 'Запись отправлена успешно.';

  @override
  String get errorMessage => 'Ошибка при отправке записи.';

  @override
  String get taskMAST => 'MAST';

  @override
  String get taskBTTSupport =>
      'Поддержка BTT (Writer, Orature, USFM, Recorder)';

  @override
  String get taskTraining => 'Обучение';

  @override
  String get taskTechnicalSupport => 'Техническая Поддержка';

  @override
  String get taskVMAST => 'V-Mast';

  @override
  String get taskTranscribe => 'Транскрибирование';

  @override
  String get taskQualityAssurance => 'Процессы Обеспечения Качества';

  @override
  String get taskIhadiDevelopment => 'Разработка ПО Ihadi';

  @override
  String get taskAI => 'ИИ';

  @override
  String get taskSpecialAssignment => 'Специальное Задание';

  @override
  String get taskRevision => 'Ревизия';

  @override
  String get taskOther => 'Другое';

  @override
  String get reportsTitle => 'Отчёты';

  @override
  String get selectRangeTooltip => 'Выбрать диапазон';

  @override
  String get reloadTooltip => 'Перезагрузить';

  @override
  String roleLabel(String role) {
    return 'Роль: $role';
  }

  @override
  String scopeLabel(String scope) {
    return 'Область: $scope';
  }

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get roleFieldManager => 'Полевой Менеджер';

  @override
  String get roleUser => 'Пользователь';

  @override
  String get scopeAll => 'Все';

  @override
  String get scopeMyTeam => 'Моя Команда';

  @override
  String get scopeMyRecords => 'Мои Записи';

  @override
  String get myTrackingsOnly => 'Только мои трекинги';

  @override
  String get searchPlaceholder => 'Поиск по имени, заметке и т.д.';

  @override
  String get noTrackingsMessage => 'Нет записей для отображения';

  @override
  String loadReportsError(String error) {
    return 'Не удалось загрузить отчёты: $error';
  }

  @override
  String get accountTitle => 'Мой Аккаунт';

  @override
  String get defaultUserName => 'Пользователь';

  @override
  String get guestRole => 'Гость';

  @override
  String get verifyingAuthStatus => 'Проверка статуса аутентификации...';

  @override
  String userCountryLabel(String country) {
    return 'Страна: $country';
  }

  @override
  String userRoleLabel(String role) {
    return 'Роль: $role';
  }

  @override
  String get countryFieldLabel => 'Страна';

  @override
  String get nameRequiredValidation => 'Имя обязательно';

  @override
  String get saveChangesButton => 'Сохранить Изменения';

  @override
  String get profileUpdatedMessage => 'Профиль обновлён';

  @override
  String saveErrorMessage(String error) {
    return 'Ошибка при сохранении: $error';
  }

  @override
  String genericErrorMessage(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get security => 'Безопасность';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get changePasswordSubtitle => 'Обновите свой пароль';

  @override
  String get changePasswordTitle => 'Сменить пароль';

  @override
  String get currentPasswordLabel => 'Текущий пароль';

  @override
  String get newPasswordLabel => 'Новый пароль';

  @override
  String get repeatNewPasswordLabel => 'Повторите новый пароль';

  @override
  String get changePasswordSubmit => 'Обновить';

  @override
  String get changePasswordSuccess => 'Пароль обновлён ✅';

  @override
  String get changePasswordErrorGeneric => 'Не удалось обновить пароль';

  @override
  String get changePasswordValidationCurrentRequired =>
      'Введите текущий пароль';

  @override
  String changePasswordValidationMinLength(Object min) {
    return 'Минимум $min символов';
  }

  @override
  String get changePasswordValidationRepeatMismatch => 'Не совпадает';

  @override
  String get loadingMessage => 'Загрузка...';

  @override
  String get noDataMessage => 'Нет данных';

  @override
  String get closeTooltip => 'Закрыть';

  @override
  String get reportDetailTitle => 'Подробности отчёта';

  @override
  String get mainDataSection => 'Основные Данные';

  @override
  String get personLabel => 'Человек';

  @override
  String get supportCountryLabel => 'Страна Поддержки';

  @override
  String get workingLanguageModalLabel => 'Рабочий Язык';

  @override
  String get datesAndTimesSection => 'Даты и Времена';

  @override
  String get startLabel => 'Начало';

  @override
  String get endLabel => 'Конец';

  @override
  String get startTimeModalLabel => 'Время Начала';

  @override
  String get endTimeModalLabel => 'Время Окончания';

  @override
  String get tasksSection => 'Задачи';

  @override
  String get listLabel => 'Список';

  @override
  String get descriptionModalLabel => 'Описание';

  @override
  String get noteSection => 'Заметка';

  @override
  String noteDetailLabel(Object note) {
    return 'Заметка: $note';
  }

  @override
  String countryDetailLabel(Object country) {
    return 'Страна: $country';
  }

  @override
  String languageDetailLabel(Object language) {
    return 'Язык: $language';
  }

  @override
  String timeDetailLabel(Object time) {
    return 'Время: $time';
  }

  @override
  String tasksDetailLabel(Object tasks) {
    return 'Задачи: $tasks';
  }

  @override
  String get noteDetailPrefix => 'Заметка';

  @override
  String get countryDetailPrefix => 'Страна';

  @override
  String get languageDetailPrefix => 'Язык';

  @override
  String get timeDetailPrefix => 'Время';

  @override
  String get tasksDetailPrefix => 'Задачи';

  @override
  String get trackingFallback => 'Запись';

  @override
  String get languageSelectionTitle => 'Язык';

  @override
  String connectedStatus(String connectionType) {
    return 'Подключено ($connectionType)';
  }

  @override
  String get disconnectedStatus => 'Нет соединения';

  @override
  String get readyToSync => 'Готов к синхронизации';

  @override
  String get syncing => 'Синхронизация...';

  @override
  String get lastSyncSuccess => 'Последняя синхронизация успешна';

  @override
  String get syncError => 'Ошибка синхронизации';

  @override
  String get syncPaused => 'Синхронизация приостановлена';

  @override
  String get syncStatusTitle => 'Статус Синхронизации';

  @override
  String get connectivityTitle => 'Подключение';

  @override
  String get statusLabel => 'Статус';

  @override
  String get connectedLabel => 'Подключено';

  @override
  String get disconnectedLabel => 'Отключено';

  @override
  String get typeLabel => 'Тип';

  @override
  String get syncTitle => 'Синхронизация';

  @override
  String get pendingEntriesLabel => 'Ожидающие записи';

  @override
  String get failedEntriesLabel => 'Неудачные записи';

  @override
  String get syncButton => 'Синхронизировать';

  @override
  String get closeButton => 'Закрыть';

  @override
  String pendingCountLabel(int count) {
    return '$count ожидают';
  }

  @override
  String failedCountLabel(int count) {
    return '$count неудачно';
  }

  @override
  String get fewSecondsAgo => 'Несколько секунд назад';

  @override
  String minutesAgo(int minutes) {
    return '$minutes минут назад';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours часов назад';
  }

  @override
  String get noAccessToken => 'Нет токена доступа';

  @override
  String httpError(int statusCode, String message) {
    return 'Ошибка $statusCode: $message';
  }

  @override
  String get emptyFieldValue => '-';

  @override
  String get app_name => 'TimeTracker';

  @override
  String get login_title => 'Войти';

  @override
  String get login_button => 'Войти';

  @override
  String get logout_button => 'Выйти';

  @override
  String report_items_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записей',
      few: '$count записи',
      one: '1 запись',
      zero: 'Нет записей',
    );
    return '$_temp0';
  }

  @override
  String get date_format_hint => 'MMM d, y • HH:mm';

  @override
  String get reportsScreenTitle => 'Отчёты';

  @override
  String get teamCardTitle => 'Команда';

  @override
  String get meCardTitle => 'Я';

  @override
  String get teamCardSubtitle => 'Отчеты за последний месяц';

  @override
  String get meCardSubtitle => 'Отчеты за последний месяц';

  @override
  String get teamCardSubtitleAdmin => 'Отчеты организации (вид ADMIN)';

  @override
  String get teamCardSubtitleNonAdmin =>
      'То же, что \'Я\' (ограниченный доступ)';

  @override
  String meCardSubtitleRole(Object role) {
    return 'Мои отчеты ($role)';
  }

  @override
  String get dailyComparisonTitle => 'Ежедневное сравнение';

  @override
  String get myEvolutionTitle => 'Эволюция (Я)';

  @override
  String errorLabel(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get noReportsInPeriod => 'Нет отчётов за период';

  @override
  String reportIdLabel(String id) {
    return 'Отчёт $id…';
  }

  @override
  String reportDateUserLabel(String date, String userId) {
    return 'Дата: $date • Пользователь: $userId…';
  }

  @override
  String reportIdField(String id) {
    return '• ID: $id';
  }

  @override
  String reportUserField(String userId) {
    return '• Пользователь: $userId';
  }

  @override
  String reportStartDateField(String startDate) {
    return '• Дата начала: $startDate';
  }

  @override
  String reportOrganizationField(String organizationId) {
    return '• Организация: $organizationId';
  }

  @override
  String reportProjectField(String projectId) {
    return '• Проект: $projectId';
  }

  @override
  String reportNotesField(String notes) {
    return '• Заметки: $notes';
  }

  @override
  String get unknownValue => '—';

  @override
  String get dashboardTitle => 'Панель';

  @override
  String get trackingTileTitle => 'Отслеживание';

  @override
  String get trackingTileSubtitle => 'Запуск и остановка';

  @override
  String get reportsTileTitle => 'Отчёты';

  @override
  String get reportsTileSubtitle => 'Время и метрики';

  @override
  String get accountTileTitle => 'Аккаунт';

  @override
  String get accountTileSubtitle => 'Профиль и сессия';
}
