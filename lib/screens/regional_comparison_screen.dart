// lib/screens/regional_comparison_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/reports_metrics_service.dart';
import '../services/api_service.dart';
import '../services/export_service.dart';
import '../models/regional_reports_models.dart';
import '../l10n/app_localizations.dart';

class RegionalComparisonScreen extends StatefulWidget {
  final List<RegionInfo> availableRegions;

  const RegionalComparisonScreen({
    super.key,
    required this.availableRegions,
  });

  @override
  State<RegionalComparisonScreen> createState() => _RegionalComparisonScreenState();
}

class _RegionalComparisonScreenState extends State<RegionalComparisonScreen> {
  final ReportsMetricsService _service = ReportsMetricsService(ApiService());
  
  RegionalComparison? _comparison;
  bool _isLoading = false;
  
  // Regiones seleccionadas para comparar
  List<String> _selectedRegionIds = [];
  
  // Filtros
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedCountries = [];
  List<String> _selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    // Pre-seleccionar las primeras 2 regiones si hay disponibles
    if (widget.availableRegions.length >= 2) {
      _selectedRegionIds = [
        widget.availableRegions[0].id,
        widget.availableRegions[1].id,
      ];
      _loadComparison();
    }
  }

  Future<void> _loadComparison() async {
    if (_selectedRegionIds.length < 2) {
      setState(() => _comparison = null);
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      _comparison = await _service.compareRegions(
        _selectedRegionIds,
        startDate: _startDate,
        endDate: _endDate,
        countries: _selectedCountries.isNotEmpty ? _selectedCountries : null,
        languages: _selectedLanguages.isNotEmpty ? _selectedLanguages : null,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorComparingRegions(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    setState(() => _isLoading = false);
  }

  void _showRegionSelector() async {
    final List<String>? selected = await showDialog<List<String>>(
      context: context,
      builder: (context) => _RegionSelectorDialog(
        availableRegions: widget.availableRegions,
        selectedRegionIds: _selectedRegionIds,
      ),
    );
    
    if (selected != null && selected.length >= 2) {
      setState(() => _selectedRegionIds = selected);
      _loadComparison();
    }
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadComparison();
    }
  }

  void _showExportOptions() async {
    if (_comparison == null) return;

    final ExportFormat? format = await showDialog<ExportFormat>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).exportOptions),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(AppLocalizations.of(context).exportToCSV),
              onTap: () => Navigator.of(context).pop(ExportFormat.csv),
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: Text(AppLocalizations.of(context).exportToExcel),
              onTap: () => Navigator.of(context).pop(ExportFormat.excel),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(AppLocalizations.of(context).exportToPDF),
              onTap: () => Navigator.of(context).pop(ExportFormat.pdf),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ],
      ),
    );

    if (format != null) {
      _exportReport(format);
    }
  }

  void _exportReport(ExportFormat format) async {
    if (_comparison == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loadingData),
          duration: const Duration(seconds: 2),
        ),
      );

      final filePath = await ExportService.exportRegionalComparison(
        _comparison!,
        format,
        AppLocalizations.of(context),
        includeCharts: true,
        includeRawData: true,
        includeSummary: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).exportSuccess),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: AppLocalizations.of(context).shareReport,
              onPressed: () => ExportService.shareReport(
                filePath,
                subject: AppLocalizations.of(context).regionalComparisonReportSubject,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).exportError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).regionalComparison),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showRegionSelector,
            tooltip: AppLocalizations.of(context).selectRegions,
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangePicker,
            tooltip: AppLocalizations.of(context).filterByDates,
          ),
          if (_comparison != null)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _showExportOptions,
              tooltip: AppLocalizations.of(context).exportReport,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadComparison,
            tooltip: AppLocalizations.of(context).refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Panel de regiones seleccionadas
          _buildSelectedRegionsPanel(),
          
          // Contenido principal
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comparison == null
                    ? _buildEmptyState()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Resumen de comparación
                            _buildComparisonSummary(),
                            
                            const SizedBox(height: 20),
                            
                            // Gráfico de comparación principal
                            _buildMainComparisonChart(),
                            
                            const SizedBox(height: 20),
                            
                            // Métricas de comparación detalladas
                            _buildDetailedMetrics(),
                            
                            const SizedBox(height: 20),
                            
                            // Mejores y peores performers
                            _buildPerformanceHighlights(),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedRegionsPanel() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).selectedRegions(_selectedRegionIds.length),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          
          if (_selectedRegionIds.isEmpty)
            Text(AppLocalizations.of(context).selectAtLeast2RegionsToCompare)
          else
            Wrap(
              spacing: 8,
              children: _selectedRegionIds.map((regionId) {
                final region = widget.availableRegions.firstWhere((r) => r.id == regionId);
                return Chip(
                  label: Text(region.name),
                  backgroundColor: Colors.blue.shade100,
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => _selectedRegionIds.remove(regionId));
                    if (_selectedRegionIds.length >= 2) {
                      _loadComparison();
                    } else {
                      setState(() => _comparison = null);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.compare_arrows,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).selectAtLeast2RegionsToCompare,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showRegionSelector,
              child: Text(AppLocalizations.of(context).selectRegions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).comparisonSummary,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    AppLocalizations.of(context).regions,
                    _comparison!.summary.totalRegions.toString(),
                    Icons.location_on,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    AppLocalizations.of(context).totalHours,
                    _comparison!.summary.totalHours.toStringAsFixed(1),
                    Icons.access_time,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    AppLocalizations.of(context).averagePerRegion,
                    _comparison!.summary.averageHoursPerRegion.toStringAsFixed(1),
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainComparisonChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).totalHoursComparison,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _comparison!.regions.map((r) => r.totalHours).reduce((a, b) => a > b ? a : b) * 1.1,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _comparison!.regions.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _comparison!.regions[index].regionName,
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(_comparison!.regions.length, (index) {
                    final region = _comparison!.regions[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: region.totalHours,
                          color: _getColorForIndex(index),
                          width: 30,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).detailedMetrics,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context).region)),
                  DataColumn(label: Text(AppLocalizations.of(context).hours), numeric: true),
                  DataColumn(label: Text(AppLocalizations.of(context).entries), numeric: true),
                  DataColumn(label: Text(AppLocalizations.of(context).users), numeric: true),
                  DataColumn(label: Text(AppLocalizations.of(context).hrsPerUser), numeric: true),
                  DataColumn(label: Text(AppLocalizations.of(context).topCountry)),
                  DataColumn(label: Text(AppLocalizations.of(context).topLanguage)),
                ],
                rows: _comparison!.regions.map((region) => 
                  DataRow(cells: [
                    DataCell(Text(region.regionName)),
                    DataCell(Text(region.totalHours.toStringAsFixed(1))),
                    DataCell(Text(region.totalEntries.toString())),
                    DataCell(Text(region.activeUsers.toString())),
                    DataCell(Text(region.avgHoursPerUser.toStringAsFixed(1))),
                    DataCell(Text(region.topCountry)),
                    DataCell(Text(region.topLanguage)),
                  ])
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceHighlights() {
    if (_comparison!.comparisonMetrics.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).performanceHighlights,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        ..._comparison!.comparisonMetrics.map((metric) => 
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.metricName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildPerformanceCard(
                          AppLocalizations.of(context).bestPerformance,
                          metric.bestPerformer.regionName,
                          metric.bestPerformer.value.toStringAsFixed(1),
                          Colors.green,
                          Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPerformanceCard(
                          AppLocalizations.of(context).worstPerformance,
                          metric.worstPerformer.regionName,
                          metric.worstPerformer.value.toStringAsFixed(1),
                          Colors.orange,
                          Icons.trending_down,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String regionName,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            regionName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}

class _RegionSelectorDialog extends StatefulWidget {
  final List<RegionInfo> availableRegions;
  final List<String> selectedRegionIds;

  const _RegionSelectorDialog({
    required this.availableRegions,
    required this.selectedRegionIds,
  });

  @override
  State<_RegionSelectorDialog> createState() => _RegionSelectorDialogState();
}

class _RegionSelectorDialogState extends State<_RegionSelectorDialog> {
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedRegionIds);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).selectRegions),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).selectBetween2And10Regions(_selectedIds.length)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availableRegions.length,
                itemBuilder: (context, index) {
                  final region = widget.availableRegions[index];
                  final isSelected = _selectedIds.contains(region.id);
                  
                  return CheckboxListTile(
                    title: Text(region.name),
                    subtitle: Text('ID: ${region.id.substring(0, 8)}...'),
                    value: isSelected,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          if (_selectedIds.length < 10) {
                            _selectedIds.add(region.id);
                          }
                        } else {
                          _selectedIds.remove(region.id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _selectedIds.length >= 2
              ? () => Navigator.of(context).pop(_selectedIds)
              : null,
          child: Text(AppLocalizations.of(context).compare),
        ),
      ],
    );
  }
}