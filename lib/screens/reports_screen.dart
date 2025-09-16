// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';

import '../services/api_service.dart';
import '../services/reports_metrics_service.dart';
import 'reports_detail_screen.dart'; // para ReportsDetailArgs

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Future<ReportsDashboardData> _load() async {
    final svc = ReportsMetricsService(ApiService());
    return svc.loadDashboardLast30Days();
  }

  void _goToDetail(
    BuildContext ctx, { 
    required String title,
    required ReportsDetailFilter filter,
  }) {
    Navigator.pushNamed(
      ctx,
      '/reports/detail',
      arguments: ReportsDetailArgs(title: title, filter: filter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(title: const Text("Reports")),
      body: FutureBuilder<ReportsDashboardData>(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final data = snap.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjetas resumen
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: "Equipo",
                        value: "${data.teamCount}",
                        subtitle: "Reportes último mes",
                        color: Colors.deepPurple,
                        onTap: () => _goToDetail(context, title: "Equipo", filter: ReportsDetailFilter.team),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: "Yo",
                        value: "${data.meCount}",
                        subtitle: "Reportes último mes",
                        color: Colors.orange,
                        onTap: () => _goToDetail(context, title: "Yo", filter: ReportsDetailFilter.me),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Gráfico: Comparación diaria (Yo vs Equipo)
                _TappableCard(
                  title: "Comparación diaria",
                  onTap: () => _goToDetail(context, title: "Comparación diaria", filter: ReportsDetailFilter.compare),
                  child: SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        barGroups: List.generate(data.dailyCompare.length, (i) {
                          final dc = data.dailyCompare[i];
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(toY: dc.myCount.toDouble(), color: Colors.orange),
                              BarChartRodData(toY: dc.teamCount.toDouble(), color: Colors.deepPurple),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, _) {
                                final i = value.toInt();
                                if (i < 0 || i >= data.dailyCompare.length) return const SizedBox.shrink();
                                final d = data.dailyCompare[i].day;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('${d.day}', style: const TextStyle(fontSize: 10)),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Gráfico: Evolución (Yo)
                _TappableCard(
                  title: "Evolución (Yo)",
                  onTap: () => _goToDetail(context, title: "Evolución (Yo)", filter: ReportsDetailFilter.trend),
                  child: SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(data.myTrend.length, (i) {
                              final p = data.myTrend[i];
                              return FlSpot(i.toDouble(), p.count.toDouble());
                            }),
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, _) {
                                final i = value.toInt();
                                if (i < 0 || i >= data.myTrend.length) return const SizedBox.shrink();
                                final d = data.myTrend[i].day;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('${d.day}', style: const TextStyle(fontSize: 10)),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---- UI helpers (cards) ----
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: color)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}

class _TappableCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onTap;

  const _TappableCard({required this.title, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey.shade600),
            ]),
            const SizedBox(height: 8),
            child,
          ]),
        ),
      ),
    );
  }
}
