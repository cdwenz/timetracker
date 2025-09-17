import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/models/tracking.dart';
import '../l10n/app_localizations.dart';

/// Llamalo así desde tu ListTile:
/// onTap: () => showReportDetailForTracking(context, t)
Future<void> showReportDetailForTracking(BuildContext context, Tracking t) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => ReportDetailSheetTracking(t: t),
  );
}

class ReportDetailSheetTracking extends StatelessWidget {
  final Tracking t;
  const ReportDetailSheetTracking({super.key, required this.t});

  String _orDash(String? v) => (v == null || v.trim().isEmpty) ? '-' : v.trim();

  String _fmtDate(dynamic d) {
    if (d == null) return '-';
    if (d is DateTime) return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    // si viene como String ISO
    return d.toString();
  }

  String _fmtTime(dynamic t) {
    if (t == null) return '-';
    return t.toString(); // si guardás "HH:mm" como string ya queda bien
  }

  @override
  Widget build(BuildContext context) {
    final personName       = _orDash(t.personName);
    final recipient        = _orDash(t.recipient);
    final supportedCountry = _orDash(t.supportedCountry);
    final workingLanguage  = _orDash(t.workingLanguage);
    final note             = _orDash(t.note);
    final taskDescription  = _orDash(t.taskDescription);

    // tasks puede ser List<String> o String (según tu modelo/DTO)
    final tasksStr = (t.tasks is List<String> && (t.tasks as List<String>).isNotEmpty)
        ? (t.tasks as List<String>).join(', ')
        : _orDash(t.tasks?.toString());

    final startDate        = _fmtDate(t.startDate);
    final endDate          = _fmtDate(t.endDate);
    final startTime        = _fmtTime(t.startTimeOfDay);
    final endTime          = _fmtTime(t.endTimeOfDay);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollCtrl) {
        return SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.receipt_long),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      personName != '-' ? personName : AppLocalizations.of(context).reportDetailTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    tooltip: AppLocalizations.of(context).closeTooltip,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),

              _Section(
                title: AppLocalizations.of(context).mainDataSection,
                children: [
                  _KV(AppLocalizations.of(context).personLabel, personName),
                  _KV(AppLocalizations.of(context).recipientLabel, recipient),
                  _KV(AppLocalizations.of(context).supportCountryLabel, supportedCountry),
                  _KV(AppLocalizations.of(context).workingLanguageModalLabel, workingLanguage),
                ],
              ),

              _Section(
                title: AppLocalizations.of(context).datesAndTimesSection,
                children: [
                  _KV(AppLocalizations.of(context).startLabel, startDate),
                  _KV(AppLocalizations.of(context).endLabel, endDate),
                  _KV(AppLocalizations.of(context).startTimeModalLabel, startTime),
                  _KV(AppLocalizations.of(context).endTimeModalLabel, endTime),
                ],
              ),

              _Section(
                title: AppLocalizations.of(context).tasksSection,
                children: [
                  _KV(AppLocalizations.of(context).listLabel, tasksStr),
                  _KV(AppLocalizations.of(context).descriptionModalLabel, taskDescription),
                ],
              ),

              if (note != '-')
                _Section(
                  title: AppLocalizations.of(context).noteSection,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: Text(
                        note,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

// Helpers visuales
class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...children,
          const SizedBox(height: 4),
          const Divider(),
        ],
      ),
    );
  }
}

class _KV extends StatelessWidget {
  final String label;
  final String value;
  const _KV(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final v = (value.isEmpty) ? '-' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              v,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
