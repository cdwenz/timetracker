// lib/screens/enhanced_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';
import 'package:ihadi_time_tracker/services/reports_metrics_service.dart';
import 'package:ihadi_time_tracker/services/api_service.dart';
import 'package:ihadi_time_tracker/screens/reports_detail_screen.dart';
import 'package:ihadi_time_tracker/screens/regional_summary_screen.dart';
import 'package:ihadi_time_tracker/screens/regional_comparison_screen.dart';
import 'package:ihadi_time_tracker/screens/country_breakdown_screen.dart';
import 'package:ihadi_time_tracker/screens/language_distribution_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/export_service.dart';
import '../models/regional_reports_models.dart';

class EnhancedReportsScreen extends StatefulWidget {
  const EnhancedReportsScreen({super.key});

  @override
  State<EnhancedReportsScreen> createState() => _EnhancedReportsScreenState();
}

class _EnhancedReportsScreenState extends State<EnhancedReportsScreen> {
  final ReportsMetricsService _metricsService = ReportsMetricsService(ApiService());
  
  // Estado para el dashboard básico
  ReportsDashboardData? _basicDashboard;
  
  // Estado para el dashboard regional
  DashboardSummary? _regionalDashboard;
  
  // Lista de regiones disponibles
  List<RegionInfo> _availableRegions = [];
  
  // Estado de carga y rol del usuario
  bool _isLoading = true;
  String? _userRole;
  bool _hasRegionalAccess = false;
  String _userAccessDescription = '';
  
  // Filtros activos
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
      // Obtener rol del usuario y permisos
      _userRole = await AuthService.currentUserRole();
      _hasRegionalAccess = await _metricsService.canAccessRegionalReports();
      _userAccessDescription = await _metricsService.getUserAccessDescription();
      
      // Cargar dashboard básico (siempre disponible)
      _basicDashboard = await _metricsService.loadDashboardLast30Days();
      
