import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../generated/app_localizations.dart';
import '../models/calculation_result.dart';
import '../providers/calculation_provider.dart';

class ResultCard extends StatefulWidget {
  final CalculationResult result;

  const ResultCard({super.key, required this.result});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool _showBreakdown = false;
  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<CalculationProvider>();
    final isProfitable = widget.result.isProfitable;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Net Profit Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isProfitable ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.netProfit,
                    style: TextStyle(
                      fontSize: 16,
                      color: isProfitable ? Colors.green[900] : Colors.red[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₺ ${_currencyFormat.format(widget.result.netProfit)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isProfitable ? Colors.green[900] : Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.totalRevenue}: ₺ ${_currencyFormat.format(widget.result.totalRevenue)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isProfitable ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                  Text(
                    '${l10n.totalCosts}: ₺ ${_currencyFormat.format(widget.result.totalCosts)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isProfitable ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Breakdown Toggle
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showBreakdown = !_showBreakdown;
                });
              },
              icon: Icon(
                _showBreakdown ? Icons.expand_less : Icons.expand_more,
              ),
              label: Text(l10n.breakdown),
            ),

            // Breakdown Details
            if (_showBreakdown) ...[
              const Divider(),
              _buildBreakdownItem(
                l10n.salePrice,
                widget.result.breakdown['salePrice'] ?? 0,
                Colors.green,
              ),
              _buildBreakdownSubItem(
                '  ${l10n.vatRate}',
                widget.result.breakdown['salePriceVat'] ?? 0,
                Colors.green[300]!,
              ),
              const SizedBox(height: 8),
              _buildBreakdownItem(
                l10n.purchasePrice,
                widget.result.breakdown['purchasePrice'] ?? 0,
                Colors.red,
              ),
              _buildBreakdownSubItem(
                '  ${l10n.vatRate}',
                widget.result.breakdown['purchasePriceVat'] ?? 0,
                Colors.red[300]!,
              ),
              const SizedBox(height: 8),
              _buildBreakdownItem(
                l10n.shippingCost,
                widget.result.breakdown['shippingCost'] ?? 0,
                Colors.red,
              ),
              _buildBreakdownSubItem(
                '  ${l10n.vatRate}',
                widget.result.breakdown['shippingVat'] ?? 0,
                Colors.red[300]!,
              ),
              const SizedBox(height: 8),
              _buildBreakdownItem(
                l10n.commission,
                widget.result.breakdown['commission'] ?? 0,
                Colors.red,
              ),
              _buildBreakdownSubItem(
                '  ${l10n.vatRate}',
                widget.result.breakdown['commissionVat'] ?? 0,
                Colors.red[300]!,
              ),
              const SizedBox(height: 8),
              _buildBreakdownItem(
                l10n.otherExpenses,
                widget.result.breakdown['otherExpenses'] ?? 0,
                Colors.red,
              ),
              _buildBreakdownSubItem(
                '  ${l10n.vatRate}',
                widget.result.breakdown['otherExpensesVat'] ?? 0,
                Colors.red[300]!,
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            await provider.saveCalculation();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.calculationSaved)),
                              );
                            }
                          },
                    icon: const Icon(Icons.save),
                    label: Text(l10n.save),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final path = await provider.exportToPdf(
                              widget.result,
                              title: l10n.profitReport,
                            );
                            if (path != null && context.mounted) {
                              await provider.shareFile(
                                path,
                                subject: l10n.profitReport,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.exportSuccess)),
                                );
                              }
                            }
                          },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: Text(l10n.exportPdf),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        Text(
          '₺ ${_currencyFormat.format(value)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownSubItem(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: color)),
        Text(
          '₺ ${_currencyFormat.format(value)}',
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
