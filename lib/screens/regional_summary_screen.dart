// lib/screens/regional_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/reports_metrics_service.dart';
import '../services/api_service.dart';
import '../services/export_service.dart';
import '../models/regional_reports_models.dart';
import '../l10n/app_localizations.dart';

class RegionalSummaryScreen extends StatefulWidget {
  final String regionId;
  final String regionName;

  const RegionalSummaryScreen({
    super.key,
    required this.regionId,
    required this.regionName,
  });

  @override
  State<RegionalSummaryScreen> createState() => _RegionalSummaryScreenState();
}

class _RegionalSummaryScreenState extends State<RegionalSummaryScreen> {
  final ReportsMetricsService _service = ReportsMetricsService(ApiService());
  
  RegionalSummary? _summary;
  bool _isLoading = true;
  
  // Filtros
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedCountries = [];
  List<String> _selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      _summary = await _service.getRegionalSummary(
        widget.regionId,
        startDate: _startDate,
        endDate: _endDate,
        countries: _selectedCountries.isNotEmpty ? _selectedCountries : null,
        languages: _selectedLanguages.isNotEmpty ? _selectedLanguages : null,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cargando resumen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    setState(() => _isLoading = false);
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
      _loadData();
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCountries.clear();
      _selectedLanguages.clear();
    });
    _loadData();
  }

  void _showExportOptions() async {
    if (_summary == null) return;

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
    if (_summary == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loadingData),
          duration: const Duration(seconds: 2),
        ),
      );

      final filePath = await ExportService.exportRegionalSummary(
        _summary!,
        format,
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
                subject: 'Regional Summary - ${widget.regionName}',
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
        title: Text('Resumen: ${widget.regionName}'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangePicker,
            tooltip: AppLocalizations.of(context).filterByDates,
          ),
          if (_startDate != null || _selectedCountries.isNotEmpty || _selectedLanguages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilters,
              tooltip: AppLocalizations.of(context).clearFilters,
            ),
          if (_summary != null)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _showExportOptions,
              tooltip: AppLocalizations.of(context).exportReport,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: AppLocalizations.of(context).refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summary == null
              ? const Center(
                  child: Text(
                    'No hay datos disponibles para esta región',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filtros activos
                      if (_startDate != null || _selectedCountries.isNotEmpty || _selectedLanguages.isNotEmpty)
                        _buildActiveFiltersCard(),
                      
                      // Métricas principales
                      _buildMainMetricsSection(),
                      
                      const SizedBox(height: 20),
                      
                      // KPIs de rendimiento
                      _buildPerformanceKPIsSection(),
                      
                      const SizedBox(height: 20),
                      
                      // Países principales
                      _buildTopCountriesSection(),
                      
                      const SizedBox(height: 20),
                      
                      // Distribución de idiomas
                      _buildLanguageDistributionSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActiveFiltersCard() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros Activos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_startDate != null && _endDate != null)
              Text('📅 ${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'),
            if (_selectedCountries.isNotEmpty)
              Text('🌍 Países: ${_selectedCountries.join(", ")}'),
            if (_selectedLanguages.isNotEmpty)
              Text('🗣️ Idiomas: ${_selectedLanguages.join(", ")}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMetricsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Métricas Principales',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Horas',
                    _summary!.totalHours.toStringAsFixed(1),
                    Icons.access_time,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Entradas',
                    _summary!.totalEntries.toString(),
                    Icons.list_alt,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Usuarios Activos',
                    _summary!.activeUsers.toString(),
                    Icons.people,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Período: ${_formatDate(_summary!.dateRange.startDate)} - ${_formatDate(_summary!.dateRange.endDate)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceKPIsSection() {
    if (_summary!.performanceMetrics.isEmpty) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indicadores de Rendimiento',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            ..._summary!.performanceMetrics.map((kpi) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        kpi.metric,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      '${kpi.value.toStringAsFixed(1)} ${kpi.unit}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCountriesSection() {
    if (_summary!.topCountries.isEmpty) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Países Principales',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Gráfico de pastel para países
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _summary!.topCountries.map((country) => 
                    PieChartSectionData(
                      value: country.percentage,
                      title: '${country.percentage.toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      color: _getColorForIndex(_summary!.topCountries.indexOf(country)),
                    )
                  ).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de países
            ..._summary!.topCountries.map((country) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getColorForIndex(_summary!.topCountries.indexOf(country)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(country.country),
                    ),
                    Text(
                      '${country.totalHours.toStringAsFixed(1)}h (${country.percentage.toStringAsFixed(1)}%)',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDistributionSection() {
    if (_summary!.languageBreakdown.isEmpty) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución de Idiomas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Gráfico de barras horizontales para idiomas
            SizedBox(
              height: _summary!.languageBreakdown.length * 40.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _summary!.languageBreakdown.map((l) => l.percentage).reduce((a, b) => a > b ? a : b),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _summary!.languageBreakdown.length) {
                            return Text(
                              _summary!.languageBreakdown[index].language,
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(_summary!.languageBreakdown.length, (index) {
                    final language = _summary!.languageBreakdown[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: language.percentage,
                          color: _getColorForIndex(index),
                          width: 20,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Detalles de idiomas
            ..._summary!.languageBreakdown.map((language) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.language),
                    Text(
                      '${language.totalHours.toStringAsFixed(1)}h (${language.totalEntries} entradas)',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}