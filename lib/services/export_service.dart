// lib/services/export_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
          content = await _generatePDFFromSummary(summary);
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
          content = await _generatePDFFromComparison(comparison);
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
          content = await _generatePDFFromCountryBreakdown(breakdown);
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
          content = await _generatePDFFromLanguageDistribution(distribution);
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
    buffer.writeln('Total Hours,${_formatNumber(summary.totalHours)}');
    buffer.writeln('Total Entries,${summary.totalEntries}');
    buffer.writeln('Active Users,${summary.activeUsers}');
    buffer.writeln('');
    
    // Top Countries
    buffer.writeln('Top Countries');
    buffer.writeln('Country,Hours,Percentage');
    for (final country in summary.topCountries) {
      buffer.writeln('${country.country},${_formatNumber(country.totalHours)},${_formatPercentage(country.percentage)}');
    }
    buffer.writeln('');
    
    // Language Breakdown
    buffer.writeln('Language Breakdown');
    buffer.writeln('Language,Hours,Entries,Percentage');
    for (final lang in summary.languageBreakdown) {
      buffer.writeln('${lang.language},${_formatNumber(lang.totalHours)},${lang.totalEntries},${_formatPercentage(lang.percentage)}');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromComparison(RegionalComparison comparison) {
    final buffer = StringBuffer();
    
    buffer.writeln('Regional Comparison Report');
    buffer.writeln('Total Regions,${comparison.summary.totalRegions}');
    buffer.writeln('Total Hours,${_formatNumber(comparison.summary.totalHours)}');
    buffer.writeln('Average Hours per Region,${_formatNumber(comparison.summary.averageHoursPerRegion)}');
    buffer.writeln('');
    
    buffer.writeln('Regional Data');
    buffer.writeln('Region,Hours,Entries,Active Users,Avg Hours/User,Top Country,Top Language');
    
    
    if (comparison.regions.isEmpty) {
      buffer.writeln('No regional data available - The regions list is empty');
    } else {
      for (final region in comparison.regions) {
        buffer.writeln('${region.regionName},${_formatNumber(region.totalHours)},${region.totalEntries},${region.activeUsers},${_formatNumber(region.avgHoursPerUser)},${region.topCountry},${region.topLanguage}');
      }
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromCountryBreakdown(CountryBreakdown breakdown) {
    final buffer = StringBuffer();
    
    buffer.writeln('Country Breakdown Report');
    buffer.writeln('Total Countries,${breakdown.totalCountries}');
    buffer.writeln('Total Hours,${_formatNumber(breakdown.totalHours)}');
    buffer.writeln('Total Entries,${breakdown.totalEntries}');
    buffer.writeln('');
    
    buffer.writeln('Country Details');
    buffer.writeln('Rank,Country,Hours,Entries,Active Users,Percentage,Avg Hours/User,Avg Entries/User,Languages');
    for (final country in breakdown.countries) {
      buffer.writeln('${country.rank},${country.country},${_formatNumber(country.totalHours)},${country.totalEntries},${country.activeUsers},${_formatPercentage(country.percentage)},${_formatNumber(country.averageHoursPerUser)},${_formatNumber(country.averageEntriesPerUser)},"${country.uniqueLanguages.join(", ")}"');
    }
    
    return buffer.toString();
  }

  static String _generateCSVFromLanguageDistribution(LanguageDistribution distribution) {
    final buffer = StringBuffer();
    
    buffer.writeln('Language Distribution Report');
    buffer.writeln('Total Languages,${distribution.totalLanguages}');
    buffer.writeln('Total Hours,${_formatNumber(distribution.totalHours)}');
    buffer.writeln('Total Entries,${distribution.totalEntries}');
    buffer.writeln('');
    
    buffer.writeln('Language Details');
    buffer.writeln('Rank,Language,Hours,Entries,Active Users,Percentage,Avg Hours/User,Avg Entries/User,Countries');
    for (final lang in distribution.languages) {
      buffer.writeln('${lang.rank},${lang.language},${_formatNumber(lang.totalHours)},${lang.totalEntries},${lang.activeUsers},${_formatPercentage(lang.percentage)},${_formatNumber(lang.averageHoursPerUser)},${_formatNumber(lang.averageEntriesPerUser)},"${lang.countries.join(", ")}"');
    }
    
    return buffer.toString();
  }

  // Generación de archivos Excel reales
  static String _generateExcelFromSummary(RegionalSummary summary) {
    return generateRealExcel('Regional Summary', [
      ['Region', summary.regionName],
      ['Total Hours', _formatNumber(summary.totalHours)],
      ['Total Entries', summary.totalEntries.toString()],
      ['Active Users', summary.activeUsers.toString()],
      [],
      ['Top Countries', '', ''],
      ['Country', 'Hours', 'Percentage'],
      ...summary.topCountries.map((c) => [c.country, _formatNumber(c.totalHours), _formatPercentage(c.percentage)]),
      [],
      ['Language Breakdown', '', '', ''],
      ['Language', 'Hours', 'Entries', 'Percentage'],
      ...summary.languageBreakdown.map((l) => [l.language, _formatNumber(l.totalHours), l.totalEntries.toString(), _formatPercentage(l.percentage)]),
    ]);
  }

  static String _generateExcelFromComparison(RegionalComparison comparison) {
    final dataRows = comparison.regions.isEmpty 
      ? [['No regional data available', '', '', '', '', '', '']]
      : comparison.regions.map((r) => [r.regionName, _formatNumber(r.totalHours), r.totalEntries.toString(), r.activeUsers.toString(), _formatNumber(r.avgHoursPerUser), r.topCountry, r.topLanguage]).toList();
    
    return generateRealExcel('Regional Comparison', [
      ['Total Regions', comparison.summary.totalRegions.toString()],
      ['Total Hours', _formatNumber(comparison.summary.totalHours)],
      ['Average Hours per Region', _formatNumber(comparison.summary.averageHoursPerRegion)],
      [],
      ['Regional Data', '', '', '', '', '', ''],
      ['Region', 'Hours', 'Entries', 'Active Users', 'Avg Hours/User', 'Top Country', 'Top Language'],
      ...dataRows,
    ]);
  }

  static String _generateExcelFromCountryBreakdown(CountryBreakdown breakdown) {
    return generateRealExcel('Country Breakdown', [
      ['Total Countries', breakdown.totalCountries.toString()],
      ['Total Hours', _formatNumber(breakdown.totalHours)],
      ['Total Entries', breakdown.totalEntries.toString()],
      [],
      ['Country Details', '', '', '', '', '', '', '', ''],
      ['Rank', 'Country', 'Hours', 'Entries', 'Active Users', 'Percentage', 'Avg Hours/User', 'Avg Entries/User', 'Languages'],
      ...breakdown.countries.map((c) => [c.rank.toString(), c.country, _formatNumber(c.totalHours), c.totalEntries.toString(), c.activeUsers.toString(), _formatPercentage(c.percentage), _formatNumber(c.averageHoursPerUser), _formatNumber(c.averageEntriesPerUser), c.uniqueLanguages.join(', ')]),
    ]);
  }

  static String _generateExcelFromLanguageDistribution(LanguageDistribution distribution) {
    return generateRealExcel('Language Distribution', [
      ['Total Languages', distribution.totalLanguages.toString()],
      ['Total Hours', _formatNumber(distribution.totalHours)],
      ['Total Entries', distribution.totalEntries.toString()],
      [],
      ['Language Details', '', '', '', '', '', '', '', ''],
      ['Rank', 'Language', 'Hours', 'Entries', 'Active Users', 'Percentage', 'Avg Hours/User', 'Avg Entries/User', 'Countries'],
      ...distribution.languages.map((l) => [l.rank.toString(), l.language, _formatNumber(l.totalHours), l.totalEntries.toString(), l.activeUsers.toString(), _formatPercentage(l.percentage), _formatNumber(l.averageHoursPerUser), _formatNumber(l.averageEntriesPerUser), l.countries.join(', ')]),
    ]);
  }

  // Generación de archivos PDF reales
  static Future<String> _generatePDFFromSummary(RegionalSummary summary) async {
    return await generateRealPDF('Regional Summary Report', [
      'Region: ${summary.regionName}',
      'Total Hours: ${_formatNumber(summary.totalHours)}',
      'Total Entries: ${summary.totalEntries}',
      'Active Users: ${summary.activeUsers}',
      '',
      'TOP COUNTRIES:',
      ...summary.topCountries.map((c) => '• ${c.country}: ${_formatNumber(c.totalHours)} hours (${_formatPercentage(c.percentage)})'),
      '',
      'LANGUAGE BREAKDOWN:',
      ...summary.languageBreakdown.map((l) => '• ${l.language}: ${_formatNumber(l.totalHours)} hours, ${l.totalEntries} entries (${_formatPercentage(l.percentage)})'),
    ]);
  }

  static Future<String> _generatePDFFromComparison(RegionalComparison comparison) async {
    final regionalDataItems = comparison.regions.isEmpty 
      ? ['• No regional data available']
      : comparison.regions.map((r) => '• ${r.regionName}: ${_formatNumber(r.totalHours)} hours, ${r.totalEntries} entries, ${r.activeUsers} users (${_formatNumber(r.avgHoursPerUser)} hours/user)').toList();
    
    return await generateRealPDF('Regional Comparison Report', [
      'Total Regions: ${comparison.summary.totalRegions}',
      'Total Hours: ${_formatNumber(comparison.summary.totalHours)}',
      'Average Hours per Region: ${_formatNumber(comparison.summary.averageHoursPerRegion)}',
      '',
      'REGIONAL DATA:',
      ...regionalDataItems,
    ]);
  }

  static Future<String> _generatePDFFromCountryBreakdown(CountryBreakdown breakdown) async {
    return await generateRealPDF('Country Breakdown Report', [
      'Total Countries: ${breakdown.totalCountries}',
      'Total Hours: ${_formatNumber(breakdown.totalHours)}',
      'Total Entries: ${breakdown.totalEntries}',
      '',
      'COUNTRY DETAILS:',
      ...breakdown.countries.map((c) => '${c.rank}. ${c.country}: ${_formatNumber(c.totalHours)} hours, ${c.totalEntries} entries (${_formatPercentage(c.percentage)})'),
    ]);
  }

  static Future<String> _generatePDFFromLanguageDistribution(LanguageDistribution distribution) async {
    return await generateRealPDF('Language Distribution Report', [
      'Total Languages: ${distribution.totalLanguages}',
      'Total Hours: ${_formatNumber(distribution.totalHours)}',
      'Total Entries: ${distribution.totalEntries}',
      '',
      'LANGUAGE DETAILS:',
      ...distribution.languages.map((l) => '${l.rank}. ${l.language}: ${_formatNumber(l.totalHours)} hours, ${l.totalEntries} entries (${_formatPercentage(l.percentage)})'),
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