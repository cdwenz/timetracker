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
  String get forgotPassword => 'Forgot password';

  @override
  String get forgotPasswordTitle => 'Recover password';

  @override
  String get forgotPasswordInstruction =>
      'Enter your email and we’ll send you a link to reset your password.';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get sendButton => 'Send';

  @override
  String get forgotPasswordSent => 'Check your email';

  @override
  String get forgotPasswordErrorGeneric => 'Couldn\'t send the recovery email';

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
  String get taskRefinement => 'Refinement';

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
  String get period => 'Períod';

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

  @override
  String get enhancedReportsTitle => 'Enhanced Reports';

  @override
  String get advancedReportsTooltip => 'Advanced Reports';

  @override
  String get basicReportsTitle => 'Basic Reports';

  @override
  String get regionalReportsTitle => 'Regional Reports';

  @override
  String get regionalSummaryTitle => 'REGIONAL SUMMARY:';

  @override
  String get regionalComparisonTitle => 'Regional Comparison';

  @override
  String get countryBreakdownTitle => 'Country Breakdown';

  @override
  String get languageDistributionTitle => 'Language Distribution';

  @override
  String get regionalDashboard => 'Dashboard Regional';

  @override
  String get roleBasedAccess => 'Role-based access';

  @override
  String get accessLevel => 'Access Level';

  @override
  String get availableReports => 'Available Reports';

  @override
  String get selectRegionForDetails => 'Select a region to view details';

  @override
  String get compareRegions => 'Compare Regions';

  @override
  String get viewCountryBreakdown => 'View Country Breakdown';

  @override
  String get analyzeLanguageDistribution => 'Analyze Language Distribution';

  @override
  String get activeFiltersTitle => 'Active Filters';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get filterByRegion => 'Filter by region';

  @override
  String get filterByDates => 'Filter by dates';

  @override
  String get allRegions => 'All regions';

  @override
  String get selectRegions => 'Select Regions';

  @override
  String get selectAtLeast2Regions => 'Select at least 2 regions to compare';

  @override
  String selectedRegionsCount(int count) {
    return 'Selected Regions ($count/10)';
  }

  @override
  String get totalHours => 'Total Hours';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get activeUsers => 'Active Users';

  @override
  String get totalLanguages => 'Total Languages';

  @override
  String get totalCountries => 'Total Countries';

  @override
  String get totalRegions => 'Regions';

  @override
  String get averagePerRegion => 'Average/Region';

  @override
  String get averagePerCountry => 'Average/Country';

  @override
  String get averagePerLanguage => 'Average/Language';

  @override
  String get topCountries => 'Top Countries';

  @override
  String get languageBreakdown => 'Language Breakdown';

  @override
  String get performanceMetrics => 'Performance Metrics';

  @override
  String get comparisonSummary => 'Comparison Summary';

  @override
  String get detailedMetrics => 'Detailed Metrics';

  @override
  String get performanceHighlights => 'Performance Highlights';

  @override
  String get mainMetrics => 'Main Metrics';

  @override
  String get metricTotalHours => 'Total Hours';

  @override
  String get metricTotalEntries => 'Total Entries';

  @override
  String get metricActiveUsers => 'Active Users';

  @override
  String get metricAverageHoursPerUser => 'Average Hours per User';

  @override
  String get metricAverageHoursPerEntry => 'Average Hours per Entry';

  @override
  String get metricProductivityScore => 'Productivity Score';

  @override
  String get metricCompletionRate => 'Completion Rate';

  @override
  String get metricResponseTime => 'Response Time';

  @override
  String get metricQualityScore => 'Quality Score';

  @override
  String get metricEfficiencyRating => 'Efficiency Rating';

  @override
  String get metricWeeklyHours => 'Weekly Hours';

  @override
  String get metricMonthlyHours => 'Monthly Hours';

  @override
  String get metricPeakHours => 'Peak Hours';

  @override
  String get metricOffPeakHours => 'Off-Peak Hours';

  @override
  String get metricTeamCollaboration => 'Team Collaboration';

  @override
  String get metricResourceUtilization => 'Resource Utilization';

  @override
  String get metricTaskCompletion => 'Task Completion';

  @override
  String get metricPerformanceIndex => 'Performance Index';

  @override
  String errorLoadingSummary(String error) {
    return 'Error loading summary: $error';
  }

  @override
  String get noDataAvailableForRegion => 'No data available for this region';

  @override
  String get activeFilters => 'Active Filters';

  @override
  String countriesFilter(String countries) {
    return 'Countries: $countries';
  }

  @override
  String languagesFilter(String languages) {
    return 'Languages: $languages';
  }

  @override
  String get mostUsed => 'Most Used';

  @override
  String get leastUsed => 'Least Used';

  @override
  String get mostActive => 'Most Active';

  @override
  String get leastActive => 'Least Active';

  @override
  String get bestPerformance => 'Best Performance';

  @override
  String get worstPerformance => 'Worst Performance';

  @override
  String get hoursPerUser => 'Hours/User';

  @override
  String get entriesPerUser => 'Entries/User';

  @override
  String languagesUsed(Object languages) {
    return 'Languages used: $languages';
  }

  @override
  String get countriesWithActivity => 'Countries with Activity';

  @override
  String get languagesWithActivity => 'Languages with Activity';

  @override
  String get periodInformation => 'Period Information';

  @override
  String fromDate(String date) {
    return 'From: $date';
  }

  @override
  String toDate(String date) {
    return 'To: $date';
  }

  @override
  String regionScope(String region) {
    return 'Region: $region';
  }

  @override
  String get allRegionsScope => 'Scope: All regions';

  @override
  String filteredCountry(String country) {
    return 'Filtered country: $country';
  }

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get noDataForRegion => 'No data available for this region';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get refreshData => 'Refresh';

  @override
  String get exportReport => 'Export Report';

  @override
  String get generateReport => 'Generate Report';

  @override
  String get exportToPDF => 'Export to PDF';

  @override
  String get exportToExcel => 'Export to Excel';

  @override
  String get exportToCSV => 'Export to CSV';

  @override
  String get shareReport => 'Share Report';

  @override
  String get distributionChart => 'Distribution Chart';

  @override
  String get comparisonChart => 'Comparison Chart';

  @override
  String get detailsTable => 'Details Table';

  @override
  String get statisticsInsights => 'Statistics & Insights';

  @override
  String get regionalDistribution => 'Regional Distribution';

  @override
  String get selectItemsToExport => 'Select items to export';

  @override
  String get exportOptions => 'Export Options';

  @override
  String get includeCharts => 'Include charts';

  @override
  String get includeRawData => 'Include raw data';

  @override
  String get includeSummary => 'Include summary';

  @override
  String get exportSuccess => 'Report exported successfully';

  @override
  String exportError(String error) {
    return 'Error exporting report: $error';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get compare => 'Compare';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get advancedReportsScreenTitle => 'Advanced Reports';

  @override
  String get userAccessLevelTitle => 'Your access level';

  @override
  String get personalDashboardTitle => 'Personal Dashboard (last 30 days)';

  @override
  String get myEntriesTitle => 'My Entries';

  @override
  String get teamTitle => 'Team';

  @override
  String get totalHoursTitle => 'Total Hours';

  @override
  String get activeUsersTitle => 'Active Users';

  @override
  String get activeRegionsTitle => 'Active Regions';

  @override
  String get mostActiveRegionsTitle => 'Most Active Regions';

  @override
  String get advancedReportsTitle => 'Advanced Reports';

  @override
  String get compareRegionsTitle => 'Compare Regions';

  @override
  String get byCountriesTitle => 'By Countries';

  @override
  String get byLanguagesTitle => 'By Languages';

  @override
  String get compareRegionsSubtitle => 'Analyze multiple regions';

  @override
  String get byCountriesSubtitle => 'Country breakdown';

  @override
  String get byLanguagesSubtitle => 'Language distribution';

  @override
  String get dailyComparisonSubtitle => 'Me vs Team';

  @override
  String availableRegionsTitle(Object count) {
    return 'Available Regions ($count)';
  }

  @override
  String get regionalAccessEnabled => 'Regional reports access enabled';

  @override
  String get teamReportsIncludingYours => 'Team reports (including yours)';

  @override
  String get noBasicDashboardData => 'No basic dashboard data available';

  @override
  String get noRegionalData => 'No regional data available';

  @override
  String get analysisMultipleRegions => 'Analysis of multiple regions';

  @override
  String get at2RegionsRequired => 'At least 2 regions needed to compare';

  @override
  String get updateData => 'Update data';

  @override
  String get hours => 'Hours';

  @override
  String get dashboardComplete => 'Complete Dashboard';

  @override
  String get generalSummaryMetrics => 'General summary and basic metrics';

  @override
  String get regionalDataComparisons => 'Regional data and comparisons';

  @override
  String get noBasicDashboardDataAvailable =>
      'No basic dashboard data available';

  @override
  String get noRegionalDataAvailable => 'No regional data available';

  @override
  String get needAtLeast2RegionsCompare =>
      'At least 2 regions needed to compare';

  @override
  String get updateDataTooltip => 'Update data';

  @override
  String get myReports => 'My Reports';

  @override
  String get teamReports => 'Team Reports';

  @override
  String get userRole => 'User';

  @override
  String get meLabel => 'Me';

  @override
  String get teamLabel => 'Team';

  @override
  String errorLoadingReports(Object error) {
    return 'Error loading reports: $error';
  }

  @override
  String get dashboardReport => 'Dashboard Report';

  @override
  String get basicDashboardReport => 'Basic Dashboard Report';

  @override
  String get generated => 'Generated';

  @override
  String get user => 'User';

  @override
  String get role => 'Role';

  @override
  String get unknown => 'Unknown';

  @override
  String get dashboardMetrics => 'Dashboard Metrics';

  @override
  String get teamCount => 'Team Count';

  @override
  String get meCount => 'Me Count';

  @override
  String get dailyComparison => 'Daily Comparison';

  @override
  String get day => 'Day';

  @override
  String get myCount => 'My Count';

  @override
  String get myTrend => 'My Trend';

  @override
  String get count => 'Count';

  @override
  String get regionalDashboardReport => 'Regional Dashboard Report';

  @override
  String get summary => 'Summary';

  @override
  String get regionalSummary => 'Regional Summary';

  @override
  String get country => 'Country';

  @override
  String get percentage => 'Percentage';

  @override
  String get topLanguages => 'Top Languages';

  @override
  String get language => 'Language';

  @override
  String get dashboardMetricsTitle => 'DASHBOARD METRICS:';

  @override
  String get dailyComparisonTitleHeader => 'DAILY COMPARISON:';

  @override
  String get myTrendTitle => 'MY TREND:';

  @override
  String get topCountriesTitle => 'TOP COUNTRIES:';

  @override
  String get topLanguagesTitle => 'TOP LANGUAGES:';

  @override
  String get regionalComparison => 'Regional Comparison';

  @override
  String errorComparingRegions(Object error) {
    return 'Error comparing regions: $error';
  }

  @override
  String get regionalComparisonReportSubject => 'Regional Comparison Report';

  @override
  String selectedRegions(Object count) {
    return 'Selected Regions ($count/10)';
  }

  @override
  String get selectAtLeast2RegionsToCompare =>
      'Select at least 2 regions to compare';

  @override
  String get regions => 'Regions';

  @override
  String get totalHoursComparison => 'Total Hours Comparison';

  @override
  String get region => 'Region';

  @override
  String get entries => 'Entries';

  @override
  String get users => 'Users';

  @override
  String get hrsPerUser => 'Hrs/User';

  @override
  String get topCountry => 'Top Country';

  @override
  String get topLanguage => 'Top Language';

  @override
  String get selectRegionsDialog => 'Select Regions';

  @override
  String selectBetween2And10Regions(Object count) {
    return 'Select between 2 and 10 regions ($count selected)';
  }

  @override
  String get countryBreakdown => 'Country Breakdown';

  @override
  String get averageHrsPerUser => 'Average hrs/user';

  @override
  String get averageEntriesPerUser => 'Average entries/user';

  @override
  String get generalSummaryAndMetrics => 'General summary and basic metrics';

  @override
  String get regionalDataAndComparisons => 'Regional data and comparisons';

  @override
  String get atLeast2RegionsRequired =>
      'At least 2 regions required for comparison';

  @override
  String get noRegionalDataAvailableMessage => 'No regional data available';

  @override
  String errorLoadingData(Object error) {
    return 'Error loading data: $error';
  }

  @override
  String get countryBreakdownReportSubject => 'Country Breakdown Report';

  @override
  String get selectedRegion => 'Selected region';

  @override
  String countries(Object countries) {
    return 'Countries: $countries';
  }

  @override
  String get generalSummary => 'General Summary';

  @override
  String get countryDistribution => 'Country Distribution (Top 10)';

  @override
  String countryDetails(Object count) {
    return 'Country Details ($count)';
  }

  @override
  String get averageHoursPerCountry => 'Average Hours/Country';

  @override
  String get activeCountries => 'Active Countries';

  @override
  String from(Object date) {
    return 'From: $date';
  }

  @override
  String to(Object date) {
    return 'To: $date';
  }

  @override
  String errorLoadingLanguageData(Object error) {
    return 'Error loading data: $error';
  }

  @override
  String get languageDistributionReportSubject =>
      'Language Distribution Report';

  @override
  String get languageDistribution => 'Language Distribution';

  @override
  String languages(Object languages) {
    return 'Languages: $languages';
  }

  @override
  String get hoursPerLanguage => 'Hours per Language';

  @override
  String languageDetails(Object count) {
    return 'Language Details ($count)';
  }

  @override
  String countriesWhereUsed(Object countries) {
    return 'Countries where used: $countries';
  }

  @override
  String get regionalLanguageDistribution =>
      'Regional Language Distribution (Top 5)';

  @override
  String get averageHoursPerLanguage => 'Average Hours/Language';

  @override
  String get activeLanguages => 'Active Languages';

  @override
  String countryFiltered(Object country) {
    return 'Country filtered: $country';
  }

  @override
  String get regionalSummaryReport => 'Regional Summary Report';

  @override
  String get topCountriesLabel => 'Top Countries';

  @override
  String get languageBreakdownLabel => 'Language Breakdown';

  @override
  String get regionalComparisonReport => 'Regional Comparison Report';

  @override
  String get averageHoursPerRegion => 'Average Hours per Region';

  @override
  String get regionalDataLabel => 'Regional Data';

  @override
  String get avgHoursPerUser => 'Avg Hours/User';

  @override
  String get countryBreakdownReport => 'Country Breakdown Report';

  @override
  String get countryDetailsLabel => 'Country Details';

  @override
  String get rank => 'Rank';

  @override
  String get avgEntriesPerUser => 'Avg Entries/User';

  @override
  String get languageColumn => 'Languages';

  @override
  String get languageDistributionReport => 'Language Distribution Report';

  @override
  String get languageDetailsLabel => 'Language Details';

  @override
  String get countryColumn => 'Countries';
}
