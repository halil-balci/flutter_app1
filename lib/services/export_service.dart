import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/calculation_result.dart';

class ExportService {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');

  Future<String> exportToCsv(List<CalculationResult> results) async {
    if (results.isEmpty) {
      throw Exception('No data to export');
    }

    // Prepare CSV data
    List<List<dynamic>> rows = [];

    // Headers
    rows.add([
      'Date',
      'Net Profit',
      'Total Revenue',
      'Total Costs',
      'Sale Price',
      'Purchase Price',
      'Shipping Cost',
      'Commission',
      'Other Expenses',
    ]);

    // Data rows
    for (final result in results) {
      rows.add([
        _dateFormat.format(result.timestamp),
        _currencyFormat.format(result.netProfit),
        _currencyFormat.format(result.totalRevenue),
        _currencyFormat.format(result.totalCosts),
        _currencyFormat.format(result.breakdown['salePrice'] ?? 0),
        _currencyFormat.format(result.breakdown['purchasePrice'] ?? 0),
        _currencyFormat.format(result.breakdown['shippingCost'] ?? 0),
        _currencyFormat.format(result.breakdown['commission'] ?? 0),
        _currencyFormat.format(result.breakdown['otherExpenses'] ?? 0),
      ]);
    }

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(rows);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${directory.path}/profit_calculations_$timestamp.csv';
    final file = File(path);
    await file.writeAsString(csv);

    return path;
  }

  Future<String> exportToPdf(CalculationResult result, {String? title}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Text(
                title ?? 'Profit Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Date
              pw.Text(
                'Date: ${_dateFormat.format(result.timestamp)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),

              // Net Profit Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: result.isProfitable
                      ? PdfColors.green100
                      : PdfColors.red100,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Net Profit',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '${_currencyFormat.format(result.netProfit)} ₺',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: result.isProfitable
                            ? PdfColors.green800
                            : PdfColors.red800,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary Table
              pw.Text(
                'Summary',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildTable([
                [
                  'Total Revenue',
                  '${_currencyFormat.format(result.totalRevenue)} ₺',
                ],
                [
                  'Total Costs',
                  '${_currencyFormat.format(result.totalCosts)} ₺',
                ],
                [
                  'Profit Margin',
                  '${_currencyFormat.format(result.profitMargin)}%',
                ],
              ]),
              pw.SizedBox(height: 20),

              // Breakdown
              pw.Text(
                'Breakdown',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildTable([
                [
                  'Sale Price',
                  '${_currencyFormat.format(result.breakdown['salePrice'] ?? 0)} ₺',
                ],
                [
                  '  - VAT',
                  '${_currencyFormat.format(result.breakdown['salePriceVat'] ?? 0)} ₺',
                ],
                [
                  'Purchase Price',
                  '${_currencyFormat.format(result.breakdown['purchasePrice'] ?? 0)} ₺',
                ],
                [
                  '  - VAT',
                  '${_currencyFormat.format(result.breakdown['purchasePriceVat'] ?? 0)} ₺',
                ],
                [
                  'Shipping Cost',
                  '${_currencyFormat.format(result.breakdown['shippingCost'] ?? 0)} ₺',
                ],
                [
                  '  - VAT',
                  '${_currencyFormat.format(result.breakdown['shippingVat'] ?? 0)} ₺',
                ],
                [
                  'Commission',
                  '${_currencyFormat.format(result.breakdown['commission'] ?? 0)} ₺',
                ],
                [
                  '  - VAT',
                  '${_currencyFormat.format(result.breakdown['commissionVat'] ?? 0)} ₺',
                ],
                [
                  'Other Expenses',
                  '${_currencyFormat.format(result.breakdown['otherExpenses'] ?? 0)} ₺',
                ],
                [
                  '  - VAT',
                  '${_currencyFormat.format(result.breakdown['otherExpensesVat'] ?? 0)} ₺',
                ],
              ]),
            ],
          );
        },
      ),
    );

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${directory.path}/profit_report_$timestamp.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    return path;
  }

  pw.Widget _buildTable(List<List<String>> data) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: data.map((row) {
        return pw.TableRow(
          children: row.map((cell) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(cell),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Future<void> shareFile(String filePath, {String? subject}) async {
    final file = XFile(filePath);
    await Share.shareXFiles([
      file,
    ], subject: subject ?? 'Profit Calculation Report');
  }
}
