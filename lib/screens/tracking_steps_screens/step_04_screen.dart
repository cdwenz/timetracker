import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_05_screen.dart';
import '../../widgets/big_action_button.dart';
import '../../l10n/app_localizations.dart';

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
    final picked = await showDatePicker(
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
            _endDate = _startDate;
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

  String _formatDate(DateTime? date) {
    if (date == null) return AppLocalizations.of(context).selectDateButton;
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).step4Title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).step4Question,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).step4Description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _selectDate(isStart: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).startDateLabel),
                    Text(_formatDate(_startDate)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _selectDate(isStart: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).endDateLabel),
                    Text(_formatDate(_endDate)),
                  ],
                ),
              ),
              const Spacer(),
              BigActionButton(
                text: AppLocalizations.of(context).nextButton,
                onPressed: () {
                  if (_startDate != null && _endDate != null) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setStartEndDates(_startDate!, _endDate!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StepTimeScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context).step4Validation)),
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
