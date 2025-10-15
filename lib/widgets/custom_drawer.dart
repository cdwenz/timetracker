import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/screens/reports_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'language_picker.dart';

import 'package:ihadi_time_tracker/screens/login_screen.dart';
import 'package:ihadi_time_tracker/screens/home_screen.dart';
import 'package:ihadi_time_tracker/screens/account_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _go(BuildContext context, Widget page) {
    // Cierra el drawer y reemplaza la pantalla actual por la nueva
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Limpia cualquier token/flag de sesión que estés usando
    await prefs.remove('access_token');
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    // Cierra el drawer (si aún está abierto) y navega al Login
    if (context.mounted) {
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- Parte superior del Drawer (lo que ya tengas) ---
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 221, 235, 236),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo en la parte superior
                        const CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/ihadi.png'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context).menuTitle,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  // HOME -> screens/home_screen.dart
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: Text(AppLocalizations.of(context).homeMenuItem),
                    onTap: () => _go(context, const HomeScreen()),
                  ),

                  // ACCOUNT -> screens/account_screen.dart
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(AppLocalizations.of(context).accountMenuItem),
                    onTap: () => _go(context, const AccountScreen()),
                  ),

                  // REPORTS -> screens/report_screen.dart
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(AppLocalizations.of(context).reportsMenuItem),
                    onTap: () => _go(context, const ReportsScreen()),
                  ),

                  const Divider(),

                  // LANGUAGE PICKER
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(
                        AppLocalizations.of(context).languageSelectionTitle),
                    trailing: const LanguagePicker(),
                  ),

                  const Divider(),

                  // LOGOUT
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(AppLocalizations.of(context).logoutMenuItem),
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
            // --- Pie de página con versión ---
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Ihadi Time Tracker v2.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
