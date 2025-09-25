// lib/screens/language_distribution_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/reports_metrics_service.dart';
import '../services/api_service.dart';
import '../services/export_service.dart';
import '../models/regional_reports_models.dart';
import '../l10n/app_localizations.dart';

class LanguageDistributionScreen extends StatefulWidget {
  const LanguageDistributionScreen({super.key});

  @override
  State<LanguageDistributionScreen> createState() => _LanguageDistributionScreenState();
}

class _LanguageDistributionScreenState extends State<LanguageDistributionScreen> {
  final ReportsMetricsService _service = ReportsMetricsService(ApiService());
  
  LanguageDistribution? _distribution;
  List<RegionInfo> _availableRegions = [];
  bool _isLoading = true;
  
  // Filtros
  String? _selectedRegionId;
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
      // Cargar regiones disponibles
      _availableRegions = await _service.getAccessibleRegions();
      
      // Cargar distribución de idiomas
      _distribution = await _service.getLanguageDistribution(
        regionId: _selectedRegionId,
        startDate: _startDate,
        endDate: _endDate,
        countries: _selectedCountries.isNotEmpty ? _selectedCountries : null,
        languages: _selectedLanguages.isNotEmpty ? _selectedLanguages : null,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorLoadingLanguageData(e)),
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
      _selectedLanguages.clear();
    });
    _loadData();
  }

  void _showExportOptions() async {
    if (_distribution == null) return;

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
    if (_distribution == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loadingData),
          duration: const Duration(seconds: 2),
        ),
      );

      final filePath = await ExportService.exportLanguageDistribution(
        _distribution!,
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
                subject: AppLocalizations.of(context).languageDistributionReportSubject,
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
        title: Text(AppLocalizations.of(context).languageDistribution),
        backgroundColor: Colors.orange.shade700,
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
          if (_selectedRegionId != null || _startDate != null || 
              _selectedCountries.isNotEmpty || _selectedLanguages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilters,
              tooltip: AppLocalizations.of(context).clearFilters,
            ),
          if (_distribution != null)
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
          : _distribution == null
              ? Center(
                  child: Text(
                    AppLocalizations.of(context).noDataAvailable,
                    style: const TextStyle(fontSize: 16),
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
                      
                      // Gráfico de pastel de distribución de idiomas
                      _buildLanguagePieChart(),
                      
                      const SizedBox(height: 20),
                      
                      // Gráfico de barras horizontales
                      _buildLanguageBarChart(),
                      
                      const SizedBox(height: 20),
                      
                      // Lista detallada de idiomas
                      _buildLanguagesDetailList(),
                      
                      const SizedBox(height: 20),
                      
                      // Distribución regional de idiomas
                      if (_distribution!.languages.isNotEmpty)
                        _buildRegionalDistributionSection(),
                      
                      const SizedBox(height: 20),
                      
                      // Insights y estadísticas
                      _buildInsightsSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActiveFiltersCard() {
    final hasFilters = _selectedRegionId != null || _startDate != null || 
                      _selectedCountries.isNotEmpty || _selectedLanguages.isNotEmpty;
    
    if (!hasFilters) return const SizedBox.shrink();
    
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).activeFilters,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            if (_selectedRegionId != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(_distribution!.regionName ?? AppLocalizations.of(context).selectedRegion),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  const Icon(Icons.public, size: 16),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context).allRegions),
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
                  Text(AppLocalizations.of(context).countries(_selectedCountries.join(", "))),
                ],
              ),
            ],
            
            if (_selectedLanguages.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.language, size: 16),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context).languages(_selectedLanguages.join(", "))),
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
              AppLocalizations.of(context).generalSummary,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    AppLocalizations.of(context).totalLanguages,
                    _distribution!.totalLanguages.toString(),
                    Icons.language,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    AppLocalizations.of(context).totalHours,
                    _distribution!.totalHours.toStringAsFixed(1),
                    Icons.access_time,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    AppLocalizations.of(context).totalEntries,
                    _distribution!.totalEntries.toString(),
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
                    AppLocalizations.of(context).mostUsed,
                    _distribution!.summary.mostUsedLanguage,
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInsightCard(
                    AppLocalizations.of(context).leastUsed,
                    _distribution!.summary.leastUsedLanguage,
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

  Widget _buildLanguagePieChart() {
    if (_distribution!.languages.isEmpty) return const SizedBox.shrink();
    
    // Mostrar solo los top 8 idiomas para el gráfico de pastel
    final topLanguages = _distribution!.languages.take(8).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).languageDistribution,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: topLanguages.map((language) => 
                          PieChartSectionData(
                            value: language.percentage,
                            title: '${language.percentage.toStringAsFixed(1)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            color: _getColorForIndex(topLanguages.indexOf(language)),
                          )
                        ).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Leyenda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: topLanguages.map((language) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getColorForIndex(topLanguages.indexOf(language)),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  language.language,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageBarChart() {
    if (_distribution!.languages.isEmpty) return const SizedBox.shrink();
    
    // Mostrar todos los idiomas en el gráfico de barras horizontales
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).hoursPerLanguage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: _distribution!.languages.length * 35.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _distribution!.languages.map((l) => l.totalHours).reduce((a, b) => a > b ? a : b) * 1.1,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _distribution!.languages.length) {
                            return Text(
                              _distribution!.languages[index].language,
                              style: const TextStyle(fontSize: 11),
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
                  barGroups: List.generate(_distribution!.languages.length, (index) {
                    final language = _distribution!.languages[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: language.totalHours,
                          color: _getColorForIndex(index),
                          width: 20,
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

  Widget _buildLanguagesDetailList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).languageDetails(_distribution!.languages.length),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _distribution!.languages.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final language = _distribution!.languages[index];
                return _buildLanguageTile(language, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(LanguageDetail language, int index) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: _getColorForIndex(index).withOpacity(0.2),
        child: Text(
          '#${language.rank}',
          style: TextStyle(
            color: _getColorForIndex(index),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        language.language,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${language.totalHours.toStringAsFixed(1)} ${AppLocalizations.of(context).hours} • ${language.totalEntries} ${AppLocalizations.of(context).entries} • ${language.activeUsers} ${AppLocalizations.of(context).users}',
      ),
      trailing: Text(
        '${language.percentage.toStringAsFixed(1)}%',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDetailMetric(
                      AppLocalizations.of(context).averageHrsPerUser,
                      language.averageHoursPerUser.toStringAsFixed(1),
                      Icons.person,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailMetric(
                      AppLocalizations.of(context).averageEntriesPerUser,
                      language.averageEntriesPerUser.toStringAsFixed(1),
                      Icons.list,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              if (language.countries.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context).countriesWhereUsed(language.countries.join(", ")),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
              ],
              
              if (language.regionalDistribution.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context).regionalDistribution,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...language.regionalDistribution.map((regional) =>
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(regional.regionName, style: const TextStyle(fontSize: 13)),
                        Text(
                          '${regional.hours.toStringAsFixed(1)}h (${regional.entries} ${AppLocalizations.of(context).entries})',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegionalDistributionSection() {
    // Obtener todos los datos regionales únicos
    final Map<String, Map<String, double>> regionalData = {};
    
    for (final language in _distribution!.languages.take(5)) {
      for (final regional in language.regionalDistribution) {
        regionalData[regional.regionName] ??= {};
        regionalData[regional.regionName]![language.language] = regional.hours;
      }
    }
    
    if (regionalData.isEmpty) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).regionalLanguageDistribution,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ...regionalData.entries.map((entry) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...entry.value.entries.map((langEntry) =>
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(langEntry.key),
                            Text('${langEntry.value.toStringAsFixed(1)} ${AppLocalizations.of(context).hours}'),
                          ],
                        ),
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

  Widget _buildInsightsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).statisticsInsights,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    AppLocalizations.of(context).averageHoursPerLanguage,
                    _distribution!.summary.avgHoursPerLanguage.toStringAsFixed(1),
                    Icons.bar_chart,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    AppLocalizations.of(context).activeLanguages,
                    _distribution!.summary.languagesWithActivity.toString(),
                    Icons.language,
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
                  Text(
                    AppLocalizations.of(context).periodInformation,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context).from(_formatDate(_distribution!.dateRange.startDate))),
                  Text(AppLocalizations.of(context).to(_formatDate(_distribution!.dateRange.endDate))),
                  if (_distribution!.regionName != null)
                    Text(AppLocalizations.of(context).regionScope(_distribution!.regionName!))
                  else
                    Text(AppLocalizations.of(context).allRegionsScope),
                  if (_distribution!.countryFilter != null)
                    Text(AppLocalizations.of(context).countryFiltered(_distribution!.countryFilter!)),
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
      Colors.pink,
      Colors.cyan,
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
      title: Text(AppLocalizations.of(context).filterByRegion),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context).allRegions),
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
          child: Text(AppLocalizations.of(context).cancel),
        ),
      ],
    );
  }
}