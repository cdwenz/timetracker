import 'package:flutter/material.dart';
import 'step_04_screen.dart';
import '../../widgets/big_action_button.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';

class StepThreeScreen extends StatefulWidget {
  final String? previousStepNote;

  const StepThreeScreen({super.key, this.previousStepNote});

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso 3 de 7')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Cuál es tu nombre?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Este nombre se usará para registrar tu participación.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Ej: Juan Pérez',
                ),
              ),
              const Spacer(),
              BigActionButton(
                text: 'Siguiente',
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setPersonName(_nameController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StepDateScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Completá tu nombre.')),
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
