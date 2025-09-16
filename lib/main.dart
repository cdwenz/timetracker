import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/providers/user_providers.dart';
import 'package:ihadi_time_tracker/screens/home_screen.dart';
import 'package:ihadi_time_tracker/screens/reports_detail_screen.dart';
import 'package:ihadi_time_tracker/screens/reports_screen.dart';
import 'package:ihadi_time_tracker/screens/account_screen.dart';
import 'package:ihadi_time_tracker/screens/login_screen.dart';
import 'package:ihadi_time_tracker/screens/register_screen.dart';
import 'package:ihadi_time_tracker/screens/tracking_steps_screens/step_01_screen.dart';
import 'package:provider/provider.dart';
import 'package:ihadi_time_tracker/screens/splash_screen.dart';
import 'models/tracking_data.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'localization/language_controller.dart';

// Servicios offline
import 'services/connectivity_service.dart';
import 'services/sync_service.dart';
import 'services/local_database.dart';

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
  
  // Inicializar servicios
  final lang = LanguageController();
  await lang.load();
  
  // Inicializar servicios offline
  final connectivityService = ConnectivityService();
  final syncService = SyncService();
  
  await connectivityService.initialize();
  await syncService.initialize();
  
  // Verificar base de datos
  await LocalDatabase.database;
  
  print('🚀 Servicios offline inicializados correctamente');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackingData()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider<LanguageController>.value(value: lang),
        
        // Servicios offline
        ChangeNotifierProvider<ConnectivityService>.value(value: connectivityService),
        ChangeNotifierProvider<SyncService>.value(value: syncService),
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
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      title: 'Tracking App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
            
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
            
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
            
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
            
          case '/account':
            return MaterialPageRoute(builder: (_) => const AccountScreen());
            
          case '/tracking':
            return MaterialPageRoute(builder: (_) => const StepOneScreen());

          case '/reports':
            return MaterialPageRoute(builder: (_) => const ReportsScreen());

          case '/reports/detail':
            final args = settings.arguments as ReportsDetailArgs?;
            if (args == null) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text("Error: faltan argumentos")),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => ReportsDetailScreen(args: args),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Ruta no encontrada")),
              ),
            );
        }
      },
    );
  }
}
