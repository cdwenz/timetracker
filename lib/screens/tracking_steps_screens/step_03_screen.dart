import 'package:flutter/material.dart';
import 'step_04_screen.dart';
import '../../widgets/big_action_button.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';

class StepThreeScreen extends StatefulWidget {
  final String? previousStepNote;

  const StepThreeScreen({super.key, this.previousStepNote});

  @override
  // ignore: library_private_types_in_public_api
  _StepThreeScreenState createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Working language:",
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
                    .setLanguage(_noteController.text);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StepDateScreen(),
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
