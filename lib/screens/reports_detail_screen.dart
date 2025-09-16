// lib/screens/reports_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import '../services/reports_metrics_service.dart';

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
      supportedCountry: 'AR',
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
            return Center(child: Text('Error: ${snap.error}'));
          }
          final list = snap.data ?? const [];
          if (list.isEmpty) {
            return const Center(child: Text('Sin reportes en el período'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final e = list[i];
              final id = (e['id'] ?? '').toString();
              final userId = (e['userId'] ?? '').toString();
              final startedAt = DateTime.tryParse((e['startDate'] ?? e['createdAt'] ?? '').toString());
              final startedStr = startedAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(startedAt) : '—';

              return ListTile(
                title: Text('Reporte ${id.isNotEmpty ? id.substring(0, 6) : '—'}…'),
                subtitle: Text('Fecha: $startedStr • Usuario: ${userId.isNotEmpty ? userId.substring(0, 6) : '—'}…'),
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
    final startedAt = DateTime.tryParse((entry['startDate'] ?? entry['createdAt'] ?? '').toString());
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
              const Text("Detalle del reporte", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text("• ID: ${entry['id'] ?? '—'}"),
              Text("• Usuario: ${entry['userId'] ?? '—'}"),
              Text("• Fecha inicio: $startedStr"),
              if (entry['organizationId'] != null) Text("• Organización: ${entry['organizationId']}"),
              if (entry['projectId'] != null) Text("• Proyecto: ${entry['projectId']}"),
              if (entry['notes'] != null) Text("• Notas: ${entry['notes']}"),
              // Agrega aquí campos reales cuando los tengas en el backend
            ],
          ),
        );
      },
    );
  }
}
