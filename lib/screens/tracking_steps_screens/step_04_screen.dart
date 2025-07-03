import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_05_screen.dart';
import '../../widgets/big_action_button.dart';

class StepDateScreen extends StatefulWidget {
  const StepDateScreen({super.key});

  @override
  State<StepDateScreen> createState() => _StepDateScreenState();
}

class _StepDateScreenState extends State<StepDateScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate; // igualarlas si están mal ordenadas
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 4'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Start date:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectDate(isStart: true),
              child: Text(
                _startDate != null
                    ? _startDate!.toLocal().toString().split(' ')[0]
                    : 'Select start date',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'End date:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectDate(isStart: false),
              child: Text(
                _endDate != null
                    ? _endDate!.toLocal().toString().split(' ')[0]
                    : 'Select end date',
              ),
            ),
            const SizedBox(height: 24),
            BigActionButton(
              text: 'Next Step',
              onPressed: () {
                if (_startDate != null && _endDate != null) {
                  tracking.setStartEndDates(_startDate!, _endDate!);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StepTimeScreen(),
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
