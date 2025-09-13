import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/localization/language_controller.dart';
import 'package:ihadi_time_tracker/screens/reports_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 235, 236),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo en la parte superior
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      AssetImage('assets/ihadi.png'),
                  
                ),
                SizedBox(height: 12),
                Text(
                  'Menú',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // HOME -> screens/home_screen.dart
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => _go(context, const HomeScreen()),
          ),

          // ACCOUNT -> screens/account_screen.dart
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Account'),
            onTap: () => _go(context, const AccountScreen()),
          ),

          // REPORTS -> screens/report_screen.dart
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Reports'),
            onTap: () => _go(context, const ReportsScreen()),
          ),

          const Divider(),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () => _logout(context),
          ),

         
        ],
      ),
    );
  }
}