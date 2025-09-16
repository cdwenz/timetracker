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
      supportedCountry: null,  // No filtrar por país por defecto
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
            return Center(child: Text(AppLocalizations.of(context).errorLabel(snap.error.toString())));
          }
          final list = snap.data ?? const [];
          if (list.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).noReportsInPeriod));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final e = list[i];
              
              // Obtener información legible para mostrar
              final personName = (e['personName'] ?? '').toString();
              final taskDescription = (e['taskDescription'] ?? '').toString();
              final note = (e['note'] ?? '').toString();
              final startedAt = DateTime.tryParse((e['startDate'] ?? e['createdAt'] ?? e['updatedAt'] ?? '').toString());
              final startedStr = startedAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(startedAt) : '—';
              
              // Título: Mostrar persona o descripción como identificador principal
              final title = personName.isNotEmpty 
                  ? personName
                  : (taskDescription.isNotEmpty 
                      ? taskDescription 
                      : (note.isNotEmpty ? note : 'Registro'));
              
              // Subtítulo: Mostrar fecha y contexto adicional
              final subtitle = startedStr != '—' ? 'Fecha: $startedStr' : 'Sin fecha';

              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showModalBottomSheet(
                    context: ctx,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => _ReportDetailSheet(entry: e),
                  );
                },
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
    final startedAt = DateTime.tryParse((entry['startDate'] ?? entry['createdAt'] ?? entry['updatedAt'] ?? '').toString());
    final startedStr = startedAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(startedAt) : '—';

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
              Text(AppLocalizations.of(context).reportDetailTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              // Información básica
              if (entry['id'] != null) 
                _detailRow('ID', entry['id'].toString()),
              if (entry['userId'] != null) 
                _detailRow('Usuario', entry['userId'].toString()),
              if (entry['personName'] != null) 
                _detailRow('Persona', entry['personName'].toString()),
              
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              
              // Fechas y horarios
              if (startedStr != '—')
                _detailRow('Fecha inicio', startedStr),
              if (entry['endDate'] != null) ...[
                () {
                  final endDate = DateTime.tryParse(entry['endDate'].toString());
                  final endStr = endDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(endDate) : '—';
                  return endStr != '—' ? _detailRow('Fecha fin', endStr) : const SizedBox.shrink();
                }(),
              ],
              if (entry['startTimeOfDay'] != null) 
                _detailRow('Hora inicio', entry['startTimeOfDay'].toString()),
              if (entry['endTimeOfDay'] != null) 
                _detailRow('Hora fin', entry['endTimeOfDay'].toString()),
              
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              
              // Detalles del trabajo
              if (entry['supportedCountry'] != null) 
                _detailRow('País', entry['supportedCountry'].toString()),
              if (entry['workingLanguage'] != null) 
                _detailRow('Idioma', entry['workingLanguage'].toString()),
              if (entry['recipient'] != null) 
                _detailRow('Destinatario', entry['recipient'].toString()),
              
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              
              // Tareas y descripción
              if (entry['tasks'] != null && entry['tasks'] is List) 
                _detailRow('Tareas', (entry['tasks'] as List).join(', ')),
              if (entry['taskDescription'] != null) 
                _detailRow('Descripción', entry['taskDescription'].toString()),
              if (entry['note'] != null) 
                _detailRow('Nota', entry['note'].toString()),
              
              const SizedBox(height: 16),
              
              // Debug: mostrar todos los campos disponibles
              ExpansionTile(
                title: const Text('Datos técnicos (debug)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.toString(),
                      style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
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
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
