// screens/tracking_steps_screens/step_01_screen.dart
import 'package:flutter/material.dart';
import 'step_02_screen.dart';
import '../../widgets/big_action_button.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StepOneScreenState createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'The person you supported:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Write your answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            BigActionButton(
              text: 'Next Step',
              onPressed: () {
                Provider.of<TrackingData>(context, listen: false)
                    .setPersonName(_noteController.text);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StepTwoScreen(
                      previousStepNote: _noteController.text,
                    ),
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
