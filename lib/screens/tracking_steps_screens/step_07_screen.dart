import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import '../../services/time_tracker_service.dart';
import '../../widgets/big_action_button.dart';
import '../../l10n/app_localizations.dart';
import '../home_screen.dart';

class StepSummaryScreen extends StatefulWidget {
  const StepSummaryScreen({super.key});

  @override
  State<StepSummaryScreen> createState() => _StepSummaryScreenState();
}

class _StepSummaryScreenState extends State<StepSummaryScreen> {
  bool _isLoading = false;

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '-';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _submit() async {
    final tracking = Provider.of<TrackingData>(context, listen: false);

    setState(() => _isLoading = true);

    final success = await TimeTrackerService.submitTimeTracker(
      supportedPerson: tracking.recipient ?? '',
      supportedCountry: tracking.supportedCountry ?? '',
      workingLanguage: tracking.workingLanguage ?? '',
      startDate: tracking.startDate?.toIso8601String().split('T').first ?? '',
      endDate: tracking.endDate?.toIso8601String().split('T').first ?? '',
      recipient: tracking.recipient ?? '',
      note: tracking.note ?? '',
      startTimeOfDay: tracking.startTimeOfDay?.format(context) ?? '',
      endTimeOfDay: tracking.endTimeOfDay?.format(context) ?? '',
      tasks: tracking.tasks,
      taskDescription: tracking.taskDescription ?? '',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? AppLocalizations.of(context).successMessage
            : AppLocalizations.of(context).errorMessage),
      ),
    );

    if (success) {
      // Limpiar datos y redirigir al panel principal
      tracking.clear();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingData>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).step7Title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).step7Question,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _summaryItem(AppLocalizations.of(context).noteLabel, tracking.note),
              _summaryItem(AppLocalizations.of(context).recipientLabel, tracking.recipient),
              _summaryItem(AppLocalizations.of(context).nameLabel, tracking.personName),
              _summaryItem(
                AppLocalizations.of(context).dateLabel,
                '${formatDate(tracking.startDate)} - ${formatDate(tracking.endDate)}',
              ),
              _summaryItem(
                AppLocalizations.of(context).timeLabel,
                '${formatTime(tracking.startTimeOfDay)} - ${formatTime(tracking.endTimeOfDay)}',
              ),
              _summaryItem(AppLocalizations.of(context).tasksLabel, tracking.tasks.join(', ')),
              _summaryItem(AppLocalizations.of(context).descriptionLabel, tracking.taskDescription),
              const Spacer(),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : BigActionButton(
                      text: AppLocalizations.of(context).finishButton,
                      onPressed: _submit,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value?.isNotEmpty == true ? value! : '-', softWrap: true),
          ),
        ],
      ),
    );
  }
}
