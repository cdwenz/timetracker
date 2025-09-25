import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TimeTracker'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @showPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showPasswordTooltip;

  /// No description provided for @hidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hidePasswordTooltip;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get registerLink;

  /// No description provided for @offlineModeMessage.
  ///
  /// In en, this message translates to:
  /// **'Offline mode - Using saved credentials'**
  String get offlineModeMessage;

  /// No description provided for @internetRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'No connection - Internet required for first login'**
  String get internetRequiredMessage;

  /// No description provided for @offlineFirstLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'No connection. You need to login online first to use the app offline.'**
  String get offlineFirstLoginMessage;

  /// No description provided for @incorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials'**
  String get incorrectCredentials;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerButton;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Please sign in.'**
  String get registrationSuccess;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required'**
  String get allFieldsRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'There was a problem registering'**
  String get registrationError;

  /// Personalized greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @startTrackingButton.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startTrackingButton;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @homeMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeMenuItem;

  /// No description provided for @accountMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountMenuItem;

  /// No description provided for @reportsMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsMenuItem;

  /// No description provided for @logoutMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutMenuItem;

  /// No description provided for @offlineModeTitle.
  ///
  /// In en, this message translates to:
  /// **'📱 Offline Mode'**
  String get offlineModeTitle;

  /// No description provided for @offlineModeDescription.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Records will be saved locally.'**
  String get offlineModeDescription;

  /// No description provided for @loginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'🔐 Need to login online'**
  String get loginRequiredTitle;

  /// Message when login is required for sync
  ///
  /// In en, this message translates to:
  /// **'You have {count} pending records. To sync you need to log out and login with internet.'**
  String loginRequiredMessage(int count);

  /// No description provided for @logoutAndLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log out and login'**
  String get logoutAndLoginButton;

  /// No description provided for @syncErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Records with sync error'**
  String get syncErrorTitle;

  /// No description provided for @pendingSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'📤 Pending records to sync'**
  String get pendingSyncTitle;

  /// Message showing failed and pending sync counts
  ///
  /// In en, this message translates to:
  /// **'You have {failedCount} records with errors and {pendingCount} pending'**
  String syncErrorMessage(int failedCount, int pendingCount);

  /// Message showing pending sync count
  ///
  /// In en, this message translates to:
  /// **'You have {pendingCount} records waiting for synchronization'**
  String pendingSyncMessage(int pendingCount);

  /// No description provided for @synchronizing.
  ///
  /// In en, this message translates to:
  /// **'Synchronizing...'**
  String get synchronizing;

  /// No description provided for @syncNowButton.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNowButton;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'To sync your pending records you need to log out and login again with internet connection.\\n\\nDo you want to log out now?'**
  String get logoutDialogMessage;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Error message when logout fails
  ///
  /// In en, this message translates to:
  /// **'Error logging out: {error}'**
  String logoutErrorMessage(String error);

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 7'**
  String get step1Title;

  /// No description provided for @step1Question.
  ///
  /// In en, this message translates to:
  /// **'What did you do today?'**
  String get step1Question;

  /// No description provided for @step1Description.
  ///
  /// In en, this message translates to:
  /// **'Write a brief description of the activity you performed.'**
  String get step1Description;

  /// No description provided for @step1Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Ex: I helped a Piaroa translator to...'**
  String get step1Placeholder;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @step1Validation.
  ///
  /// In en, this message translates to:
  /// **'Please complete the note.'**
  String get step1Validation;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 7'**
  String get step2Title;

  /// No description provided for @step2Question.
  ///
  /// In en, this message translates to:
  /// **'Who did you help today?'**
  String get step2Question;

  /// No description provided for @recipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipientLabel;

  /// No description provided for @supportedCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Supported Country'**
  String get supportedCountryLabel;

  /// No description provided for @countryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ex: AR, United States, etc.'**
  String get countryPlaceholder;

  /// No description provided for @workingLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Working Language'**
  String get workingLanguageLabel;

  /// No description provided for @languagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ex: es, en, portuguese...'**
  String get languagePlaceholder;

  /// No description provided for @recipientValidation.
  ///
  /// In en, this message translates to:
  /// **'Complete the recipient.'**
  String get recipientValidation;

  /// No description provided for @countryValidation.
  ///
  /// In en, this message translates to:
  /// **'supportedCountry is required'**
  String get countryValidation;

  /// No description provided for @languageValidation.
  ///
  /// In en, this message translates to:
  /// **'workingLanguage is required'**
  String get languageValidation;

  /// No description provided for @savingButton.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingButton;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 7'**
  String get step3Title;

  /// No description provided for @step3Question.
  ///
  /// In en, this message translates to:
  /// **'What is your name?'**
  String get step3Question;

  /// No description provided for @step3Description.
  ///
  /// In en, this message translates to:
  /// **'This name will be used to record your participation.'**
  String get step3Description;

  /// No description provided for @step3Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Ex: John Smith'**
  String get step3Placeholder;

  /// No description provided for @step3Validation.
  ///
  /// In en, this message translates to:
  /// **'Complete your name.'**
  String get step3Validation;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 7'**
  String get step4Title;

  /// No description provided for @step4Question.
  ///
  /// In en, this message translates to:
  /// **'When did it happen?'**
  String get step4Question;

  /// No description provided for @step4Description.
  ///
  /// In en, this message translates to:
  /// **'Select the start and end date of the activity.'**
  String get step4Description;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endDateLabel;

  /// No description provided for @selectDateButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectDateButton;

  /// No description provided for @step4Validation.
  ///
  /// In en, this message translates to:
  /// **'Please complete both dates.'**
  String get step4Validation;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Step 5 of 7'**
  String get step5Title;

  /// No description provided for @step5Question.
  ///
  /// In en, this message translates to:
  /// **'What time was it?'**
  String get step5Question;

  /// No description provided for @step5Description.
  ///
  /// In en, this message translates to:
  /// **'Select the start and end time of the activity.'**
  String get step5Description;

  /// No description provided for @startTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTimeLabel;

  /// No description provided for @endTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTimeLabel;

  /// No description provided for @step5Validation.
  ///
  /// In en, this message translates to:
  /// **'Please complete both times.'**
  String get step5Validation;

  /// No description provided for @step6Title.
  ///
  /// In en, this message translates to:
  /// **'Step 6 of 7'**
  String get step6Title;

  /// No description provided for @step6Question.
  ///
  /// In en, this message translates to:
  /// **'What tasks did you perform?'**
  String get step6Question;

  /// No description provided for @step6Description.
  ///
  /// In en, this message translates to:
  /// **'Select one or more tasks performed and write details if you want.'**
  String get step6Description;

  /// No description provided for @additionalDetailsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Additional details...'**
  String get additionalDetailsPlaceholder;

  /// No description provided for @step6Validation.
  ///
  /// In en, this message translates to:
  /// **'Select at least one task.'**
  String get step6Validation;

  /// No description provided for @step7Title.
  ///
  /// In en, this message translates to:
  /// **'Step 7 of 7'**
  String get step7Title;

  /// No description provided for @step7Question.
  ///
  /// In en, this message translates to:
  /// **'Summary of your activity'**
  String get step7Question;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @tasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @finishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishButton;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'Record sent successfully.'**
  String get successMessage;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error sending the record.'**
  String get errorMessage;

  /// No description provided for @taskMAST.
  ///
  /// In en, this message translates to:
  /// **'MAST'**
  String get taskMAST;

  /// No description provided for @taskBTTSupport.
  ///
  /// In en, this message translates to:
  /// **'BTT Support (Writer, Orature, USFM, Recorder)'**
  String get taskBTTSupport;

  /// No description provided for @taskTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get taskTraining;

  /// No description provided for @taskTechnicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get taskTechnicalSupport;

  /// No description provided for @taskVMAST.
  ///
  /// In en, this message translates to:
  /// **'V-Mast'**
  String get taskVMAST;

  /// No description provided for @taskTranscribe.
  ///
  /// In en, this message translates to:
  /// **'Transcribe'**
  String get taskTranscribe;

  /// No description provided for @taskQualityAssurance.
  ///
  /// In en, this message translates to:
  /// **'Quality Assurance Processes'**
  String get taskQualityAssurance;

  /// No description provided for @taskIhadiDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Ihadi software development'**
  String get taskIhadiDevelopment;

  /// No description provided for @taskAI.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get taskAI;

  /// No description provided for @taskSpecialAssignment.
  ///
  /// In en, this message translates to:
  /// **'Special Assignment'**
  String get taskSpecialAssignment;

  /// No description provided for @taskRevision.
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get taskRevision;

  /// No description provided for @taskOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get taskOther;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @selectRangeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select range'**
  String get selectRangeTooltip;

  /// No description provided for @reloadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reloadTooltip;

  /// Label showing user role
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String roleLabel(String role);

  /// Label showing reports scope
  ///
  /// In en, this message translates to:
  /// **'Scope: {scope}'**
  String scopeLabel(String scope);

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @roleFieldManager.
  ///
  /// In en, this message translates to:
  /// **'Field Manager'**
  String get roleFieldManager;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @scopeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get scopeAll;

  /// No description provided for @scopeMyTeam.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get scopeMyTeam;

  /// No description provided for @scopeMyRecords.
  ///
  /// In en, this message translates to:
  /// **'My Records'**
  String get scopeMyRecords;

  /// No description provided for @myTrackingsOnly.
  ///
  /// In en, this message translates to:
  /// **'My trackings only'**
  String get myTrackingsOnly;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name, note, etc.'**
  String get searchPlaceholder;

  /// No description provided for @noTrackingsMessage.
  ///
  /// In en, this message translates to:
  /// **'No trackings to show'**
  String get noTrackingsMessage;

  /// Error message when loading reports fails
  ///
  /// In en, this message translates to:
  /// **'Could not load reports: {error}'**
  String loadReportsError(String error);

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get accountTitle;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserName;

  /// No description provided for @guestRole.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestRole;

  /// No description provided for @verifyingAuthStatus.
  ///
  /// In en, this message translates to:
  /// **'Verifying authentication status...'**
  String get verifyingAuthStatus;

  /// Label showing user country
  ///
  /// In en, this message translates to:
  /// **'Country: {country}'**
  String userCountryLabel(String country);

  /// Label showing user role
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String userRoleLabel(String role);

  /// No description provided for @countryFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryFieldLabel;

  /// No description provided for @nameRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequiredValidation;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButton;

  /// No description provided for @profileUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdatedMessage;

  /// Error message when saving profile fails
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String saveErrorMessage(String error);

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericErrorMessage(String error);

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get changePasswordSubtitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @repeatNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get repeatNewPasswordLabel;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated ✅'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the password'**
  String get changePasswordErrorGeneric;

  /// No description provided for @changePasswordValidationCurrentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get changePasswordValidationCurrentRequired;

  /// No description provided for @changePasswordValidationMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters'**
  String changePasswordValidationMinLength(Object min);

  /// No description provided for @changePasswordValidationRepeatMismatch.
  ///
  /// In en, this message translates to:
  /// **'Does not match'**
  String get changePasswordValidationRepeatMismatch;

  /// No description provided for @loadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingMessage;

  /// No description provided for @noDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noDataMessage;

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @reportDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Report detail'**
  String get reportDetailTitle;

  /// No description provided for @mainDataSection.
  ///
  /// In en, this message translates to:
  /// **'Main Data'**
  String get mainDataSection;

  /// No description provided for @personLabel.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get personLabel;

  /// No description provided for @supportCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Support Country'**
  String get supportCountryLabel;

  /// No description provided for @workingLanguageModalLabel.
  ///
  /// In en, this message translates to:
  /// **'Working Language'**
  String get workingLanguageModalLabel;

  /// No description provided for @datesAndTimesSection.
  ///
  /// In en, this message translates to:
  /// **'Dates and Times'**
  String get datesAndTimesSection;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endLabel;

  /// No description provided for @startTimeModalLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTimeModalLabel;

  /// No description provided for @endTimeModalLabel.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTimeModalLabel;

  /// No description provided for @tasksSection.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksSection;

  /// No description provided for @listLabel.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listLabel;

  /// No description provided for @descriptionModalLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionModalLabel;

  /// No description provided for @noteSection.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteSection;

  /// No description provided for @noteDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteDetailLabel(Object note);

  /// No description provided for @countryDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Country: {country}'**
  String countryDetailLabel(Object country);

  /// No description provided for @languageDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Language: {language}'**
  String languageDetailLabel(Object language);

  /// No description provided for @timeDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String timeDetailLabel(Object time);

  /// No description provided for @tasksDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks: {tasks}'**
  String tasksDetailLabel(Object tasks);

  /// No description provided for @noteDetailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteDetailPrefix;

  /// No description provided for @countryDetailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryDetailPrefix;

  /// No description provided for @languageDetailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageDetailPrefix;

  /// No description provided for @timeDetailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeDetailPrefix;

  /// No description provided for @tasksDetailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksDetailPrefix;

  /// No description provided for @trackingFallback.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get trackingFallback;

  /// No description provided for @languageSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectionTitle;

  /// Connection status with type
  ///
  /// In en, this message translates to:
  /// **'Connected ({connectionType})'**
  String connectedStatus(String connectionType);

  /// No description provided for @disconnectedStatus.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get disconnectedStatus;

  /// No description provided for @readyToSync.
  ///
  /// In en, this message translates to:
  /// **'Ready to sync'**
  String get readyToSync;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @lastSyncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Last sync successful'**
  String get lastSyncSuccess;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get syncError;

  /// No description provided for @syncPaused.
  ///
  /// In en, this message translates to:
  /// **'Sync paused'**
  String get syncPaused;

  /// No description provided for @syncStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatusTitle;

  /// No description provided for @connectivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Connectivity'**
  String get connectivityTitle;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @connectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectedLabel;

  /// No description provided for @disconnectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnectedLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get syncTitle;

  /// No description provided for @pendingEntriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending entries'**
  String get pendingEntriesLabel;

  /// No description provided for @failedEntriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed entries'**
  String get failedEntriesLabel;

  /// No description provided for @syncButton.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncButton;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Count of pending items
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCountLabel(int count);

  /// Count of failed items
  ///
  /// In en, this message translates to:
  /// **'{count} failed'**
  String failedCountLabel(int count);

  /// No description provided for @fewSecondsAgo.
  ///
  /// In en, this message translates to:
  /// **'A few seconds ago'**
  String get fewSecondsAgo;

  /// Time in minutes ago
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String minutesAgo(int minutes);

  /// Time in hours ago
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(int hours);

  /// No description provided for @noAccessToken.
  ///
  /// In en, this message translates to:
  /// **'No access token'**
  String get noAccessToken;

  /// HTTP error message
  ///
  /// In en, this message translates to:
  /// **'Error {statusCode}: {message}'**
  String httpError(int statusCode, String message);

  /// No description provided for @emptyFieldValue.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get emptyFieldValue;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'TimeTracker'**
  String get app_name;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_title;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_button;

  /// No description provided for @logout_button.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout_button;

  /// Entries counter in reports
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No entries} one{1 entry} other{{count} entries}}'**
  String report_items_count(int count);

  /// No description provided for @date_format_hint.
  ///
  /// In en, this message translates to:
  /// **'MMM d, y • HH:mm'**
  String get date_format_hint;

  /// No description provided for @reportsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsScreenTitle;

  /// No description provided for @teamCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamCardTitle;

  /// No description provided for @meCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meCardTitle;

  /// No description provided for @teamCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reports last month'**
  String get teamCardSubtitle;

  /// No description provided for @meCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reports last month'**
  String get meCardSubtitle;

  /// No description provided for @teamCardSubtitleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Organization reports (ADMIN view)'**
  String get teamCardSubtitleAdmin;

  /// No description provided for @teamCardSubtitleNonAdmin.
  ///
  /// In en, this message translates to:
  /// **'Same as \'Me\' (limited access)'**
  String get teamCardSubtitleNonAdmin;

  /// No description provided for @meCardSubtitleRole.
  ///
  /// In en, this message translates to:
  /// **'My reports ({role})'**
  String meCardSubtitleRole(Object role);

  /// No description provided for @dailyComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily comparison'**
  String get dailyComparisonTitle;

  /// No description provided for @myEvolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Evolution (Me)'**
  String get myEvolutionTitle;

  /// Generic error label
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(String error);

  /// No description provided for @noReportsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No reports in the period'**
  String get noReportsInPeriod;

  /// Report ID label
  ///
  /// In en, this message translates to:
  /// **'Report {id}…'**
  String reportIdLabel(String id);

  /// Report date and user label
  ///
  /// In en, this message translates to:
  /// **'Date: {date} • User: {userId}…'**
  String reportDateUserLabel(String date, String userId);

  /// Report ID field
  ///
  /// In en, this message translates to:
  /// **'• ID: {id}'**
  String reportIdField(String id);

  /// Report user field
  ///
  /// In en, this message translates to:
  /// **'• User: {userId}'**
  String reportUserField(String userId);

  /// Report start date field
  ///
  /// In en, this message translates to:
  /// **'• Start date: {startDate}'**
  String reportStartDateField(String startDate);

  /// Report organization field
  ///
  /// In en, this message translates to:
  /// **'• Organization: {organizationId}'**
  String reportOrganizationField(String organizationId);

  /// Report project field
  ///
  /// In en, this message translates to:
  /// **'• Project: {projectId}'**
  String reportProjectField(String projectId);

  /// Report notes field
  ///
  /// In en, this message translates to:
  /// **'• Notes: {notes}'**
  String reportNotesField(String notes);

  /// No description provided for @unknownValue.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get unknownValue;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @trackingTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get trackingTileTitle;

  /// No description provided for @trackingTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start and stop'**
  String get trackingTileSubtitle;

  /// No description provided for @reportsTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTileTitle;

  /// No description provided for @reportsTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Times and metrics'**
  String get reportsTileSubtitle;

  /// No description provided for @accountTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTileTitle;

  /// No description provided for @accountTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile and session'**
  String get accountTileSubtitle;

  /// No description provided for @enhancedReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enhanced Reports'**
  String get enhancedReportsTitle;

  /// No description provided for @advancedReportsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Advanced Reports'**
  String get advancedReportsTooltip;

  /// No description provided for @basicReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Reports'**
  String get basicReportsTitle;

  /// No description provided for @regionalReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Regional Reports'**
  String get regionalReportsTitle;

  /// No description provided for @regionalSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Regional Summary'**
  String get regionalSummaryTitle;

  /// No description provided for @regionalComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Regional Comparison'**
  String get regionalComparisonTitle;

  /// No description provided for @countryBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Country Breakdown'**
  String get countryBreakdownTitle;

  /// No description provided for @languageDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language Distribution'**
  String get languageDistributionTitle;

  /// No description provided for @roleBasedAccess.
  ///
  /// In en, this message translates to:
  /// **'Role-based access'**
  String get roleBasedAccess;

  /// No description provided for @accessLevel.
  ///
  /// In en, this message translates to:
  /// **'Access Level'**
  String get accessLevel;

  /// No description provided for @availableReports.
  ///
  /// In en, this message translates to:
  /// **'Available Reports'**
  String get availableReports;

  /// No description provided for @selectRegionForDetails.
  ///
  /// In en, this message translates to:
  /// **'Select a region to view details'**
  String get selectRegionForDetails;

  /// No description provided for @compareRegions.
  ///
  /// In en, this message translates to:
  /// **'Compare Regions'**
  String get compareRegions;

  /// No description provided for @viewCountryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'View Country Breakdown'**
  String get viewCountryBreakdown;

  /// No description provided for @analyzeLanguageDistribution.
  ///
  /// In en, this message translates to:
  /// **'Analyze Language Distribution'**
  String get analyzeLanguageDistribution;

  /// No description provided for @activeFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Filters'**
  String get activeFiltersTitle;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @filterByRegion.
  ///
  /// In en, this message translates to:
  /// **'Filter by region'**
  String get filterByRegion;

  /// No description provided for @filterByDates.
  ///
  /// In en, this message translates to:
  /// **'Filter by dates'**
  String get filterByDates;

  /// No description provided for @allRegions.
  ///
  /// In en, this message translates to:
  /// **'All regions'**
  String get allRegions;

  /// No description provided for @selectRegions.
  ///
  /// In en, this message translates to:
  /// **'Select regions'**
  String get selectRegions;

  /// No description provided for @selectAtLeast2Regions.
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 regions to compare'**
  String get selectAtLeast2Regions;

  /// Count of selected regions
  ///
  /// In en, this message translates to:
  /// **'Selected Regions ({count}/10)'**
  String selectedRegionsCount(int count);

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @totalEntries.
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get totalEntries;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @totalLanguages.
  ///
  /// In en, this message translates to:
  /// **'Total Languages'**
  String get totalLanguages;

  /// No description provided for @totalCountries.
  ///
  /// In en, this message translates to:
  /// **'Total Countries'**
  String get totalCountries;

  /// No description provided for @totalRegions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get totalRegions;

  /// No description provided for @averagePerRegion.
  ///
  /// In en, this message translates to:
  /// **'Average/Region'**
  String get averagePerRegion;

  /// No description provided for @averagePerCountry.
  ///
  /// In en, this message translates to:
  /// **'Average/Country'**
  String get averagePerCountry;

  /// No description provided for @averagePerLanguage.
  ///
  /// In en, this message translates to:
  /// **'Average/Language'**
  String get averagePerLanguage;

  /// No description provided for @topCountries.
  ///
  /// In en, this message translates to:
  /// **'Top Countries'**
  String get topCountries;

  /// No description provided for @languageBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Language Breakdown'**
  String get languageBreakdown;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// No description provided for @comparisonSummary.
  ///
  /// In en, this message translates to:
  /// **'Comparison Summary'**
  String get comparisonSummary;

  /// No description provided for @detailedMetrics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Metrics'**
  String get detailedMetrics;

  /// No description provided for @performanceHighlights.
  ///
  /// In en, this message translates to:
  /// **'Performance Highlights'**
  String get performanceHighlights;

  /// No description provided for @mostUsed.
  ///
  /// In en, this message translates to:
  /// **'Most Used'**
  String get mostUsed;

  /// No description provided for @leastUsed.
  ///
  /// In en, this message translates to:
  /// **'Least Used'**
  String get leastUsed;

  /// No description provided for @mostActive.
  ///
  /// In en, this message translates to:
  /// **'Most Active'**
  String get mostActive;

  /// No description provided for @leastActive.
  ///
  /// In en, this message translates to:
  /// **'Least Active'**
  String get leastActive;

  /// No description provided for @bestPerformance.
  ///
  /// In en, this message translates to:
  /// **'Best Performance'**
  String get bestPerformance;

  /// No description provided for @worstPerformance.
  ///
  /// In en, this message translates to:
  /// **'Worst Performance'**
  String get worstPerformance;

  /// No description provided for @hoursPerUser.
  ///
  /// In en, this message translates to:
  /// **'Hours/User'**
  String get hoursPerUser;

  /// No description provided for @entriesPerUser.
  ///
  /// In en, this message translates to:
  /// **'Entries/User'**
  String get entriesPerUser;

  /// No description provided for @languagesUsed.
  ///
  /// In en, this message translates to:
  /// **'Languages Used'**
  String get languagesUsed;

  /// No description provided for @countriesWithActivity.
  ///
  /// In en, this message translates to:
  /// **'Countries with Activity'**
  String get countriesWithActivity;

  /// No description provided for @languagesWithActivity.
  ///
  /// In en, this message translates to:
  /// **'Languages with Activity'**
  String get languagesWithActivity;

  /// No description provided for @periodInformation.
  ///
  /// In en, this message translates to:
  /// **'Period Information'**
  String get periodInformation;

  /// From date
  ///
  /// In en, this message translates to:
  /// **'From: {date}'**
  String fromDate(String date);

  /// To date
  ///
  /// In en, this message translates to:
  /// **'To: {date}'**
  String toDate(String date);

  /// Region scope
  ///
  /// In en, this message translates to:
  /// **'Region: {region}'**
  String regionScope(String region);

  /// No description provided for @allRegionsScope.
  ///
  /// In en, this message translates to:
  /// **'Scope: All regions'**
  String get allRegionsScope;

  /// Filtered country
  ///
  /// In en, this message translates to:
  /// **'Filtered country: {country}'**
  String filteredCountry(String country);

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @noDataForRegion.
  ///
  /// In en, this message translates to:
  /// **'No data available for this region'**
  String get noDataForRegion;

  /// No description provided for @loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshData;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @exportToPDF.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF'**
  String get exportToPDF;

  /// No description provided for @exportToExcel.
  ///
  /// In en, this message translates to:
  /// **'Export to Excel'**
  String get exportToExcel;

  /// No description provided for @exportToCSV.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV'**
  String get exportToCSV;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @distributionChart.
  ///
  /// In en, this message translates to:
  /// **'Distribution Chart'**
  String get distributionChart;

  /// No description provided for @comparisonChart.
  ///
  /// In en, this message translates to:
  /// **'Comparison Chart'**
  String get comparisonChart;

  /// No description provided for @detailsTable.
  ///
  /// In en, this message translates to:
  /// **'Details Table'**
  String get detailsTable;

  /// No description provided for @statisticsInsights.
  ///
  /// In en, this message translates to:
  /// **'Statistics & Insights'**
  String get statisticsInsights;

  /// No description provided for @regionalDistribution.
  ///
  /// In en, this message translates to:
  /// **'Regional Distribution'**
  String get regionalDistribution;

  /// No description provided for @selectItemsToExport.
  ///
  /// In en, this message translates to:
  /// **'Select items to export'**
  String get selectItemsToExport;

  /// No description provided for @exportOptions.
  ///
  /// In en, this message translates to:
  /// **'Export Options'**
  String get exportOptions;

  /// No description provided for @includeCharts.
  ///
  /// In en, this message translates to:
  /// **'Include charts'**
  String get includeCharts;

  /// No description provided for @includeRawData.
  ///
  /// In en, this message translates to:
  /// **'Include raw data'**
  String get includeRawData;

  /// No description provided for @includeSummary.
  ///
  /// In en, this message translates to:
  /// **'Include summary'**
  String get includeSummary;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report exported successfully'**
  String get exportSuccess;

  /// Export error message
  ///
  /// In en, this message translates to:
  /// **'Error exporting report: {error}'**
  String exportError(String error);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
