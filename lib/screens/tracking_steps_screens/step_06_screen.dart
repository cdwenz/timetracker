import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_07_screen.dart';
import '../../widgets/big_action_button.dart';
import '../../l10n/app_localizations.dart';

class StepTaskScreen extends StatefulWidget {
  const StepTaskScreen({super.key});

  @override
  State<StepTaskScreen> createState() => _StepTaskScreenState();
}

class _StepTaskScreenState extends State<StepTaskScreen> {
  List<String> get _availableTasks => [
    AppLocalizations.of(context).taskMAST,
    AppLocalizations.of(context).taskBTTSupport,
    AppLocalizations.of(context).taskTraining,
    AppLocalizations.of(context).taskTechnicalSupport,
    AppLocalizations.of(context).taskVMAST,
    AppLocalizations.of(context).taskTranscribe,
    AppLocalizations.of(context).taskQualityAssurance,
    AppLocalizations.of(context).taskIhadiDevelopment,
    AppLocalizations.of(context).taskAI,
    AppLocalizations.of(context).taskSpecialAssignment,
    AppLocalizations.of(context).taskRevision,
    AppLocalizations.of(context).taskOther,
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
      appBar: AppBar(title: Text(AppLocalizations.of(context).step6Title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).step6Question,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).step6Description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
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
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).additionalDetailsPlaceholder,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              BigActionButton(
                text: AppLocalizations.of(context).nextButton,
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
                      SnackBar(
                          content: Text(AppLocalizations.of(context).step6Validation)),
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
