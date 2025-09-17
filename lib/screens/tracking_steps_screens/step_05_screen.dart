import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_06_screen.dart';
import '../../widgets/big_action_button.dart';
import '../../l10n/app_localizations.dart';

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
    final picked = await showTimePicker(
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

  String _formatTime(TimeOfDay? time) {
    if (time == null) return AppLocalizations.of(context).selectDateButton;
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).step5Title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).step5Question,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).step5Description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _pickTime(isStart: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).startTimeLabel),
                    Text(_formatTime(_startTime)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _pickTime(isStart: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).endTimeLabel),
                    Text(_formatTime(_endTime)),
                  ],
                ),
              ),
              const Spacer(),
              BigActionButton(
                text: AppLocalizations.of(context).nextButton,
                onPressed: () {
                  if (_startTime != null && _endTime != null) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setStartEndTimesOfDay(_startTime!, _endTime!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StepTaskScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context).step5Validation)),
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
