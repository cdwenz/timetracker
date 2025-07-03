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
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 6'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Tasks perfomed:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _availableTasks.map((task) {
                  return CheckboxListTile(
                    title: Text(task),
                    value: _selectedTasks.contains(task),
                    onChanged: (_) => _toggleTask(task),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Additional description:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe in more detail what has been done...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            BigActionButton(
              text: 'Next Step',
              onPressed: () {
                if (_selectedTasks.isNotEmpty) {
                  tracking.setTasksAndDescription(
                    _selectedTasks.toList(),
                    _descriptionController.text,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StepSummaryScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
