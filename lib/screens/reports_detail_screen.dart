// lib/screens/reports_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import '../services/reports_metrics_service.dart';
import '../l10n/app_localizations.dart';

/// Args para navegación con rutas nombradas
class ReportsDetailArgs {
  final String title;
  final ReportsDetailFilter filter;
  const ReportsDetailArgs({required this.title, required this.filter});
}

class ReportsDetailScreen extends StatelessWidget {
  final ReportsDetailArgs args;
  const ReportsDetailScreen({super.key, required this.args});

  Future<List<Map<String, dynamic>>> _load() async {
    final svc = ReportsMetricsService(ApiService());
    return svc.loadDetailLast30Days(
      filter: args.filter,
      supportedCountry: null, // No filtrar por país por defecto
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(args.title)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context).errorLabel(snap.error.toString()),
              ),
            );
          }
          final list = snap.data ?? const [];
          if (list.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context).noReportsInPeriod),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (ctx, i) {
              final e = list[i];

              final personName = (e['personName'] ?? '').toString();
              final taskDescription = (e['taskDescription'] ?? '').toString();
              final note = (e['note'] ?? '').toString();

              final startedAt = DateTime.tryParse(
                (e['startDate'] ?? e['createdAt'] ?? e['updatedAt'] ?? '')
                    .toString(),
              );

              final title = personName.isNotEmpty
                  ? personName
                  : taskDescription.isNotEmpty
                  ? taskDescription
                  : note.isNotEmpty
                  ? note
                  : "Registro";

              final initials = title
                  .trim()
                  .split(" ")
                  .where((e) => e.isNotEmpty)
                  .take(2)
                  .map((e) => e[0].toUpperCase())
                  .join();

              final tasks = (e['tasks'] as List<dynamic>? ?? [])
                  .map((x) => x.toString())
                  .toList();

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    showModalBottomSheet(
                      context: ctx,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => _ReportDetailSheet(entry: e),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            const Icon(Icons.chevron_right),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 20,
                          runSpacing: 8,
                          children: [
                            if (startedAt != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormat("dd MMM yyyy").format(startedAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                            if (e['startTimeOfDay'] != null &&
                                e['endTimeOfDay'] != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${e['startTimeOfDay']} - ${e['endTimeOfDay']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),

                        if (tasks.isNotEmpty) ...[
                          const SizedBox(height: 14),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tasks
                                .map(
                                  (task) => Chip(
                                    label: Text(task),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                )
                                .toList(),
                          ),
                        ],

                        if (note.isNotEmpty) ...[
                          const SizedBox(height: 14),

                          Text(
                            note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ReportDetailSheet extends StatelessWidget {
  final Map<String, dynamic> entry;
  const _ReportDetailSheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    final startedAt = DateTime.tryParse(
      (entry['startDate'] ?? entry['createdAt'] ?? entry['updatedAt'] ?? '')
          .toString(),
    );
    final startedStr = startedAt != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(startedAt)
        : '—';

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              Text(
                AppLocalizations.of(context).reportDetailTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Información básica
              if (entry['userName'] != null)
                _detailRow(
                  AppLocalizations.of(context).defaultUserName,
                  entry['userName'].toString(),
                ),
              if (entry['personName'] != null)
                _detailRow(
                  AppLocalizations.of(context).personLabel,
                  entry['personName'].toString(),
                ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

              // Fechas y horarios
              if (startedStr != '—')
                _detailRow(
                  AppLocalizations.of(context).startDateLabel,
                  startedStr,
                ),
              if (entry['endDate'] != null) ...[
                () {
                  final endDate = DateTime.tryParse(
                    entry['endDate'].toString(),
                  );
                  final endStr = endDate != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(endDate)
                      : '—';
                  return endStr != '—'
                      ? _detailRow(
                          AppLocalizations.of(context).endDateLabel,
                          endStr,
                        )
                      : const SizedBox.shrink();
                }(),
              ],
              if (entry['startTimeOfDay'] != null)
                _detailRow(
                  AppLocalizations.of(context).startTimeLabel,
                  entry['startTimeOfDay'].toString(),
                ),
              if (entry['endTimeOfDay'] != null)
                _detailRow(
                  AppLocalizations.of(context).endTimeLabel,
                  entry['endTimeOfDay'].toString(),
                ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

              // Detalles del trabajo
              if (entry['supportedCountry'] != null)
                _detailRow(
                  AppLocalizations.of(context).countryFieldLabel,
                  entry['supportedCountry'].toString(),
                ),
              if (entry['workingLanguage'] != null)
                _detailRow(
                  AppLocalizations.of(context).languageSelectionTitle,
                  entry['workingLanguage'].toString(),
                ),
              if (entry['recipient'] != null)
                _detailRow(
                  AppLocalizations.of(context).recipientLabel,
                  entry['recipient'].toString(),
                ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

              // Tareas y descripción
              if (entry['tasks'] != null && entry['tasks'] is List)
                _detailRow(
                  AppLocalizations.of(context).tasksLabel,
                  (entry['tasks'] as List).join(', '),
                ),
              if (entry['taskDescription'] != null)
                _detailRow(
                  AppLocalizations.of(context).descriptionLabel,
                  entry['taskDescription'].toString(),
                ),
              if (entry['note'] != null)
                _detailRow(
                  AppLocalizations.of(context).noteLabel,
                  entry['note'].toString(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
