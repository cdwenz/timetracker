import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/providers/user_providers.dart';
import 'package:provider/provider.dart';
import 'package:ihadi_time_tracker/screens/splash_screen.dart';
import 'models/tracking_data.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/language_controller.dart'; // lo creamos abajo

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
    bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFC6502),
    primary: const Color(0xFFFC6502),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.black45),
  ),
  useMaterial3: true,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lang = LanguageController();
  await lang.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackingData()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider<LanguageController>.value(value: lang),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageController>();
    return MaterialApp(
      locale: lang.locale, // null => sigue idioma del sistema
      // supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // onGenerateTitle: (ctx) => AppLocalizations.of(ctx).app_name,
      title: 'Tracking App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}
