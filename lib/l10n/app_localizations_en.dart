// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'TimeTracker';

  @override
  String get login_title => 'Sign in';

  @override
  String get login_button => 'Log in';

  @override
  String get logout_button => 'Log out';

  @override
  String home_greeting(String name) {
    return 'Hi $name!';
  }

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
}
