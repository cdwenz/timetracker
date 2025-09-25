// lib/screens/country_breakdown_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/reports_metrics_service.dart';
import '../services/api_service.dart';
import '../services/export_service.dart';
import '../models/regional_reports_models.dart';
import '../l10n/app_localizations.dart';

class CountryBreakdownScreen extends StatefulWidget {
  const CountryBreakdownScreen({super.key});

  @override
  State<CountryBreakdownScreen> createState() => _CountryBreakdownScreenState();
}

class _CountryBreakdownScreenState extends State<CountryBreakdownScreen> {
  final ReportsMetricsService _service = ReportsMetricsService(ApiService());
  
  CountryBreakdown? _breakdown;
  List<RegionInfo> _availableRegions = [];
  bool _isLoading = true;
  
  // Filtros
  String? _selectedRegionId;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedCountries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Cargar regiones disponibles
      _availableRegions = await _service.getAccessibleRegions();
      
      // Cargar breakdown de países
      _breakdown = await _service.getCountryBreakdown(
        regionId: _selectedRegionId,
        startDate: _startDate,
        endDate: _endDate,
        countries: _selectedCountries.isNotEmpty ? _selectedCountries : null,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cargando datos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    setState(() => _isLoading = false);
  }

  void _showRegionSelector() async {
    final String? selected = await showDialog<String>(
      context: context,
      builder: (context) => _RegionSelectorDialog(
        availableRegions: _availableRegions,
        selectedRegionId: _selectedRegionId,
      ),
    );
    
    if (selected != _selectedRegionId) {
      setState(() => _selectedRegionId = selected);
      _loadData();
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
      _loadData();
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedRegionId = null;
      _startDate = null;
      _endDate = null;
      _selectedCountries.clear();
    });
    _loadData();
  }

  void _showExportOptions() async {
    if (_breakdown == null) return;

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
    if (_breakdown == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loadingData),
          duration: const Duration(seconds: 2),
        ),
      );

      final filePath = await ExportService.exportCountryBreakdown(
        _breakdown!,
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
                subject: 'Country Breakdown Report',
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
        title: const Text('Desglose por Países'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showRegionSelector,
            tooltip: AppLocalizations.of(context).filterByRegion,
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangePicker,
            tooltip: AppLocalizations.of(context).filterByDates,
          ),
          if (_selectedRegionId != null || _startDate != null || _selectedCountries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilters,
              tooltip: AppLocalizations.of(context).clearFilters,
            ),
          if (_breakdown != null)
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
          : _breakdown == null
              ? const Center(
                  child: Text(
                    'No hay datos disponibles',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filtros activos
                      _buildActiveFiltersCard(),
                      
                      const SizedBox(height: 16),
                      
                      // Resumen principal
                      _buildSummarySection(),
                      
                      const SizedBox(height: 20),
                      
                      // Gráfico de distribución por países
                      _buildCountryDistributionChart(),
                      
                      const SizedBox(height: 20),
                      
                      // Lista detallada de países
                      _buildCountriesDetailList(),
                      
                      const SizedBox(height: 20),
                      
                      // Insights y estadísticas
                      _buildInsightsSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActiveFiltersCard() {
    final hasFilters = _selectedRegionId != null || _startDate != null || _selectedCountries.isNotEmpty;
    
    if (!hasFilters) return const SizedBox.shrink();
    
    return Card(
      color: Colors.green.shade50,
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
            
            if (_selectedRegionId != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(_breakdown!.regionName ?? 'Región seleccionada'),
                ],
              ),
            ] else ...[
              const Row(
                children: [
                  Icon(Icons.public, size: 16),
                  SizedBox(width: 4),
                  Text('Todas las regiones'),
                ],
              ),
            ],
            
            if (_startDate != null && _endDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.date_range, size: 16),
                  const SizedBox(width: 4),
                  Text('${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'),
                ],
              ),
            ],
            
            if (_selectedCountries.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.flag, size: 16),
                  const SizedBox(width: 4),
                  Text('Países: ${_selectedCountries.join(", ")}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen General',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Países',
                    _breakdown!.totalCountries.toString(),
                    Icons.flag,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Total Horas',
                    _breakdown!.totalHours.toStringAsFixed(1),
                    Icons.access_time,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Total Entradas',
                    _breakdown!.totalEntries.toString(),
                    Icons.list_alt,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Insights rápidos
            Row(
              children: [
                Expanded(
                  child: _buildInsightCard(
                    'Más Activo',
                    _breakdown!.summary.mostActiveCountry,
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInsightCard(
                    'Menos Activo',
                    _breakdown!.summary.leastActiveCountry,
                    Icons.trending_down,
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

  Widget _buildCountryDistributionChart() {
    if (_breakdown!.countries.isEmpty) return const SizedBox.shrink();
    
    // Mostrar solo los top 10 países para el gráfico
    final topCountries = _breakdown!.countries.take(10).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribución por Países (Top 10)',
              style: TextStyle(
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
                  maxY: topCountries.map((c) => c.totalHours).reduce((a, b) => a > b ? a : b) * 1.1,
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
                          if (index >= 0 && index < topCountries.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                topCountries[index].country,
                                style: const TextStyle(fontSize: 10),
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
                  barGroups: List.generate(topCountries.length, (index) {
                    final country = topCountries[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: country.totalHours,
                          color: _getColorForIndex(index),
                          width: 20,
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

  Widget _buildCountriesDetailList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalle por Países (${_breakdown!.countries.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _breakdown!.countries.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final country = _breakdown!.countries[index];
                return _buildCountryTile(country, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryTile(CountryDetail country, int index) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: _getColorForIndex(index).withOpacity(0.2),
        child: Text(
          '#${country.rank}',
          style: TextStyle(
            color: _getColorForIndex(index),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        country.country,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${country.totalHours.toStringAsFixed(1)} horas • ${country.totalEntries} entradas • ${country.activeUsers} usuarios',
      ),
      trailing: Text(
        '${country.percentage.toStringAsFixed(1)}%',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _getColorForIndex(index),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDetailMetric(
                      'Promedio hrs/usuario',
                      country.averageHoursPerUser.toStringAsFixed(1),
                      Icons.person,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailMetric(
                      'Promedio entradas/usuario',
                      country.averageEntriesPerUser.toStringAsFixed(1),
                      Icons.list,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              if (country.uniqueLanguages.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Idiomas utilizados: ${country.uniqueLanguages.join(", ")}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas e Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Promedio Horas/País',
                    _breakdown!.summary.avgHoursPerCountry.toStringAsFixed(1),
                    Icons.bar_chart,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Países Activos',
                    _breakdown!.summary.countriesWithActivity.toString(),
                    Icons.public,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Datos del período
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del Período',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Desde: ${_formatDate(_breakdown!.dateRange.startDate)}'),
                  Text('Hasta: ${_formatDate(_breakdown!.dateRange.endDate)}'),
                  if (_breakdown!.regionName != null)
                    Text('Región: ${_breakdown!.regionName}')
                  else
                    const Text('Alcance: Todas las regiones'),
                ],
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

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
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
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
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
    );
  }

  Widget _buildDetailMetric(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
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

class _RegionSelectorDialog extends StatelessWidget {
  final List<RegionInfo> availableRegions;
  final String? selectedRegionId;

  const _RegionSelectorDialog({
    required this.availableRegions,
    required this.selectedRegionId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar por Región'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Todas las regiones'),
              leading: Radio<String?>(
                value: null,
                groupValue: selectedRegionId,
                onChanged: (value) => Navigator.of(context).pop(value),
              ),
              onTap: () => Navigator.of(context).pop(null),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableRegions.length,
                itemBuilder: (context, index) {
                  final region = availableRegions[index];
                  return ListTile(
                    title: Text(region.name),
                    subtitle: Text('ID: ${region.id.substring(0, 8)}...'),
                    leading: Radio<String>(
                      value: region.id,
                      groupValue: selectedRegionId,
                      onChanged: (value) => Navigator.of(context).pop(value),
                    ),
                    onTap: () => Navigator.of(context).pop(region.id),
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
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}