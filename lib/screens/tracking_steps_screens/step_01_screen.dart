import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'step_02_screen.dart';
import '../../widgets/big_action_button.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  void _loadSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('name');
    if (savedName != null && mounted) {
      Provider.of<TrackingData>(context, listen: false)
          .setPersonName(savedName);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Paso 1 de 7'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Qué hiciste hoy?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Escribí una breve descripción de la actividad que realizaste.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _noteController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Ej: Ayudé a un traductor piaroa a...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Spacer(),
              BigActionButton(
                text: 'Siguiente',
                onPressed: () {
                  if (_noteController.text.isNotEmpty) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setNote(_noteController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StepTwoScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Por favor completá la nota.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
