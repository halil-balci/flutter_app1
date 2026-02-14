import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/calculation_result.dart';

class ExportService {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');

  Future<String> exportToCsv(List<CalculationResult> results) async {
    if (results.isEmpty) throw Exception('No data to export');

    List<List<dynamic>> rows = [];
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

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${directory.path}/profit_calculations_$timestamp.csv';
    await File(path).writeAsString(csv);
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
              pw.Text(
                title ?? 'Profit Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Date: ${_dateFormat.format(result.timestamp)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
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
                      '${_currencyFormat.format(result.netProfit)} TL',
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
                  '${_currencyFormat.format(result.totalRevenue)} TL',
                ],
                [
                  'Total Costs',
                  '${_currencyFormat.format(result.totalCosts)} TL',
                ],
                [
                  'Profit Margin',
                  '${_currencyFormat.format(result.profitMargin)}%',
                ],
              ]),
              pw.SizedBox(height: 20),
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
                  '${_currencyFormat.format(result.breakdown['salePrice'] ?? 0)} TL',
                ],
                [
                  'Purchase Price',
                  '${_currencyFormat.format(result.breakdown['purchasePrice'] ?? 0)} TL',
                ],
                [
                  'Shipping Cost',
                  '${_currencyFormat.format(result.breakdown['shippingCost'] ?? 0)} TL',
                ],
                [
                  'Commission',
                  '${_currencyFormat.format(result.breakdown['commission'] ?? 0)} TL',
                ],
                [
                  'Other Expenses',
                  '${_currencyFormat.format(result.breakdown['otherExpenses'] ?? 0)} TL',
                ],
              ]),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${directory.path}/profit_report_$timestamp.pdf';
    await File(path).writeAsBytes(await pdf.save());
    return path;
  }

  pw.Widget _buildTable(List<List<String>> data) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: data
          .map(
            (row) => pw.TableRow(
              children: row
                  .map(
                    (cell) => pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(cell),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  Future<void> shareFile(String filePath, {String? subject}) async {
    final file = XFile(filePath);
    await Share.shareXFiles([
      file,
    ], subject: subject ?? 'Profit Calculation Report');
  }
}
