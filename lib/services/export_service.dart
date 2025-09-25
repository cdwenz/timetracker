// lib/services/export_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/regional_reports_models.dart';

enum ExportFormat { pdf, excel, csv }

class ExportService {
  static Future<String> exportRegionalSummary(
    RegionalSummary summary,
    ExportFormat format, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'regional_summary_${summary.regionName}_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromSummary(summary);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          // Para Excel, podríamos usar el paquete excel
          content = _generateExcelFromSummary(summary);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          // Para PDF, podríamos usar el paquete pdf
          content = _generatePDFFromSummary(summary);
          fileName += '.pdf';
          break;
      }

      final file = await _saveToFile(content, fileName);
      return file.path;
    } catch (e) {
      throw Exception('Error exporting regional summary: $e');
    }
  }

  static Future<String> exportRegionalComparison(
    RegionalComparison comparison,
    ExportFormat format, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'regional_comparison_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromComparison(comparison);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          content = _generateExcelFromComparison(comparison);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          content = _generatePDFFromComparison(comparison);
          fileName += '.pdf';
          break;
      }

      final file = await _saveToFile(content, fileName);
      return file.path;
    } catch (e) {
      throw Exception('Error exporting regional comparison: $e');
    }
  }

  static Future<String> exportCountryBreakdown(
    CountryBreakdown breakdown,
    ExportFormat format, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'country_breakdown_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromCountryBreakdown(breakdown);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          content = _generateExcelFromCountryBreakdown(breakdown);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          content = _generatePDFFromCountryBreakdown(breakdown);
          fileName += '.pdf';
          break;
      }

      final file = await _saveToFile(content, fileName);
      return file.path;
    } catch (e) {
      throw Exception('Error exporting country breakdown: $e');
    }
  }

  static Future<String> exportLanguageDistribution(
    LanguageDistribution distribution,
    ExportFormat format, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'language_distribution_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromLanguageDistribution(distribution);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          content = _generateExcelFromLanguageDistribution(distribution);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          content = _generatePDFFromLanguageDistribution(distribution);
          fileName += '.pdf';
          break;
      }

      final file = await _saveToFile(content, fileName);
      return file.path;
    } catch (e) {
      throw Exception('Error exporting language distribution: $e');
    }
  }

  // Funciones de generación de CSV
  static String _generateCSVFromSummary(RegionalSummary summary) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('Regional Summary Report');
    buffer.writeln('Region,${summary.regionName}');
    buffer.writeln('Total Hours,${summary.totalHours}');
    buffer.writeln('Total Entries,${summary.totalEntries}');
    buffer.writeln('Active Users,${summary.activeUsers}');
    buffer.writeln('');
    
    // Top Countries
    buffer.writeln('Top Countries');
    buffer.writeln('Country,Hours,Percentage');
    for (final country in summary.topCountries) {
      buffer.writeln('${country.country},${country.totalHours},${country.percentage}%');
    }
    buffer.writeln('');
    
    // Language Breakdown
    buffer.writeln('Language Breakdown');
    buffer.writeln('Language,Hours,Entries,Percentage');
    for (final lang in summary.languageBreakdown) {
      buffer.writeln('${lang.language},${lang.totalHours},${lang.totalEntries},${lang.percentage}%');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromComparison(RegionalComparison comparison) {
    final buffer = StringBuffer();
    
    buffer.writeln('Regional Comparison Report');
    buffer.writeln('Total Regions,${comparison.summary.totalRegions}');
    buffer.writeln('Total Hours,${comparison.summary.totalHours}');
    buffer.writeln('Average Hours per Region,${comparison.summary.averageHoursPerRegion}');
    buffer.writeln('');
    
    buffer.writeln('Regional Data');
    buffer.writeln('Region,Hours,Entries,Active Users,Avg Hours/User,Top Country,Top Language');
    for (final region in comparison.regions) {
      buffer.writeln('${region.regionName},${region.totalHours},${region.totalEntries},${region.activeUsers},${region.avgHoursPerUser},${region.topCountry},${region.topLanguage}');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromCountryBreakdown(CountryBreakdown breakdown) {
    final buffer = StringBuffer();
    
    buffer.writeln('Country Breakdown Report');
    buffer.writeln('Total Countries,${breakdown.totalCountries}');
    buffer.writeln('Total Hours,${breakdown.totalHours}');
    buffer.writeln('Total Entries,${breakdown.totalEntries}');
    buffer.writeln('');
    
    buffer.writeln('Country Details');
    buffer.writeln('Rank,Country,Hours,Entries,Active Users,Percentage,Avg Hours/User,Avg Entries/User,Languages');
    for (final country in breakdown.countries) {
      buffer.writeln('${country.rank},${country.country},${country.totalHours},${country.totalEntries},${country.activeUsers},${country.percentage}%,${country.averageHoursPerUser},${country.averageEntriesPerUser},"${country.uniqueLanguages.join(", ")}"');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromLanguageDistribution(LanguageDistribution distribution) {
    final buffer = StringBuffer();
    
    buffer.writeln('Language Distribution Report');
    buffer.writeln('Total Languages,${distribution.totalLanguages}');
    buffer.writeln('Total Hours,${distribution.totalHours}');
    buffer.writeln('Total Entries,${distribution.totalEntries}');
    buffer.writeln('');
    
    buffer.writeln('Language Details');
    buffer.writeln('Rank,Language,Hours,Entries,Active Users,Percentage,Avg Hours/User,Avg Entries/User,Countries');
    for (final lang in distribution.languages) {
      buffer.writeln('${lang.rank},${lang.language},${lang.totalHours},${lang.totalEntries},${lang.activeUsers},${lang.percentage}%,${lang.averageHoursPerUser},${lang.averageEntriesPerUser},"${lang.countries.join(", ")}"');
    }
    
    return buffer.toString();
  }

  // Placeholder para Excel (requeriría el paquete excel)
  static String _generateExcelFromSummary(RegionalSummary summary) {
    // Por ahora retornamos CSV, pero se puede implementar Excel con el paquete 'excel'
    return _generateCSVFromSummary(summary);
  }

  static String _generateExcelFromComparison(RegionalComparison comparison) {
    return _generateCSVFromComparison(comparison);
  }

  static String _generateExcelFromCountryBreakdown(CountryBreakdown breakdown) {
    return _generateCSVFromCountryBreakdown(breakdown);
  }

  static String _generateExcelFromLanguageDistribution(LanguageDistribution distribution) {
    return _generateCSVFromLanguageDistribution(distribution);
  }

  // Placeholder para PDF (requeriría el paquete pdf)
  static String _generatePDFFromSummary(RegionalSummary summary) {
    // Por ahora retornamos CSV, pero se puede implementar PDF con el paquete 'pdf'
    return _generateCSVFromSummary(summary);
  }

  static String _generatePDFFromComparison(RegionalComparison comparison) {
    return _generateCSVFromComparison(comparison);
  }

  static String _generatePDFFromCountryBreakdown(CountryBreakdown breakdown) {
    return _generateCSVFromCountryBreakdown(breakdown);
  }

  static String _generatePDFFromLanguageDistribution(LanguageDistribution distribution) {
    return _generateCSVFromLanguageDistribution(distribution);
  }

  static Future<File> _saveToFile(String content, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    return file;
  }

  // Método público para guardar archivos
  static Future<File> saveToFile(String content, String fileName) async {
    return _saveToFile(content, fileName);
  }

  static Future<void> shareReport(String filePath, {String? subject}) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)], 
        subject: subject ?? 'Report Export',
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100), // Requerido para iOS
      );
    } catch (e) {
      throw Exception('Error sharing report: $e');
    }
  }
}