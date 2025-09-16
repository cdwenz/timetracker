// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihadi_time_tracker/widgets/report_detail_modal.dart';
import 'package:ihadi_time_tracker/models/tracking.dart';
import 'package:ihadi_time_tracker/services/reports_service.dart';
import '../l10n/app_localizations.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _searchCtrl = TextEditingController();
  DateTimeRange? _range;
  List<Tracking> _items = [];
  bool _loading = true;
  String _role = 'USER';
  String _fmt(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// Traduce el nombre del rol del sistema
  String _translateRole(String role) {
    return switch (role) {
      'ADMIN' => AppLocalizations.of(context).roleAdmin,
      'FIELD_MANAGER' => AppLocalizations.of(context).roleFieldManager,
      'USER' => AppLocalizations.of(context).roleUser,
      _ => role,
    };
  }

  /// Traduce el ámbito basado en el rol
  String _translateScope(String role) {
    return switch (role) {
      'ADMIN' => AppLocalizations.of(context).scopeAll,
      'FIELD_MANAGER' => AppLocalizations.of(context).scopeMyTeam,
      _ => AppLocalizations.of(context).scopeMyRecords,
    };
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _loadRole();
    await _load();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('user_role') ?? prefs.getString('role') ?? _role;
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await ReportsService.fetchTrackings(
        from: _range?.start,
        to: _range?.end,
        search:
            _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim(),
      );
      _items = list;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).loadReportsError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final last30 = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _range ?? last30,
    );
    if (picked != null) {
      setState(() => _range = picked);
      await _load();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).reportsTitle),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).selectRangeTooltip,
            onPressed: _pickRange,
            icon: const Icon(Icons.date_range),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).reloadTooltip,
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text(AppLocalizations.of(context).roleLabel(_translateRole(_role))),
                        avatar: const Icon(Icons.security, size: 18),
                      ),
                      Chip(
                        label: Text(AppLocalizations.of(context).scopeLabel(_translateScope(_role))),
                        avatar: const Icon(Icons.filter_list, size: 18),
                      ),
                    ],
                  ),
                  if (_range != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.schedule, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${_fmt(_range!.start)} → ${_fmt(_range!.end)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _searchCtrl,
                onSubmitted: (_) => _load(),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchPlaceholder,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchCtrl.clear();
                      _load();
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: _items.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(height: 120),
                                Center(
                                    child:
                                        Text(AppLocalizations.of(context).noTrackingsMessage)),
                              ],
                            )
                          : ListView.separated(
                              itemCount: _items.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 0),
                              itemBuilder: (_, i) {
                                final t = _items[i];
                                final date = (t.startDate ?? '').toString();
                                final day = date.isNotEmpty && date.length >= 10
                                    ? date.substring(0, 10)
                                    : '';
                                final timeRange = [
                                  if (t.startTimeOfDay != null)
                                    t.startTimeOfDay,
                                  if (t.endTimeOfDay != null) t.endTimeOfDay,
                                ].whereType<String>().join(' - ');

                                final title = t.personName?.isNotEmpty == true
                                    ? t.personName!
                                    : (t.recipient?.isNotEmpty == true
                                        ? t.recipient!
                                        : (t.note ?? AppLocalizations.of(context).trackingFallback));

                                final subtitle = [
                                  if (t.note?.isNotEmpty == true)
                                    '${AppLocalizations.of(context).noteDetailPrefix}: ${t.note}',
                                  if (t.supportedCountry?.isNotEmpty == true)
                                    '${AppLocalizations.of(context).countryDetailPrefix}: ${t.supportedCountry}',
                                  if (t.workingLanguage?.isNotEmpty == true)
                                    '${AppLocalizations.of(context).languageDetailPrefix}: ${t.workingLanguage}',
                                  if (timeRange.isNotEmpty)
                                    '${AppLocalizations.of(context).timeDetailPrefix}: $timeRange',
                                  if (t.tasks.isNotEmpty)
                                    '${AppLocalizations.of(context).tasksDetailPrefix}: ${t.tasks.join(", ")}',
                                ].join(' • ');


                                return ListTile(
                                  leading:
                                      const Icon(Icons.assignment_outlined),
                                  title: Text(title),
                                  subtitle: Text(subtitle),
                                  trailing: Text(day),
                                  onTap: () => showReportDetailForTracking(context, t),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