      // Si tiene acceso regional, cargar datos adicionales
      if (_hasRegionalAccess) {
        _regionalDashboard = await _metricsService.loadEnhancedDashboard(
          startDate: _startDate,
          endDate: _endDate,
          countries: _selectedCountries.isNotEmpty ? _selectedCountries : null,
          languages: _selectedLanguages.isNotEmpty ? _selectedLanguages : null,
        );
        
        _availableRegions = await _metricsService.getAccessibleRegions();
      }
    } catch (e) {
      _showError('Error cargando reportes: $e');
    }
    
    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  // Helper para formatear porcentajes sin decimales
  String _formatPercentage(double percentage) {
    return '${percentage.round()}%';
  }

  void _showExportOptions() async {
    final String? exportType = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).exportOptions),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.summarize),
              title: const Text('Dashboard Completo'),
              subtitle: const Text('Resumen general y métricas básicas'),
              onTap: () => Navigator.of(context).pop('dashboard'),
            ),
            if (_regionalDashboard != null) ...[
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Dashboard Regional'),
                subtitle: const Text('Datos regionales y comparaciones'),
                onTap: () => Navigator.of(context).pop('regional'),
              ),
            ],
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

    if (exportType != null) {
      _exportDashboard(exportType);
    }
  }

  void _exportDashboard(String type) async {
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
      _performExport(type, format);
    }
  }

  void _performExport(String type, ExportFormat format) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loadingData),
          duration: const Duration(seconds: 2),
        ),
      );

      String filePath = '';
      String subject = '';

      if (type == 'dashboard' && _basicDashboard != null) {
        // Para dashboard básico, crear un CSV con los datos
        filePath = await _exportBasicDashboard(format);
        subject = 'Dashboard Report';
      } else if (type == 'regional' && _regionalDashboard != null) {
        // Para dashboard regional, crear un CSV con los datos
        filePath = await _exportRegionalDashboard(format);
        subject = 'Regional Dashboard Report';
      }

      if (mounted && filePath.isNotEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).exportSuccess),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: AppLocalizations.of(context).shareReport,
              onPressed: () => ExportService.shareReport(filePath, subject: subject),
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

  Future<String> _exportBasicDashboard(ExportFormat format) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final userName = await AuthService.currentUserName() ?? 'Unknown';
    
    if (_basicDashboard == null) {
      throw Exception('No basic dashboard data available');
    }
    
    switch (format) {
      case ExportFormat.csv:
        return _exportBasicDashboardCSV(timestamp, userName);
      case ExportFormat.excel:
        return _exportBasicDashboardExcel(timestamp, userName);
      case ExportFormat.pdf:
        return _exportBasicDashboardPDF(timestamp, userName);
    }
  }

  Future<String> _exportBasicDashboardCSV(int timestamp, String userName) async {
    final buffer = StringBuffer();
    
    buffer.writeln('Basic Dashboard Report');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('User: $userName');
    buffer.writeln('Role: ${_userRole ?? 'Unknown'}');
    buffer.writeln('');
    
    buffer.writeln('Dashboard Metrics');
    buffer.writeln('Team Count,${_basicDashboard!.teamCount}');
    buffer.writeln('Me Count,${_basicDashboard!.meCount}');
    buffer.writeln('');
    
    buffer.writeln('Daily Comparison');
    buffer.writeln('Day,Team Count,My Count');
    for (final daily in _basicDashboard!.dailyCompare) {
      buffer.writeln('${daily.day.day}/${daily.day.month},${daily.teamCount},${daily.myCount}');
    }
    buffer.writeln('');
    
    buffer.writeln('My Trend');
    buffer.writeln('Day,Count');
    for (final trend in _basicDashboard!.myTrend) {
      buffer.writeln('${trend.day.day}/${trend.day.month},${trend.count}');
    }
    
    final file = await ExportService.saveToFile(buffer.toString(), 'basic_dashboard_$timestamp.csv');
    return file.path;
  }

  Future<String> _exportBasicDashboardExcel(int timestamp, String userName) async {
    return ExportService.generateRealExcel('Basic Dashboard', [
      ['Basic Dashboard Report'],
      ['Generated', DateTime.now().toString()],
      ['User', userName],
      ['Role', _userRole ?? 'Unknown'],
      [],
      ['Dashboard Metrics'],
      ['Team Count', _basicDashboard!.teamCount],
      ['Me Count', _basicDashboard!.meCount],
      [],
      ['Daily Comparison', '', ''],
      ['Day', 'Team Count', 'My Count'],
      ..._basicDashboard!.dailyCompare.map((daily) => ['${daily.day.day}/${daily.day.month}', daily.teamCount, daily.myCount]),
      [],
      ['My Trend', ''],
      ['Day', 'Count'],
      ..._basicDashboard!.myTrend.map((trend) => ['${trend.day.day}/${trend.day.month}', trend.count]),
    ]);
  }

  Future<String> _exportBasicDashboardPDF(int timestamp, String userName) async {
    final content = [
      'Basic Dashboard Report',
      'Generated: ${DateTime.now()}',
      'User: $userName',
      'Role: ${_userRole ?? 'Unknown'}',
      '',
      'DASHBOARD METRICS:',
      '• Team Count: ${_basicDashboard!.teamCount}',
      '• Me Count: ${_basicDashboard!.meCount}',
      '',
      'DAILY COMPARISON:',
      ..._basicDashboard!.dailyCompare.map((daily) => '• ${daily.day.day}/${daily.day.month}: Team ${daily.teamCount}, Me ${daily.myCount}'),
      '',
      'MY TREND:',
      ..._basicDashboard!.myTrend.map((trend) => '• ${trend.day.day}/${trend.day.month}: ${trend.count}'),
    ];
    
    return await ExportService.generateRealPDF('Basic Dashboard Report', content);
  }

  Future<String> _exportRegionalDashboard(ExportFormat format) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final userName = await AuthService.currentUserName() ?? 'Unknown';
    
    if (_regionalDashboard == null) {
      throw Exception('No regional dashboard data available');
    }
    
    switch (format) {
      case ExportFormat.csv:
        return _exportRegionalDashboardCSV(timestamp, userName);
      case ExportFormat.excel:
        return _exportRegionalDashboardExcel(timestamp, userName);
      case ExportFormat.pdf:
        return _exportRegionalDashboardPDF(timestamp, userName);
    }
  }

  Future<String> _exportRegionalDashboardCSV(int timestamp, String userName) async {
    final buffer = StringBuffer();
    
    buffer.writeln('Regional Dashboard Report');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('User: $userName');
    buffer.writeln('Role: ${_userRole ?? 'Unknown'}');
    buffer.writeln('');
    
    buffer.writeln('Regional Summary');
    buffer.writeln('Active Regions,${_regionalDashboard!.activeRegions}');
    buffer.writeln('Total Hours,${_regionalDashboard!.totalHours}');
    buffer.writeln('Total Entries,${_regionalDashboard!.totalEntries}');
    buffer.writeln('Active Users,${_regionalDashboard!.activeUsers}');
    buffer.writeln('');
    
    buffer.writeln('Top Countries');
    buffer.writeln('Country,Hours,Percentage');
    for (final country in _regionalDashboard!.topCountries) {
      buffer.writeln('${country.country},${country.totalHours},${_formatPercentage(country.percentage)}');
    }
    buffer.writeln('');
    
    buffer.writeln('Top Languages');
    buffer.writeln('Language,Hours,Percentage');
    for (final lang in _regionalDashboard!.topLanguages) {
      buffer.writeln('${lang.language},${lang.totalHours},${_formatPercentage(lang.percentage)}');
    }
    
    final file = await ExportService.saveToFile(buffer.toString(), 'regional_dashboard_$timestamp.csv');
    return file.path;
  }

  Future<String> _exportRegionalDashboardExcel(int timestamp, String userName) async {
    return ExportService.generateRealExcel('Regional Dashboard', [
      ['Regional Dashboard Report'],
      ['Generated', DateTime.now().toString()],
      ['User', userName],
      ['Role', _userRole ?? 'Unknown'],
      [],
      ['Regional Summary'],
      ['Active Regions', _regionalDashboard!.activeRegions],
      ['Total Hours', _regionalDashboard!.totalHours],
      ['Total Entries', _regionalDashboard!.totalEntries],
      ['Active Users', _regionalDashboard!.activeUsers],
      [],
      ['Top Countries', '', ''],
      ['Country', 'Hours', 'Percentage'],
      ..._regionalDashboard!.topCountries.map((c) => [c.country, c.totalHours, _formatPercentage(c.percentage)]),
      [],
      ['Top Languages', '', ''],
      ['Language', 'Hours', 'Percentage'],
      ..._regionalDashboard!.topLanguages.map((l) => [l.language, l.totalHours, _formatPercentage(l.percentage)]),
    ]);
  }

  Future<String> _exportRegionalDashboardPDF(int timestamp, String userName) async {
    final content = [
      'Regional Dashboard Report',
      'Generated: ${DateTime.now()}',
      'User: $userName',
      'Role: ${_userRole ?? 'Unknown'}',
      '',
      'REGIONAL SUMMARY:',
      '• Active Regions: ${_regionalDashboard!.activeRegions}',
      '• Total Hours: ${_regionalDashboard!.totalHours}',
      '• Total Entries: ${_regionalDashboard!.totalEntries}',
      '• Active Users: ${_regionalDashboard!.activeUsers}',
      '',
      'TOP COUNTRIES:',
      ..._regionalDashboard!.topCountries.map((c) => '• ${c.country}: ${c.totalHours} hours (${_formatPercentage(c.percentage)})'),
      '',
      'TOP LANGUAGES:',
      ..._regionalDashboard!.topLanguages.map((l) => '• ${l.language}: ${l.totalHours} hours (${_formatPercentage(l.percentage)})'),
    ];
    
    return await ExportService.generateRealPDF('Regional Dashboard Report', content);
  }

  void _navigateToRegionalSummary(String regionId, String regionName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegionalSummaryScreen(
          regionId: regionId,
          regionName: regionName,
        ),
      ),
    );
  }

  void _navigateToRegionalComparison() {
    if (_availableRegions.length < 2) {
      _showError('Se necesitan al menos 2 regiones para comparar');
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegionalComparisonScreen(
          availableRegions: _availableRegions,
        ),
      ),
    );
  }

  void _navigateToCountryBreakdown() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CountryBreakdownScreen(),
      ),
    );
  }

  void _navigateToLanguageDistribution() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageDistributionScreen(),
      ),
    );
  }

  void _goToBasicDetail(String title, ReportsDetailFilter filter) {
    Navigator.pushNamed(
      context,
      '/reports/detail',
      arguments: ReportsDetailArgs(title: title, filter: filter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes - ${_userRole ?? 'Usuario'}'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Actualizar datos',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información de acceso del usuario
                  _buildUserAccessCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Dashboard básico (siempre visible)
                  _buildBasicDashboard(),
                  
                  if (_hasRegionalAccess) ...[
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
                    
                    // Dashboard regional (solo para roles autorizados)
                    _buildRegionalDashboard(),
                    
                    const SizedBox(height: 30),
                    
                    // Opciones de reportes avanzados
                    _buildAdvancedReportsSection(),
                    
                    const SizedBox(height: 20),
                    
                    // Lista de regiones disponibles
                    _buildRegionsSection(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildUserAccessCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Tu nivel de acceso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _userAccessDescription,
              style: const TextStyle(fontSize: 16),
            ),
            if (_hasRegionalAccess) ...[
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Acceso a reportes regionales habilitado',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicDashboard() {
    if (_basicDashboard == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No hay datos de dashboard básico disponibles'),
        ),
      );
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Personal (últimos 30 días)',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Tarjetas de resumen
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Mis Entradas',
                _basicDashboard!.meCount.toString(),
                Icons.person,
                Colors.blue,
                () => _goToBasicDetail('Mis Reportes', ReportsDetailFilter.me),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Equipo',
                _basicDashboard!.teamCount.toString(),
                Icons.group,
                Colors.green,
                () => _goToBasicDetail('Reportes del Equipo', ReportsDetailFilter.team),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Gráfico de comparación diaria
        if (_basicDashboard!.dailyCompare.isNotEmpty)
          _buildDailyComparisonChart(),
      ],
    );
  }

  Widget _buildRegionalDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Regional',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_regionalDashboard != null) ...[
          // Métricas regionales
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Horas',
                  _regionalDashboard!.totalHours.toStringAsFixed(1),
                  Icons.access_time,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  'Usuarios Activos',
                  _regionalDashboard!.activeUsers.toString(),
                  Icons.people,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  'Regiones Activas',
                  _regionalDashboard!.activeRegions.toString(),
                  Icons.location_on,
                  Colors.teal,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Top regiones
          if (_regionalDashboard!.topRegions.isNotEmpty) ...[
            Text(
              'Regiones Más Activas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._regionalDashboard!.topRegions.take(5).map((region) => 
              _buildTopRegionTile(region)
            ),
          ],
        ] else ...[
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No hay datos regionales disponibles'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdvancedReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reportes Avanzados',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildAdvancedReportCard(
              'Comparar Regiones',
              'Analizar múltiples regiones',
              Icons.compare_arrows,
              Colors.blue,
              _navigateToRegionalComparison,
            ),
            _buildAdvancedReportCard(
              'Por Countries',
              'Desglose por países',
              Icons.flag,
              Colors.green,
              _navigateToCountryBreakdown,
            ),
            _buildAdvancedReportCard(
              'Por Idiomas',
              'Distribución de idiomas',
              Icons.language,
              Colors.orange,
              _navigateToLanguageDistribution,
            ),
            _buildAdvancedReportCard(
              AppLocalizations.of(context).exportReport,
              AppLocalizations.of(context).generateReport,
              Icons.download,
              Colors.purple,
              _showExportOptions,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegionsSection() {
    if (_availableRegions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Regiones Disponibles (${_availableRegions.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        ..._availableRegions.map((region) => 
          _buildRegionTile(region)
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    
    return Card(
      elevation: 4,
      color: Colors.white, // Asegurar fondo blanco
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300), // Borde visible para debug
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Color más contrastante
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87, // Color más contrastante
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedReportCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRegionTile(TopRegion region) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            region.regionName.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(region.regionName),
        subtitle: Text('${region.totalHours.toStringAsFixed(1)} horas'),
        trailing: Text(
          _formatPercentage(region.percentage),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _navigateToRegionalSummary(region.regionId, region.regionName),
      ),
    );
  }

  Widget _buildRegionTile(RegionInfo region) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.blue),
        title: Text(region.name),
        subtitle: Text('ID: ${region.id.substring(0, 8)}...'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToRegionalSummary(region.id, region.name),
      ),
    );
  }

  Widget _buildDailyComparisonChart() {
    final data = _basicDashboard!.dailyCompare;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comparación Diaria (Yo vs Equipo)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.map((e) => e.teamCount.toDouble()).reduce((a, b) => a > b ? a : b) + 2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            return Text(
                              '${data[index].day.day}',
                              style: const TextStyle(fontSize: 10),
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
                  barGroups: List.generate(data.length, (index) {
                    final item = data[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.myCount.toDouble(),
                          color: Colors.blue,
                          width: 8,
                        ),
                        BarChartRodData(
                          toY: item.teamCount.toDouble(),
                          color: Colors.green,
                          width: 8,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Yo', Colors.blue),
                const SizedBox(width: 20),
                _buildLegendItem('Equipo', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}