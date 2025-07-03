import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import '../../widgets/big_action_button.dart';

class StepSummaryScreen extends StatelessWidget {
  const StepSummaryScreen({super.key});

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '-';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final tracking = Provider.of<TrackingData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('👤 Person assisted:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tracking.personName ?? '-'),
            const SizedBox(height: 10),

            const Text('🌍 Country of person:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tracking.country ?? '-'),
            const SizedBox(height: 10),

            const Text('Language:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tracking.language ?? '-'),
            const SizedBox(height: 10),

            const Text('📅 Dates:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${formatDate(tracking.startDate)} - ${formatDate(tracking.endDate)}'),
            const SizedBox(height: 10),

            const Text('🕒 Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${formatTime(tracking.startTimeOfDay)} - ${formatTime(tracking.endTimeOfDay)}'),
            const SizedBox(height: 10),

            const Text('🛠️ Tasks perfomed:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tracking.tasks.isNotEmpty ? tracking.tasks.join(', ') : '-'),
            const SizedBox(height: 10),

            const Text('📝 Additional Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tracking.taskDescription.isNotEmpty ? tracking.taskDescription : '-'),
            const SizedBox(height: 30),

            BigActionButton(
              text: 'Confirm and Save',
              onPressed: () {
                // Aquí podés guardar en localStorage, base de datos o sincronizar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Data saved correctly!')),
                );
                Navigator.of(context).popUntil((route) => route.isFirst); // Volver al inicio, por ejemplo
              },
            ),
          ],
        ),
      ),
    );
  }
}
