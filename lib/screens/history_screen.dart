import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../generated/app_localizations.dart';
import '../providers/calculation_provider.dart';
import '../models/calculation_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalculationProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<CalculationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          if (provider.history.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'export_csv') {
                  final path = await provider.exportHistoryToCsv();
                  if (path != null && context.mounted) {
                    await provider.shareFile(path, subject: l10n.profitReport);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.exportSuccess)),
                      );
                    }
                  }
                } else if (value == 'clear_all') {
                  _showClearHistoryDialog();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'export_csv',
                  child: Row(
                    children: [
                      const Icon(Icons.file_download),
                      const SizedBox(width: 8),
                      Text(l10n.exportCsv),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_sweep),
                      const SizedBox(width: 8),
                      Text(l10n.clearHistory),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noHistory,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => provider.loadHistory(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.history.length,
                itemBuilder: (context, index) {
                  final calculation = provider.history[index];
                  return _buildHistoryItem(calculation, l10n, provider);
                },
              ),
            ),
    );
  }

  Widget _buildHistoryItem(
    CalculationResult result,
    AppLocalizations l10n,
    CalculationProvider provider,
  ) {
    final NumberFormat currencyFormat = NumberFormat('#,##0.00');
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(result.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.delete),
              content: Text(l10n.confirmClearHistory),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.delete),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          provider.deleteCalculation(result.id!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.calculationDeleted)));
        },
        child: InkWell(
          onTap: () => _showDetailsDialog(result, l10n, provider),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profit Indicator
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: result.isProfitable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(result.timestamp),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₺ ${currencyFormat.format(result.netProfit)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: result.isProfitable
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.totalRevenue}: ₺ ${currencyFormat.format(result.totalRevenue)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                // Actions
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () async {
                    final path = await provider.exportToPdf(
                      result,
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
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(
    CalculationResult result,
    AppLocalizations l10n,
    CalculationProvider provider,
  ) {
    final NumberFormat currencyFormat = NumberFormat('#,##0.00');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  l10n.breakdown,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Net Profit
                _buildDetailRow(
                  l10n.netProfit,
                  '₺ ${currencyFormat.format(result.netProfit)}',
                  result.isProfitable ? Colors.green : Colors.red,
                  bold: true,
                ),
                const Divider(height: 24),

                // Revenue
                _buildDetailRow(
                  l10n.totalRevenue,
                  '₺ ${currencyFormat.format(result.totalRevenue)}',
                  Colors.green,
                ),
                const SizedBox(height: 8),

                // Costs
                _buildDetailRow(
                  l10n.totalCosts,
                  '₺ ${currencyFormat.format(result.totalCosts)}',
                  Colors.red,
                ),
                const Divider(height: 24),

                // Breakdown
                _buildDetailRow(
                  l10n.salePrice,
                  '₺ ${currencyFormat.format(result.breakdown['salePrice'] ?? 0)}',
                  Colors.grey[700],
                ),
                _buildDetailRow(
                  '  ${l10n.vatRate}',
                  '₺ ${currencyFormat.format(result.breakdown['salePriceVat'] ?? 0)}',
                  Colors.grey[500],
                  small: true,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.purchasePrice,
                  '₺ ${currencyFormat.format(result.breakdown['purchasePrice'] ?? 0)}',
                  Colors.grey[700],
                ),
                _buildDetailRow(
                  '  ${l10n.vatRate}',
                  '₺ ${currencyFormat.format(result.breakdown['purchasePriceVat'] ?? 0)}',
                  Colors.grey[500],
                  small: true,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.shippingCost,
                  '₺ ${currencyFormat.format(result.breakdown['shippingCost'] ?? 0)}',
                  Colors.grey[700],
                ),
                _buildDetailRow(
                  '  ${l10n.vatRate}',
                  '₺ ${currencyFormat.format(result.breakdown['shippingVat'] ?? 0)}',
                  Colors.grey[500],
                  small: true,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.commission,
                  '₺ ${currencyFormat.format(result.breakdown['commission'] ?? 0)}',
                  Colors.grey[700],
                ),
                _buildDetailRow(
                  '  ${l10n.vatRate}',
                  '₺ ${currencyFormat.format(result.breakdown['commissionVat'] ?? 0)}',
                  Colors.grey[500],
                  small: true,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.otherExpenses,
                  '₺ ${currencyFormat.format(result.breakdown['otherExpenses'] ?? 0)}',
                  Colors.grey[700],
                ),
                _buildDetailRow(
                  '  ${l10n.vatRate}',
                  '₺ ${currencyFormat.format(result.breakdown['otherExpensesVat'] ?? 0)}',
                  Colors.grey[500],
                  small: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color? color, {
    bool bold = false,
    bool small = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: small ? 12 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: small ? 12 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearHistory),
        content: Text(l10n.confirmClearHistory),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<CalculationProvider>().clearHistory();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.historyCleared)));
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
