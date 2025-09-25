// lib/models/regional_reports_models.dart

/// Información básica de una región
class RegionInfo {
  final String id;
  final String name;
  final String organizationId;
  final DateTime createdAt;

  RegionInfo({
    required this.id,
    required this.name,
    required this.organizationId,
    required this.createdAt,
  });

  factory RegionInfo.fromJson(Map<String, dynamic> json) {
    return RegionInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      organizationId: json['organizationId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Métrica por país
class CountryMetric {
  final String country;
  final double totalHours;
  final int totalEntries;
  final double percentage;

  CountryMetric({
    required this.country,
    required this.totalHours,
    required this.totalEntries,
    required this.percentage,
  });

  factory CountryMetric.fromJson(Map<String, dynamic> json) {
    return CountryMetric(
      country: json['country'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Métrica por idioma
class LanguageMetric {
  final String language;
  final double totalHours;
  final int totalEntries;
  final double percentage;

  LanguageMetric({
    required this.language,
    required this.totalHours,
    required this.totalEntries,
    required this.percentage,
  });

  factory LanguageMetric.fromJson(Map<String, dynamic> json) {
    return LanguageMetric(
      language: json['language'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// KPI regional
class RegionalKPI {
  final String metric;
  final double value;
  final String unit;
  final String period;

  RegionalKPI({
    required this.metric,
    required this.value,
    required this.unit,
    required this.period,
  });

  factory RegionalKPI.fromJson(Map<String, dynamic> json) {
    return RegionalKPI(
      metric: json['metric'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      period: json['period'] as String,
    );
  }
}

/// Rango de fechas
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }
}

/// Resumen de una región específica
class RegionalSummary {
  final String regionId;
  final String regionName;
  final String organizationId;
  final double totalHours;
  final int totalEntries;
  final int activeUsers;
  final List<CountryMetric> topCountries;
  final List<LanguageMetric> languageBreakdown;
  final List<RegionalKPI> performanceMetrics;
  final DateRange dateRange;

  RegionalSummary({
    required this.regionId,
    required this.regionName,
    required this.organizationId,
    required this.totalHours,
    required this.totalEntries,
    required this.activeUsers,
    required this.topCountries,
    required this.languageBreakdown,
    required this.performanceMetrics,
    required this.dateRange,
  });

  factory RegionalSummary.fromJson(Map<String, dynamic> json) {
    return RegionalSummary(
      regionId: json['regionId'] as String,
      regionName: json['regionName'] as String,
      organizationId: json['organizationId'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      activeUsers: json['activeUsers'] as int,
      topCountries: (json['topCountries'] as List)
          .map((item) => CountryMetric.fromJson(item as Map<String, dynamic>))
          .toList(),
      languageBreakdown: (json['languageBreakdown'] as List)
          .map((item) => LanguageMetric.fromJson(item as Map<String, dynamic>))
          .toList(),
      performanceMetrics: (json['performanceMetrics'] as List)
          .map((item) => RegionalKPI.fromJson(item as Map<String, dynamic>))
          .toList(),
      dateRange: DateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
    );
  }
}

/// Comparación entre regiones - Región individual
class RegionComparison {
  final String regionId;
  final String regionName;
  final double totalHours;
  final int totalEntries;
  final int activeUsers;
  final double avgHoursPerUser;
  final String topCountry;
  final String topLanguage;
  final double performanceScore;

  RegionComparison({
    required this.regionId,
    required this.regionName,
    required this.totalHours,
    required this.totalEntries,
    required this.activeUsers,
    required this.avgHoursPerUser,
    required this.topCountry,
    required this.topLanguage,
    required this.performanceScore,
  });

  factory RegionComparison.fromJson(Map<String, dynamic> json) {
    return RegionComparison(
      regionId: json['regionId'] as String,
      regionName: json['regionName'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      activeUsers: json['activeUsers'] as int,
      avgHoursPerUser: (json['avgHoursPerUser'] as num).toDouble(),
      topCountry: json['topCountry'] as String,
      topLanguage: json['topLanguage'] as String,
      performanceScore: (json['performanceScore'] as num).toDouble(),
    );
  }
}

/// Valor de métrica por región
class RegionMetricValue {
  final String regionId;
  final String regionName;
  final double value;
  final int rank;

  RegionMetricValue({
    required this.regionId,
    required this.regionName,
    required this.value,
    required this.rank,
  });

  factory RegionMetricValue.fromJson(Map<String, dynamic> json) {
    return RegionMetricValue(
      regionId: json['regionId'] as String,
      regionName: json['regionName'] as String,
      value: (json['value'] as num).toDouble(),
      rank: json['rank'] as int,
    );
  }
}

/// Métrica de comparación
class ComparisonMetric {
  final String metricName;
  final List<RegionMetricValue> regions;
  final RegionMetricValue bestPerformer;
  final RegionMetricValue worstPerformer;

  ComparisonMetric({
    required this.metricName,
    required this.regions,
    required this.bestPerformer,
    required this.worstPerformer,
  });

  factory ComparisonMetric.fromJson(Map<String, dynamic> json) {
    return ComparisonMetric(
      metricName: json['metricName'] as String,
      regions: (json['regions'] as List)
          .map((item) => RegionMetricValue.fromJson(item as Map<String, dynamic>))
          .toList(),
      bestPerformer: RegionMetricValue.fromJson(json['bestPerformer'] as Map<String, dynamic>),
      worstPerformer: RegionMetricValue.fromJson(json['worstPerformer'] as Map<String, dynamic>),
    );
  }
}

/// Comparación completa entre regiones
class RegionalComparison {
  final List<RegionComparison> regions;
  final String organizationId;
  final List<ComparisonMetric> comparisonMetrics;
  final DateRange dateRange;
  final ComparisonSummary summary;

  RegionalComparison({
    required this.regions,
    required this.organizationId,
    required this.comparisonMetrics,
    required this.dateRange,
    required this.summary,
  });

  factory RegionalComparison.fromJson(Map<String, dynamic> json) {
    return RegionalComparison(
      regions: (json['regions'] as List)
          .map((item) => RegionComparison.fromJson(item as Map<String, dynamic>))
          .toList(),
      organizationId: json['organizationId'] as String,
      comparisonMetrics: (json['comparisonMetrics'] as List)
          .map((item) => ComparisonMetric.fromJson(item as Map<String, dynamic>))
          .toList(),
      dateRange: DateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
      summary: ComparisonSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }
}

/// Resumen de comparación
class ComparisonSummary {
  final int totalRegions;
  final double totalHours;
  final int totalEntries;
  final double averageHoursPerRegion;

  ComparisonSummary({
    required this.totalRegions,
    required this.totalHours,
    required this.totalEntries,
    required this.averageHoursPerRegion,
  });

  factory ComparisonSummary.fromJson(Map<String, dynamic> json) {
    return ComparisonSummary(
      totalRegions: json['totalRegions'] as int,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      averageHoursPerRegion: (json['averageHoursPerRegion'] as num).toDouble(),
    );
  }
}

/// Detalle de país
class CountryDetail {
  final String country;
  final double totalHours;
  final int totalEntries;
  final int activeUsers;
  final List<String> uniqueLanguages;
  final double averageHoursPerUser;
  final double averageEntriesPerUser;
  final double percentage;
  final int rank;
  final List<CountryTrend> trends;

  CountryDetail({
    required this.country,
    required this.totalHours,
    required this.totalEntries,
    required this.activeUsers,
    required this.uniqueLanguages,
    required this.averageHoursPerUser,
    required this.averageEntriesPerUser,
    required this.percentage,
    required this.rank,
    required this.trends,
  });

  factory CountryDetail.fromJson(Map<String, dynamic> json) {
    return CountryDetail(
      country: json['country'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      activeUsers: json['activeUsers'] as int,
      uniqueLanguages: (json['uniqueLanguages'] as List).cast<String>(),
      averageHoursPerUser: (json['averageHoursPerUser'] as num).toDouble(),
      averageEntriesPerUser: (json['averageEntriesPerUser'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      rank: json['rank'] as int,
      trends: (json['trends'] as List)
          .map((item) => CountryTrend.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Tendencia por país
class CountryTrend {
  final String period;
  final String date;
  final double hours;
  final int entries;

  CountryTrend({
    required this.period,
    required this.date,
    required this.hours,
    required this.entries,
  });

  factory CountryTrend.fromJson(Map<String, dynamic> json) {
    return CountryTrend(
      period: json['period'] as String,
      date: json['date'] as String,
      hours: (json['hours'] as num).toDouble(),
      entries: json['entries'] as int,
    );
  }
}

/// Desglose por países
class CountryBreakdown {
  final String organizationId;
  final String? regionId;
  final String? regionName;
  final List<CountryDetail> countries;
  final int totalCountries;
  final double totalHours;
  final int totalEntries;
  final DateRange dateRange;
  final CountryBreakdownSummary summary;

  CountryBreakdown({
    required this.organizationId,
    this.regionId,
    this.regionName,
    required this.countries,
    required this.totalCountries,
    required this.totalHours,
    required this.totalEntries,
    required this.dateRange,
    required this.summary,
  });

  factory CountryBreakdown.fromJson(Map<String, dynamic> json) {
    return CountryBreakdown(
      organizationId: json['organizationId'] as String,
      regionId: json['regionId'] as String?,
      regionName: json['regionName'] as String?,
      countries: (json['countries'] as List)
          .map((item) => CountryDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCountries: json['totalCountries'] as int,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      dateRange: DateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
      summary: CountryBreakdownSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }
}

/// Resumen de desglose por países
class CountryBreakdownSummary {
  final String mostActiveCountry;
  final String leastActiveCountry;
  final double avgHoursPerCountry;
  final int countriesWithActivity;

  CountryBreakdownSummary({
    required this.mostActiveCountry,
    required this.leastActiveCountry,
    required this.avgHoursPerCountry,
    required this.countriesWithActivity,
  });

  factory CountryBreakdownSummary.fromJson(Map<String, dynamic> json) {
    return CountryBreakdownSummary(
      mostActiveCountry: json['mostActiveCountry'] as String,
      leastActiveCountry: json['leastActiveCountry'] as String,
      avgHoursPerCountry: (json['avgHoursPerCountry'] as num).toDouble(),
      countriesWithActivity: json['countriesWithActivity'] as int,
    );
  }
}

/// Detalle de idioma
class LanguageDetail {
  final String language;
  final double totalHours;
  final int totalEntries;
  final int activeUsers;
  final List<String> countries;
  final double averageHoursPerUser;
  final double averageEntriesPerUser;
  final double percentage;
  final int rank;
  final List<LanguageByRegion> regionalDistribution;

  LanguageDetail({
    required this.language,
    required this.totalHours,
    required this.totalEntries,
    required this.activeUsers,
    required this.countries,
    required this.averageHoursPerUser,
    required this.averageEntriesPerUser,
    required this.percentage,
    required this.rank,
    required this.regionalDistribution,
  });

  factory LanguageDetail.fromJson(Map<String, dynamic> json) {
    return LanguageDetail(
      language: json['language'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      activeUsers: json['activeUsers'] as int,
      countries: (json['countries'] as List).cast<String>(),
      averageHoursPerUser: (json['averageHoursPerUser'] as num).toDouble(),
      averageEntriesPerUser: (json['averageEntriesPerUser'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      rank: json['rank'] as int,
      regionalDistribution: (json['regionalDistribution'] as List)
          .map((item) => LanguageByRegion.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Idioma por región
class LanguageByRegion {
  final String regionId;
  final String regionName;
  final double hours;
  final int entries;
  final int users;

  LanguageByRegion({
    required this.regionId,
    required this.regionName,
    required this.hours,
    required this.entries,
    required this.users,
  });

  factory LanguageByRegion.fromJson(Map<String, dynamic> json) {
    return LanguageByRegion(
      regionId: json['regionId'] as String,
      regionName: json['regionName'] as String,
      hours: (json['hours'] as num).toDouble(),
      entries: json['entries'] as int,
      users: json['users'] as int,
    );
  }
}

/// Distribución de idiomas
class LanguageDistribution {
  final String organizationId;
  final String? regionId;
  final String? regionName;
  final String? countryFilter;
  final List<LanguageDetail> languages;
  final int totalLanguages;
  final double totalHours;
  final int totalEntries;
  final DateRange dateRange;
  final LanguageDistributionSummary summary;

  LanguageDistribution({
    required this.organizationId,
    this.regionId,
    this.regionName,
    this.countryFilter,
    required this.languages,
    required this.totalLanguages,
    required this.totalHours,
    required this.totalEntries,
    required this.dateRange,
    required this.summary,
  });

  factory LanguageDistribution.fromJson(Map<String, dynamic> json) {
    return LanguageDistribution(
      organizationId: json['organizationId'] as String,
      regionId: json['regionId'] as String?,
      regionName: json['regionName'] as String?,
      countryFilter: json['countryFilter'] as String?,
      languages: (json['languages'] as List)
          .map((item) => LanguageDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalLanguages: json['totalLanguages'] as int,
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      dateRange: DateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
      summary: LanguageDistributionSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }
}

/// Resumen de distribución de idiomas
class LanguageDistributionSummary {
  final String mostUsedLanguage;
  final String leastUsedLanguage;
  final double avgHoursPerLanguage;
  final int languagesWithActivity;

  LanguageDistributionSummary({
    required this.mostUsedLanguage,
    required this.leastUsedLanguage,
    required this.avgHoursPerLanguage,
    required this.languagesWithActivity,
  });

  factory LanguageDistributionSummary.fromJson(Map<String, dynamic> json) {
    return LanguageDistributionSummary(
      mostUsedLanguage: json['mostUsedLanguage'] as String,
      leastUsedLanguage: json['leastUsedLanguage'] as String,
      avgHoursPerLanguage: (json['avgHoursPerLanguage'] as num).toDouble(),
      languagesWithActivity: json['languagesWithActivity'] as int,
    );
  }
}

/// Dashboard de alto nivel - Región top
class TopRegion {
  final String regionId;
  final String regionName;
  final double totalHours;
  final double percentage;

  TopRegion({
    required this.regionId,
    required this.regionName,
    required this.totalHours,
    required this.percentage,
  });

  factory TopRegion.fromJson(Map<String, dynamic> json) {
    return TopRegion(
      regionId: json['regionId'] as String,
      regionName: json['regionName'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Dashboard de alto nivel - País top
class TopCountry {
  final String country;
  final double totalHours;
  final double percentage;

  TopCountry({
    required this.country,
    required this.totalHours,
    required this.percentage,
  });

  factory TopCountry.fromJson(Map<String, dynamic> json) {
    return TopCountry(
      country: json['country'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Dashboard de alto nivel - Idioma top
class TopLanguage {
  final String language;
  final double totalHours;
  final double percentage;

  TopLanguage({
    required this.language,
    required this.totalHours,
    required this.percentage,
  });

  factory TopLanguage.fromJson(Map<String, dynamic> json) {
    return TopLanguage(
      language: json['language'] as String,
      totalHours: (json['totalHours'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Resumen completo del dashboard
class DashboardSummary {
  final double totalHours;
  final int totalEntries;
  final int activeUsers;
  final int activeRegions;
  final List<TopRegion> topRegions;
  final List<TopCountry> topCountries;
  final List<TopLanguage> topLanguages;
  final DateRange dateRange;

  DashboardSummary({
    required this.totalHours,
    required this.totalEntries,
    required this.activeUsers,
    required this.activeRegions,
    required this.topRegions,
    required this.topCountries,
    required this.topLanguages,
    required this.dateRange,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalHours: (json['totalHours'] as num).toDouble(),
      totalEntries: json['totalEntries'] as int,
      activeUsers: json['activeUsers'] as int,
      activeRegions: json['activeRegions'] as int,
      topRegions: (json['topRegions'] as List)
          .map((item) => TopRegion.fromJson(item as Map<String, dynamic>))
          .toList(),
      topCountries: (json['topCountries'] as List)
          .map((item) => TopCountry.fromJson(item as Map<String, dynamic>))
          .toList(),
      topLanguages: (json['topLanguages'] as List)
          .map((item) => TopLanguage.fromJson(item as Map<String, dynamic>))
          .toList(),
      dateRange: DateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
    );
  }
}

/// Filtros para reportes
class ReportFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? regionIds;
  final List<String>? countries;
  final List<String>? languages;
  final List<String>? userIds;
  final int skip;
  final int take;
  final String sortBy;
  final String sortOrder;

  ReportFilters({
    this.startDate,
    this.endDate,
    this.regionIds,
    this.countries,
    this.languages,
    this.userIds,
    this.skip = 0,
    this.take = 20,
    this.sortBy = 'totalHours',
    this.sortOrder = 'desc',
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    
    if (startDate != null) params['startDate'] = startDate!.toIso8601String();
    if (endDate != null) params['endDate'] = endDate!.toIso8601String();
    if (regionIds != null && regionIds!.isNotEmpty) params['regionIds'] = regionIds!;
    if (countries != null && countries!.isNotEmpty) params['countries'] = countries!;
    if (languages != null && languages!.isNotEmpty) params['languages'] = languages!;
    if (userIds != null && userIds!.isNotEmpty) params['userIds'] = userIds!;
    
    params['skip'] = skip;
    params['take'] = take;
    params['sortBy'] = sortBy;
    params['sortOrder'] = sortOrder;
    
    return params;
  }
}