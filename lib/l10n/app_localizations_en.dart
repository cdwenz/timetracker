// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TimeTracker';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPasswordTooltip => 'Show';

  @override
  String get hidePasswordTooltip => 'Hide';

  @override
  String get loginButton => 'Log In';

  @override
  String get registerLink => 'Don\'t have an account? Sign up';

  @override
  String get offlineModeMessage => 'Offline mode - Using saved credentials';

  @override
  String get internetRequiredMessage =>
      'No connection - Internet required for first login';

  @override
  String get offlineFirstLoginMessage =>
      'No connection. You need to login online first to use the app offline.';

  @override
  String get incorrectCredentials => 'Incorrect credentials';

  @override
  String get createAccount => 'Create Account';

  @override
  String get nameLabel => 'Name';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get registrationSuccess => 'Registration successful. Please sign in.';

  @override
  String get allFieldsRequired => 'All fields are required';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get registrationError => 'There was a problem registering';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name!';
  }

  @override
  String get startTrackingButton => 'Start Tracking';

  @override
  String get menuTitle => 'Menu';

  @override
  String get homeMenuItem => 'Home';

  @override
  String get accountMenuItem => 'Account';

  @override
  String get reportsMenuItem => 'Reports';

  @override
  String get logoutMenuItem => 'Log Out';

  @override
  String get offlineModeTitle => '📱 Offline Mode';

  @override
  String get offlineModeDescription =>
      'No internet connection. Records will be saved locally.';

  @override
  String get loginRequiredTitle => '🔐 Need to login online';

  @override
  String loginRequiredMessage(int count) {
    return 'You have $count pending records. To sync you need to log out and login with internet.';
  }

  @override
  String get logoutAndLoginButton => 'Log out and login';

  @override
  String get syncErrorTitle => '⚠️ Records with sync error';

  @override
  String get pendingSyncTitle => '📤 Pending records to sync';

  @override
  String syncErrorMessage(int failedCount, int pendingCount) {
    return 'You have $failedCount records with errors and $pendingCount pending';
  }

  @override
  String pendingSyncMessage(int pendingCount) {
    return 'You have $pendingCount records waiting for synchronization';
  }

  @override
  String get synchronizing => 'Synchronizing...';

  @override
  String get syncNowButton => 'Sync Now';

  @override
  String get retryButton => 'Retry';

  @override
  String get logoutDialogTitle => 'Log Out';

  @override
  String get logoutDialogMessage =>
      'To sync your pending records you need to log out and login again with internet connection.\\n\\nDo you want to log out now?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String logoutErrorMessage(String error) {
    return 'Error logging out: $error';
  }

  @override
  String get step1Title => 'Step 1 of 7';

  @override
  String get step1Question => 'What did you do today?';

  @override
  String get step1Description =>
      'Write a brief description of the activity you performed.';

  @override
  String get step1Placeholder => 'Ex: I helped a Piaroa translator to...';

  @override
  String get nextButton => 'Next';

  @override
  String get step1Validation => 'Please complete the note.';

  @override
  String get step2Title => 'Step 2 of 7';

  @override
  String get step2Question => 'Who did you help today?';

  @override
  String get recipientLabel => 'Recipient';

  @override
  String get supportedCountryLabel => 'Supported Country';

  @override
  String get countryPlaceholder => 'Ex: AR, United States, etc.';

  @override
  String get workingLanguageLabel => 'Working Language';

  @override
  String get languagePlaceholder => 'Ex: es, en, portuguese...';

  @override
  String get recipientValidation => 'Complete the recipient.';

  @override
  String get countryValidation => 'supportedCountry is required';

  @override
  String get languageValidation => 'workingLanguage is required';

  @override
  String get savingButton => 'Saving...';

  @override
  String get continueButton => 'Continue';

  @override
  String get step3Title => 'Step 3 of 7';

  @override
  String get step3Question => 'What is your name?';

  @override
  String get step3Description =>
      'This name will be used to record your participation.';

  @override
  String get step3Placeholder => 'Ex: John Smith';

  @override
  String get step3Validation => 'Complete your name.';

  @override
  String get step4Title => 'Step 4 of 7';

  @override
  String get step4Question => 'When did it happen?';

  @override
  String get step4Description =>
      'Select the start and end date of the activity.';

  @override
  String get startDateLabel => 'Start';

  @override
  String get endDateLabel => 'End';

  @override
  String get selectDateButton => 'Select';

  @override
  String get step4Validation => 'Please complete both dates.';

  @override
  String get step5Title => 'Step 5 of 7';

  @override
  String get step5Question => 'What time was it?';

  @override
  String get step5Description =>
      'Select the start and end time of the activity.';

  @override
  String get startTimeLabel => 'Start time';

  @override
  String get endTimeLabel => 'End time';

  @override
  String get step5Validation => 'Please complete both times.';

  @override
  String get step6Title => 'Step 6 of 7';

  @override
  String get step6Question => 'What tasks did you perform?';

  @override
  String get step6Description =>
      'Select one or more tasks performed and write details if you want.';

  @override
  String get additionalDetailsPlaceholder => 'Additional details...';

  @override
  String get step6Validation => 'Select at least one task.';

  @override
  String get step7Title => 'Step 7 of 7';

  @override
  String get step7Question => 'Summary of your activity';

  @override
  String get noteLabel => 'Note';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get tasksLabel => 'Tasks';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get finishButton => 'Finish';

  @override
  String get successMessage => 'Record sent successfully.';

  @override
  String get errorMessage => 'Error sending the record.';

  @override
  String get taskMAST => 'MAST';

  @override
  String get taskBTTSupport => 'BTT Support (Writer, Orature, USFM, Recorder)';

  @override
  String get taskTraining => 'Training';

  @override
  String get taskTechnicalSupport => 'Technical Support';

  @override
  String get taskVMAST => 'V-Mast';

  @override
  String get taskTranscribe => 'Transcribe';

  @override
  String get taskQualityAssurance => 'Quality Assurance Processes';

  @override
  String get taskIhadiDevelopment => 'Ihadi software development';

  @override
  String get taskAI => 'AI';

  @override
  String get taskSpecialAssignment => 'Special Assignment';

  @override
  String get taskRevision => 'Revision';

  @override
  String get taskOther => 'Other';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get selectRangeTooltip => 'Select range';

  @override
  String get reloadTooltip => 'Reload';

  @override
  String roleLabel(String role) {
    return 'Role: $role';
  }

  @override
  String scopeLabel(String scope) {
    return 'Scope: $scope';
  }

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleFieldManager => 'Field Manager';

  @override
  String get roleUser => 'User';

  @override
  String get scopeAll => 'All';

  @override
  String get scopeMyTeam => 'My Team';

  @override
  String get scopeMyRecords => 'My Records';

  @override
  String get myTrackingsOnly => 'My trackings only';

  @override
  String get searchPlaceholder => 'Search by name, note, etc.';

  @override
  String get noTrackingsMessage => 'No trackings to show';

  @override
  String loadReportsError(String error) {
    return 'Could not load reports: $error';
  }

  @override
  String get accountTitle => 'My Account';

  @override
  String get defaultUserName => 'User';

  @override
  String get guestRole => 'Guest';

  @override
  String get verifyingAuthStatus => 'Verifying authentication status...';

  @override
  String userCountryLabel(String country) {
    return 'Country: $country';
  }

  @override
  String userRoleLabel(String role) {
    return 'Role: $role';
  }

  @override
  String get countryFieldLabel => 'Country';

  @override
  String get nameRequiredValidation => 'Name is required';

  @override
  String get saveChangesButton => 'Save Changes';

  @override
  String get profileUpdatedMessage => 'Profile updated';

  @override
  String saveErrorMessage(String error) {
    return 'Error saving: $error';
  }

  @override
  String genericErrorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordSubtitle => 'Update your account password';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get repeatNewPasswordLabel => 'Repeat new password';

  @override
  String get changePasswordSubmit => 'Update';

  @override
  String get changePasswordSuccess => 'Password updated ✅';

  @override
  String get changePasswordErrorGeneric => 'Couldn\'t update the password';

  @override
  String get changePasswordValidationCurrentRequired =>
      'Enter your current password';

  @override
  String changePasswordValidationMinLength(Object min) {
    return 'At least $min characters';
  }

  @override
  String get changePasswordValidationRepeatMismatch => 'Does not match';

  @override
  String get loadingMessage => 'Loading...';

  @override
  String get noDataMessage => 'No data';

  @override
  String get closeTooltip => 'Close';

  @override
  String get reportDetailTitle => 'Report detail';

  @override
  String get mainDataSection => 'Main Data';

  @override
  String get personLabel => 'Person';

  @override
  String get supportCountryLabel => 'Support Country';

  @override
  String get workingLanguageModalLabel => 'Working Language';

  @override
  String get datesAndTimesSection => 'Dates and Times';

  @override
  String get startLabel => 'Start';

  @override
  String get endLabel => 'End';

  @override
  String get startTimeModalLabel => 'Start Time';

  @override
  String get endTimeModalLabel => 'End Time';

  @override
  String get tasksSection => 'Tasks';

  @override
  String get listLabel => 'List';

  @override
  String get descriptionModalLabel => 'Description';

  @override
  String get noteSection => 'Note';

  @override
  String noteDetailLabel(Object note) {
    return 'Note: $note';
  }

  @override
  String countryDetailLabel(Object country) {
    return 'Country: $country';
  }

  @override
  String languageDetailLabel(Object language) {
    return 'Language: $language';
  }

  @override
  String timeDetailLabel(Object time) {
    return 'Time: $time';
  }

  @override
  String tasksDetailLabel(Object tasks) {
    return 'Tasks: $tasks';
  }

  @override
  String get noteDetailPrefix => 'Note';

  @override
  String get countryDetailPrefix => 'Country';

  @override
  String get languageDetailPrefix => 'Language';

  @override
  String get timeDetailPrefix => 'Time';

  @override
  String get tasksDetailPrefix => 'Tasks';

  @override
  String get trackingFallback => 'Tracking';

  @override
  String get languageSelectionTitle => 'Language';

  @override
  String connectedStatus(String connectionType) {
    return 'Connected ($connectionType)';
  }

  @override
  String get disconnectedStatus => 'No connection';

  @override
  String get readyToSync => 'Ready to sync';

  @override
  String get syncing => 'Syncing...';

  @override
  String get lastSyncSuccess => 'Last sync successful';

  @override
  String get syncError => 'Sync error';

  @override
  String get syncPaused => 'Sync paused';

  @override
  String get syncStatusTitle => 'Sync Status';

  @override
  String get connectivityTitle => 'Connectivity';

  @override
  String get statusLabel => 'Status';

  @override
  String get connectedLabel => 'Connected';

  @override
  String get disconnectedLabel => 'Disconnected';

  @override
  String get typeLabel => 'Type';

  @override
  String get syncTitle => 'Synchronization';

  @override
  String get pendingEntriesLabel => 'Pending entries';

  @override
  String get failedEntriesLabel => 'Failed entries';

  @override
  String get syncButton => 'Sync';

  @override
  String get closeButton => 'Close';

  @override
  String pendingCountLabel(int count) {
    return '$count pending';
  }

  @override
  String failedCountLabel(int count) {
    return '$count failed';
  }

  @override
  String get fewSecondsAgo => 'A few seconds ago';

  @override
  String minutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get noAccessToken => 'No access token';

  @override
  String httpError(int statusCode, String message) {
    return 'Error $statusCode: $message';
  }

  @override
  String get emptyFieldValue => '-';

  @override
  String get app_name => 'TimeTracker';

  @override
  String get login_title => 'Sign in';

  @override
  String get login_button => 'Log in';

  @override
  String get logout_button => 'Log out';

  @override
  String report_items_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
      zero: 'No entries',
    );
    return '$_temp0';
  }

  @override
  String get date_format_hint => 'MMM d, y • HH:mm';

  @override
  String get reportsScreenTitle => 'Reports';

  @override
  String get teamCardTitle => 'Team';

  @override
  String get meCardTitle => 'Me';

  @override
  String get teamCardSubtitle => 'Reports last month';

  @override
  String get meCardSubtitle => 'Reports last month';

  @override
  String get teamCardSubtitleAdmin => 'Organization reports (ADMIN view)';

  @override
  String get teamCardSubtitleNonAdmin => 'Same as \'Me\' (limited access)';

  @override
  String meCardSubtitleRole(Object role) {
    return 'My reports ($role)';
  }

  @override
  String get dailyComparisonTitle => 'Daily comparison';

  @override
  String get myEvolutionTitle => 'Evolution (Me)';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String get noReportsInPeriod => 'No reports in the period';

  @override
  String reportIdLabel(String id) {
    return 'Report $id…';
  }

  @override
  String reportDateUserLabel(String date, String userId) {
    return 'Date: $date • User: $userId…';
  }

  @override
  String reportIdField(String id) {
    return '• ID: $id';
  }

  @override
  String reportUserField(String userId) {
    return '• User: $userId';
  }

  @override
  String reportStartDateField(String startDate) {
    return '• Start date: $startDate';
  }

  @override
  String reportOrganizationField(String organizationId) {
    return '• Organization: $organizationId';
  }

  @override
  String reportProjectField(String projectId) {
    return '• Project: $projectId';
  }

  @override
  String reportNotesField(String notes) {
    return '• Notes: $notes';
  }

  @override
  String get unknownValue => '—';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get trackingTileTitle => 'Tracking';

  @override
  String get trackingTileSubtitle => 'Start and stop';

  @override
  String get reportsTileTitle => 'Reports';

  @override
  String get reportsTileSubtitle => 'Times and metrics';

  @override
  String get accountTileTitle => 'Account';

  @override
  String get accountTileSubtitle => 'Profile and session';
}
