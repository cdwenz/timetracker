// lib/services/export_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/regional_reports_models.dart';
import '../l10n/app_localizations.dart';

enum ExportFormat { pdf, excel, csv }

class ExportService {
  static Future<String> exportRegionalSummary(
    RegionalSummary summary,
    ExportFormat format,
    AppLocalizations localizations, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'regional_summary_${summary.regionName}_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromSummary(summary, localizations);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          // Para Excel, podríamos usar el paquete excel
          content = _generateExcelFromSummary(summary, localizations);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          // Para PDF, podríamos usar el paquete pdf
          content = await _generatePDFFromSummary(summary, localizations);
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
    ExportFormat format,
    AppLocalizations localizations, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'regional_comparison_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromComparison(comparison, localizations);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          content = _generateExcelFromComparison(comparison, localizations);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          content = await _generatePDFFromComparison(comparison, localizations);
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
    ExportFormat format,
    AppLocalizations localizations, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'country_breakdown_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromCountryBreakdown(breakdown, localizations);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          content = _generateExcelFromCountryBreakdown(breakdown, localizations);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          content = await _generatePDFFromCountryBreakdown(breakdown, localizations);
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
    ExportFormat format,
    AppLocalizations localizations, {
    bool includeCharts = true,
    bool includeRawData = true,
    bool includeSummary = true,
  }) async {
    try {
      String content = '';
      String fileName = 'language_distribution_${DateTime.now().millisecondsSinceEpoch}';
      
      switch (format) {
        case ExportFormat.csv:
          content = _generateCSVFromLanguageDistribution(distribution, localizations);
          fileName += '.csv';
          break;
        case ExportFormat.excel:
          content = _generateExcelFromLanguageDistribution(distribution, localizations);
          fileName += '.xlsx';
          break;
        case ExportFormat.pdf:
          content = await _generatePDFFromLanguageDistribution(distribution, localizations);
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
  static String _generateCSVFromSummary(RegionalSummary summary, AppLocalizations localizations) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln(localizations.regionalSummaryReport);
    buffer.writeln('${localizations.region},${summary.regionName}');
    buffer.writeln('${localizations.totalHours},${_formatNumber(summary.totalHours)}');
    buffer.writeln('${localizations.totalEntries},${summary.totalEntries}');
    buffer.writeln('${localizations.activeUsers},${summary.activeUsers}');
    buffer.writeln('');
    
    // Top Countries
    buffer.writeln(localizations.topCountriesLabel);
    buffer.writeln('${localizations.country},${localizations.hours},${localizations.percentage}');
    for (final country in summary.topCountries) {
      buffer.writeln('${country.country},${_formatNumber(country.totalHours)},${_formatPercentage(country.percentage)}');
    }
    buffer.writeln('');
    
    // Language Breakdown
    buffer.writeln(localizations.languageBreakdownLabel);
    buffer.writeln('${localizations.language},${localizations.hours},${localizations.entries},${localizations.percentage}');
    for (final lang in summary.languageBreakdown) {
      buffer.writeln('${lang.language},${_formatNumber(lang.totalHours)},${lang.totalEntries},${_formatPercentage(lang.percentage)}');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromComparison(RegionalComparison comparison, AppLocalizations localizations) {
    final buffer = StringBuffer();
    
    buffer.writeln(localizations.regionalComparisonReport);
    buffer.writeln('${localizations.totalRegions},${comparison.summary.totalRegions}');
    buffer.writeln('${localizations.totalHours},${_formatNumber(comparison.summary.totalHours)}');
    buffer.writeln('${localizations.averageHoursPerRegion},${_formatNumber(comparison.summary.averageHoursPerRegion)}');
    buffer.writeln('');
    
    buffer.writeln(localizations.regionalDataLabel);
    buffer.writeln('${localizations.region},${localizations.hours},${localizations.entries},${localizations.activeUsers},${localizations.avgHoursPerUser},${localizations.topCountry},${localizations.topLanguage}');
    
    
    if (comparison.regions.isEmpty) {
      buffer.writeln(localizations.noRegionalDataAvailable);
    } else {
      for (final region in comparison.regions) {
        buffer.writeln('${region.regionName},${_formatNumber(region.totalHours)},${region.totalEntries},${region.activeUsers},${_formatNumber(region.avgHoursPerUser)},${region.topCountry},${region.topLanguage}');
      }
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromCountryBreakdown(CountryBreakdown breakdown, AppLocalizations localizations) {
    final buffer = StringBuffer();
    
    buffer.writeln(localizations.countryBreakdownReport);
    buffer.writeln('${localizations.totalCountries},${breakdown.totalCountries}');
    buffer.writeln('${localizations.totalHours},${_formatNumber(breakdown.totalHours)}');
    buffer.writeln('${localizations.totalEntries},${breakdown.totalEntries}');
    buffer.writeln('');
    
    buffer.writeln(localizations.countryDetailsLabel);
    buffer.writeln('${localizations.rank},${localizations.country},${localizations.hours},${localizations.entries},${localizations.activeUsers},${localizations.percentage},${localizations.avgHoursPerUser},${localizations.avgEntriesPerUser},${localizations.languageColumn}');
    for (final country in breakdown.countries) {
      buffer.writeln('${country.rank},${country.country},${_formatNumber(country.totalHours)},${country.totalEntries},${country.activeUsers},${_formatPercentage(country.percentage)},${_formatNumber(country.averageHoursPerUser)},${_formatNumber(country.averageEntriesPerUser)},"${country.uniqueLanguages.join(", ")}"');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromLanguageDistribution(LanguageDistribution distribution, AppLocalizations localizations) {
    final buffer = StringBuffer();
    
    buffer.writeln(localizations.languageDistributionReport);
    buffer.writeln('${localizations.totalLanguages},${distribution.totalLanguages}');
    buffer.writeln('${localizations.totalHours},${_formatNumber(distribution.totalHours)}');
    buffer.writeln('${localizations.totalEntries},${distribution.totalEntries}');
    buffer.writeln('');
    
    buffer.writeln(localizations.languageDetailsLabel);
    buffer.writeln('${localizations.rank},${localizations.language},${localizations.hours},${localizations.entries},${localizations.activeUsers},${localizations.percentage},${localizations.avgHoursPerUser},${localizations.avgEntriesPerUser},${localizations.countryColumn}');
    for (final lang in distribution.languages) {
      buffer.writeln('${lang.rank},${lang.language},${_formatNumber(lang.totalHours)},${lang.totalEntries},${lang.activeUsers},${_formatPercentage(lang.percentage)},${_formatNumber(lang.averageHoursPerUser)},${_formatNumber(lang.averageEntriesPerUser)},"${lang.countries.join(", ")}"');
    }
    
    return buffer.toString();
  }

  // Generación de archivos Excel reales
  static String _generateExcelFromSummary(RegionalSummary summary, AppLocalizations localizations) {
    return generateRealExcel(localizations.regionalSummaryReport, [
      [localizations.region, summary.regionName],
      [localizations.totalHours, _formatNumber(summary.totalHours)],
      [localizations.totalEntries, summary.totalEntries.toString()],
      [localizations.activeUsers, summary.activeUsers.toString()],
      [],
      [localizations.topCountries, '', ''],
      [localizations.country, localizations.hours, localizations.percentage],
      ...summary.topCountries.map((c) => [c.country, _formatNumber(c.totalHours), _formatPercentage(c.percentage)]),
      [],
      [localizations.languageBreakdown, '', '', ''],
      [localizations.language, localizations.hours, localizations.entries, localizations.percentage],
      ...summary.languageBreakdown.map((l) => [l.language, _formatNumber(l.totalHours), l.totalEntries.toString(), _formatPercentage(l.percentage)]),
    ]);
  }

  static String _generateExcelFromComparison(RegionalComparison comparison, AppLocalizations localizations) {
    final dataRows = comparison.regions.isEmpty 
      ? [[localizations.noRegionalDataAvailable, '', '', '', '', '', '']]
      : comparison.regions.map((r) => [r.regionName, _formatNumber(r.totalHours), r.totalEntries.toString(), r.activeUsers.toString(), _formatNumber(r.avgHoursPerUser), r.topCountry, r.topLanguage]).toList();
    
    return generateRealExcel(localizations.regionalComparisonReport, [
      [localizations.totalRegions, comparison.summary.totalRegions.toString()],
      [localizations.totalHours, _formatNumber(comparison.summary.totalHours)],
      [localizations.averageHoursPerRegion, _formatNumber(comparison.summary.averageHoursPerRegion)],
      [],
      [localizations.regionalDataLabel, '', '', '', '', '', ''],
      [localizations.region, localizations.hours, localizations.entries, localizations.activeUsers, localizations.avgHoursPerUser, localizations.topCountry, localizations.topLanguage],
      ...dataRows,
    ]);
  }

  static String _generateExcelFromCountryBreakdown(CountryBreakdown breakdown, AppLocalizations localizations) {
    return generateRealExcel(localizations.countryBreakdownReport, [
      [localizations.totalCountries, breakdown.totalCountries.toString()],
      [localizations.totalHours, _formatNumber(breakdown.totalHours)],
      [localizations.totalEntries, breakdown.totalEntries.toString()],
      [],
      [localizations.countryDetailsLabel, '', '', '', '', '', '', '', ''],
      [localizations.rank, localizations.country, localizations.hours, localizations.entries, localizations.activeUsers, localizations.percentage, localizations.avgHoursPerUser, localizations.avgEntriesPerUser, localizations.languageColumn],
      ...breakdown.countries.map((c) => [c.rank.toString(), c.country, _formatNumber(c.totalHours), c.totalEntries.toString(), c.activeUsers.toString(), _formatPercentage(c.percentage), _formatNumber(c.averageHoursPerUser), _formatNumber(c.averageEntriesPerUser), c.uniqueLanguages.join(', ')]),
    ]);
  }

  static String _generateExcelFromLanguageDistribution(LanguageDistribution distribution, AppLocalizations localizations) {
    return generateRealExcel(localizations.languageDistributionReport, [
      [localizations.totalLanguages, distribution.totalLanguages.toString()],
      [localizations.totalHours, _formatNumber(distribution.totalHours)],
      [localizations.totalEntries, distribution.totalEntries.toString()],
      [],
      [localizations.languageDetailsLabel, '', '', '', '', '', '', '', ''],
      [localizations.rank, localizations.language, localizations.hours, localizations.entries, localizations.activeUsers, localizations.percentage, localizations.avgHoursPerUser, localizations.avgEntriesPerUser, localizations.countryColumn],
      ...distribution.languages.map((l) => [l.rank.toString(), l.language, _formatNumber(l.totalHours), l.totalEntries.toString(), l.activeUsers.toString(), _formatPercentage(l.percentage), _formatNumber(l.averageHoursPerUser), _formatNumber(l.averageEntriesPerUser), l.countries.join(', ')]),
    ]);
  }

  // Generación de archivos PDF reales
  static Future<String> _generatePDFFromSummary(RegionalSummary summary, AppLocalizations localizations) async {
    return await generateRealPDF(localizations.regionalSummaryReport, [
      '${localizations.region}: ${summary.regionName}',
      '${localizations.totalHours}: ${_formatNumber(summary.totalHours)}',
      '${localizations.totalEntries}: ${summary.totalEntries}',
      '${localizations.activeUsers}: ${summary.activeUsers}',
      '',
      '${localizations.topCountriesTitle}',
      ...summary.topCountries.map((c) => '• ${c.country}: ${_formatNumber(c.totalHours)} ${localizations.hours} (${_formatPercentage(c.percentage)})'),
      '',
      '${localizations.languageBreakdown}:',
      ...summary.languageBreakdown.map((l) => '• ${l.language}: ${_formatNumber(l.totalHours)} ${localizations.hours}, ${l.totalEntries} ${localizations.entries} (${_formatPercentage(l.percentage)})'),
    ]);
  }

  static Future<String> _generatePDFFromComparison(RegionalComparison comparison, AppLocalizations localizations) async {
    final regionalDataItems = comparison.regions.isEmpty 
      ? ['• ${localizations.noRegionalDataAvailable}']
      : comparison.regions.map((r) => '• ${r.regionName}: ${_formatNumber(r.totalHours)} ${localizations.hours}, ${r.totalEntries} ${localizations.entries}, ${r.activeUsers} ${localizations.users} (${_formatNumber(r.avgHoursPerUser)} ${localizations.hrsPerUser})').toList();
    
    return await generateRealPDF(localizations.regionalComparisonReport, [
      '${localizations.totalRegions}: ${comparison.summary.totalRegions}',
      '${localizations.totalHours}: ${_formatNumber(comparison.summary.totalHours)}',
      '${localizations.averageHoursPerRegion}: ${_formatNumber(comparison.summary.averageHoursPerRegion)}',
      '',
      '${localizations.regionalDataLabel}:',
      ...regionalDataItems,
    ]);
  }

  static Future<String> _generatePDFFromCountryBreakdown(CountryBreakdown breakdown, AppLocalizations localizations) async {
    return await generateRealPDF(localizations.countryBreakdownReport, [
      '${localizations.totalCountries}: ${breakdown.totalCountries}',
      '${localizations.totalHours}: ${_formatNumber(breakdown.totalHours)}',
      '${localizations.totalEntries}: ${breakdown.totalEntries}',
      '',
      '${localizations.countryDetailsLabel}:',
      ...breakdown.countries.map((c) => '${c.rank}. ${c.country}: ${_formatNumber(c.totalHours)} ${localizations.hours}, ${c.totalEntries} ${localizations.entries} (${_formatPercentage(c.percentage)})'),
    ]);
  }

  static Future<String> _generatePDFFromLanguageDistribution(LanguageDistribution distribution, AppLocalizations localizations) async {
    return await generateRealPDF(localizations.languageDistributionReport, [
      '${localizations.totalLanguages}: ${distribution.totalLanguages}',
      '${localizations.totalHours}: ${_formatNumber(distribution.totalHours)}',
      '${localizations.totalEntries}: ${distribution.totalEntries}',
      '',
      '${localizations.languageDetailsLabel}:',
      ...distribution.languages.map((l) => '${l.rank}. ${l.language}: ${_formatNumber(l.totalHours)} ${localizations.hours}, ${l.totalEntries} ${localizations.entries} (${_formatPercentage(l.percentage)})'),
    ]);
  }

  static Future<File> _saveToFile(String content, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    if (fileName.endsWith('.xlsx') || fileName.endsWith('.pdf')) {
      // Para archivos binarios, content contiene la ruta del archivo ya creado
      return File(content);
    } else {
      // Para CSV, escribir como string
      await file.writeAsString(content);
      return file;
    }
  }

  // Método público para guardar archivos
  static Future<File> saveToFile(String content, String fileName) async {
    return _saveToFile(content, fileName);
  }

  // Helper para formatear porcentajes sin decimales
  static String _formatPercentage(double percentage) {
    return '${percentage.round()}%';
  }

  // Helper para formatear números decimales de manera limpia
  static String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(1);
    }
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

  // Método para generar archivos Excel reales
  static String generateRealExcel(String sheetName, List<List<dynamic>> data) {
    try {
      final excel = Excel.createExcel();
      final sheet = excel[sheetName];
      
      // Eliminar la hoja por defecto si existe
      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }
      
      // Agregar datos
      for (int i = 0; i < data.length; i++) {
        final row = data[i];
        for (int j = 0; j < row.length; j++) {
          final cellValue = row[j];
          final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i));
          
          if (cellValue == null || cellValue == '') {
            cell.value = TextCellValue('');
          } else if (cellValue is int) {
            cell.value = IntCellValue(cellValue);
          } else if (cellValue is double) {
            cell.value = DoubleCellValue(cellValue);
          } else if (cellValue is bool) {
            cell.value = BoolCellValue(cellValue);
          } else {
            cell.value = TextCellValue(cellValue.toString());
          }
        }
      }
      
      return saveExcelToTempFile(excel, '$sheetName.xlsx');
    } catch (e) {
      throw Exception('Error generating Excel: $e');
    }
  }

  // Método para generar archivos PDF reales con diseño profesional
  static Future<String> generateRealPDF(String title, List<String> content) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.Container(
                    height: 2,
                    width: double.infinity,
                    color: PdfColors.blue200,
                    margin: const pw.EdgeInsets.only(top: 8, bottom: 16),
                  ),
                ],
              ),
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            );
          },
          build: (pw.Context context) {
            return _buildPDFContent(content);
          },
        ),
      );
      
      return await savePDFToTempFile(pdf, '$title.pdf');
    } catch (e) {
      throw Exception('Error generating PDF: $e');
    }
  }

  // Construir contenido del PDF con mejor formato
  static List<pw.Widget> _buildPDFContent(List<String> content) {
    final List<pw.Widget> widgets = [];
    String? currentSection;
    List<String> sectionItems = [];
    
    for (final line in content) {
      if (line.isEmpty) {
        if (sectionItems.isNotEmpty && currentSection != null) {
          widgets.add(_buildPDFSection(currentSection, sectionItems));
          sectionItems = [];
          currentSection = null;
        }
        continue;
      }
      
      if (line.startsWith('•')) {
        // Es un elemento de lista
        sectionItems.add(line);
      } else if (line.contains(':') && !line.startsWith('•') && !line.endsWith(':')) {
        // Es una línea de información clave-valor (pero NO un título de sección que termina en :)
        if (currentSection != null && sectionItems.isNotEmpty) {
          widgets.add(_buildPDFSection(currentSection, sectionItems));
          sectionItems = [];
        }
        widgets.add(_buildKeyValueRow(line));
        currentSection = null;
      } else {
        // Es un título de sección (incluye líneas que terminan en :)
        if (currentSection != null && sectionItems.isNotEmpty) {
          widgets.add(_buildPDFSection(currentSection, sectionItems));
          sectionItems = [];
        }
        currentSection = line;
      }
    }
    
    // Agregar la última sección si existe
    if (currentSection != null && sectionItems.isNotEmpty) {
      widgets.add(_buildPDFSection(currentSection, sectionItems));
    }
    
    return widgets;
  }

  // Construir una sección del PDF
  static pw.Widget _buildPDFSection(String title, List<String> items) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          ...items.map((item) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 8,
                  height: 8,
                  margin: const pw.EdgeInsets.only(right: 8, top: 4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue400,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    item.startsWith('• ') ? item.substring(2) : item,
                    style: const pw.TextStyle(fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // Construir fila clave-valor
  static pw.Widget _buildKeyValueRow(String line) {
    final parts = line.split(':');
    if (parts.length != 2) {
      return pw.Text(line, style: const pw.TextStyle(fontSize: 12));
    }
    
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '${parts[0].trim()}:',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              parts[1].trim(),
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Guardar Excel en archivo temporal
  static String saveExcelToTempFile(Excel excel, String fileName) {
    try {
      final bytes = excel.encode();
      final directory = Directory.systemTemp;
      final file = File('${directory.path}/$fileName');
      file.writeAsBytesSync(bytes!);
      return file.path;
    } catch (e) {
      throw Exception('Error saving Excel file: $e');
    }
  }

  // Guardar PDF en archivo temporal
  static Future<String> savePDFToTempFile(pw.Document pdf, String fileName) async {
    try {
      final directory = Directory.systemTemp;
      final file = File('${directory.path}/$fileName');
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      throw Exception('Error saving PDF file: $e');
    }
  }
}