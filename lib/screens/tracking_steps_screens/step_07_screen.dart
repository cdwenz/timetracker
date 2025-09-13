import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import '../../services/time_tracker_service.dart';
import '../../widgets/big_action_button.dart';

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
            ? 'Registro enviado correctamente.'
            : 'Error al enviar el registro.'),
      ),
    );

    if (success) {
      // TODO: limpiar datos si querés o redirigir
      Navigator.of(context).popUntil((route) => route.isFirst);
      tracking.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingData>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Paso 7 de 7')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen de tu actividad',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _summaryItem('Nota', tracking.note),
              _summaryItem('Destinatario', tracking.recipient),
              _summaryItem('Nombre', tracking.personName),
              _summaryItem(
                'Fecha',
                '${formatDate(tracking.startDate)} - ${formatDate(tracking.endDate)}',
              ),
              _summaryItem(
                'Horario',
                '${formatTime(tracking.startTimeOfDay)} - ${formatTime(tracking.endTimeOfDay)}',
              ),
              _summaryItem('Tareas', tracking.tasks.join(', ')),
              _summaryItem('Descripción', tracking.taskDescription),
              const Spacer(),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : BigActionButton(
                      text: 'Finalizar',
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
