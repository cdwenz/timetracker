import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_06_screen.dart'; 
import '../../widgets/big_action_button.dart';

class StepTimeScreen extends StatefulWidget {
  const StepTimeScreen({super.key});

  @override
  State<StepTimeScreen> createState() => _StepTimeScreenState();
}

class _StepTimeScreenState extends State<StepTimeScreen> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _pickTime({required bool isStart}) async {
    final now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 5'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Start Hour:'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _pickTime(isStart: true),
              child: Text(
                _startTime != null
                    ? formatTime(_startTime!)
                    : 'Select start hour',
              ),
            ),
            const SizedBox(height: 20),
            const Text('End hour:'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _pickTime(isStart: false),
              child: Text(
                _endTime != null ? formatTime(_endTime!) : 'Select end hour',
              ),
            ),
            const SizedBox(height: 24),
            BigActionButton(
              text: 'Next Step',
              onPressed: () {
                if (_startTime != null && _endTime != null) {
                  tracking.setStartEndTimesOfDay(_startTime!, _endTime!);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StepTaskScreen(),
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
