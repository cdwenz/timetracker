import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/big_action_button.dart';
import '../widgets/offline_status_widget.dart';
import './tracking_steps_screens/step_01_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;
  String? _role;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('name') ?? 'Usuario';
      _role = prefs.getString('role') ?? 'Invitado';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking App'),
        actions: [
          const OfflineStatusWidget(compact: true),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Estado de sincronización offline
            const OfflineStatusWidget(),
            const SizedBox(height: 20),
            
            // Contenido principal
            Text(
              "Hi, ${_username ?? ''}!",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            BigActionButton(
              text: 'Start Tracking',
              icon: Icons.fast_forward_sharp,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StepOneScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
