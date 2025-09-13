import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_07_screen.dart';
import '../../widgets/big_action_button.dart';

class StepTaskScreen extends StatefulWidget {
  const StepTaskScreen({super.key});

  @override
  State<StepTaskScreen> createState() => _StepTaskScreenState();
}

class _StepTaskScreenState extends State<StepTaskScreen> {
  final List<String> _availableTasks = [
    'MAST',
    'BTT Support (Writer, Orature, USFM, Recorder)',
    'Training',
    'Technical Support',
    'V-Mast',
    'Transcribe',
    'Quality Assurance Processes',
    'Ihadi software development',
    'AI',
    'Special Assignment.',
    'Revision',
    'Other.',
  ];

  final Set<String> _selectedTasks = {};
  final TextEditingController _descriptionController = TextEditingController();

  void _toggleTask(String task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task);
      } else {
        _selectedTasks.add(task);
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso 6 de 7')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Qué tareas realizaste?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Seleccioná una o más tareas realizadas y escribí un detalle si querés.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _availableTasks.map((task) {
                    final selected = _selectedTasks.contains(task);
                    return CheckboxListTile(
                      title: Text(task),
                      value: selected,
                      onChanged: (_) => _toggleTask(task),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: const Color(0xFFFC6502),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Detalles adicionales...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              BigActionButton(
                text: 'Siguiente',
                onPressed: () {
                  if (_selectedTasks.isNotEmpty) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setTasksAndDescription(
                      _selectedTasks.toList(),
                      _descriptionController.text,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const StepSummaryScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Seleccioná al menos una tarea.')),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
