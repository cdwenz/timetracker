import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihadi_time_tracker/screens/loginScreen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 221, 235, 236),
            ),
            child: Image.asset(
              'assets/ihadi.png',
              height: 120,
            ),
          ),
          // Opciones del menú escalables
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Implementar navegación a pantalla de inicio
            },
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              // Implementar navegación a pantalla de perfil
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Implementar navegación a pantalla de configuraciones
            },
          ),
          ListTile(
            title: const Text('Logout'),
            // Cambia el icono a uno más apropiado
            leading: const Icon(Icons.logout),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);

              // Cierra el Drawer antes de navegar
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();

              // Reemplaza la pantalla actual por la pantalla de login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
