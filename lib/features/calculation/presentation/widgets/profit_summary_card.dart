import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../generated/app_localizations.dart';
import '../../domain/entities/calculation_result.dart';

class ProfitSummaryCard extends StatelessWidget {
  final CalculationResult result;
  final VoidCallback? onSave;
  final VoidCallback? onExport;
  final bool isLoading;

  const ProfitSummaryCard({
    super.key,
    required this.result,
    this.onSave,
    this.onExport,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isProfitable = result.isProfitable;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Column(
          children: [
            // Gradient header with profit amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isProfitable
                    ? AppTheme.profitGradient
                    : AppTheme.lossGradient,
              ),
              child: Column(
                children: [
                  Text(
                    l10n.yourRevenueFromSale,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isProfitable
                            ? Icons.account_balance_wallet_rounded
                            : Icons.trending_down_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${!isProfitable ? '-' : ''}${CurrencyFormatter.formatWithSymbol(result.netProfit.abs())}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isProfitable
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isProfitable ? l10n.profit : l10n.loss,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${result.profitMargin.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Revenue & Costs summary
            Container(
              color: AppTheme.cardColor,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Devlete Ödenecek KDV - BELİRGİN GÖSTER
                  if (result.salesVat > 0 || result.expensesVat > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: result.netVat >= 0
                            ? LinearGradient(
                                colors: [
                                  const Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.1),
                                  const Color(
                                    0xFFEE5A6F,
                                  ).withValues(alpha: 0.1),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.1),
                                  const Color(
                                    0xFF059669,
                                  ).withValues(alpha: 0.1),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(
                          color: result.netVat >= 0
                              ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                              : const Color(0xFF10B981).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: result.netVat >= 0
                                      ? const Color(
                                          0xFFFF6B6B,
                                        ).withValues(alpha: 0.15)
                                      : const Color(
                                          0xFF10B981,
                                        ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  result.netVat >= 0
                                      ? Icons.account_balance_rounded
                                      : Icons.monetization_on_rounded,
                                  color: result.netVat >= 0
                                      ? const Color(0xFFFF6B6B)
                                      : const Color(0xFF10B981),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.netVat >= 0
                                          ? l10n.vatPayableToGovernment
                                          : l10n.vatRefundFromGovernment,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        CurrencyFormatter.formatWithSymbol(
                                          result.netVat.abs(),
                                        ),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: result.netVat >= 0
                                              ? const Color(0xFFFF6B6B)
                                              : const Color(0xFF10B981),
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 4,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.successColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.salesVat,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          CurrencyFormatter.formatWithSymbol(
                                            result.salesVat,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 4,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.dangerColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.expensesVat,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '- ${CurrencyFormatter.formatWithSymbol(result.expensesVat)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Gelir ve Masraf Detayları
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.calculationDetails,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildSummaryRow(
                          icon: Icons.arrow_upward_rounded,
                          iconColor: AppTheme.successColor,
                          label: l10n.totalIncome,
                          value: CurrencyFormatter.formatWithSymbol(
                            result.totalRevenue,
                          ),
                          onTap: () => _showIncomeDetails(context),
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          icon: Icons.arrow_downward_rounded,
                          iconColor: AppTheme.dangerColor,
                          label: l10n.totalExpenses,
                          value: CurrencyFormatter.formatWithSymbol(
                            result.totalCosts,
                          ),
                          onTap: () => _showExpenseDetails(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.save_rounded,
                          label: l10n.saveButton,
                          onTap: isLoading ? null : onSave,
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.picture_as_pdf_rounded,
                          label: l10n.pdfButton,
                          onTap: isLoading ? null : onExport,
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final row = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppTheme.textMuted,
          ),
        ],
      ],
    );

    if (onTap == null) return row;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: row,
        ),
      ),
    );
  }

  double _calculateBaseAmount(double totalAmount, double vatAmount) {
    final baseAmount = totalAmount - vatAmount;
    return baseAmount < 0 ? 0 : baseAmount;
  }

  void _showIncomeDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _showDetailsBottomSheet(
      context: context,
      title: l10n.totalIncome,
      icon: Icons.arrow_upward_rounded,
      iconColor: AppTheme.successColor,
      items: [
        (
          l10n.salePrice,
          result.breakdown['salePrice'] ?? 0,
          result.breakdown['salePriceVat'] ?? 0,
        ),
      ],
    );
  }

  void _showExpenseDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _showDetailsBottomSheet(
      context: context,
      title: l10n.totalExpenses,
      icon: Icons.arrow_downward_rounded,
      iconColor: AppTheme.dangerColor,
      items: [
        (
          l10n.purchasePrice,
          result.breakdown['purchasePrice'] ?? 0,
          result.breakdown['purchasePriceVat'] ?? 0,
        ),
        (
          l10n.shippingCost,
          result.breakdown['shippingCost'] ?? 0,
          result.breakdown['shippingVat'] ?? 0,
        ),
        (
          l10n.commission,
          result.breakdown['commission'] ?? 0,
          result.breakdown['commissionVat'] ?? 0,
        ),
        (
          l10n.otherExpenses,
          result.breakdown['otherExpenses'] ?? 0,
          result.breakdown['otherExpensesVat'] ?? 0,
        ),
      ],
    );
  }

  void _showDetailsBottomSheet({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<(String, double, double)> items,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isTr = l10n.localeName.toLowerCase().startsWith('tr');
    final vatExcludedLabel = isTr ? 'KDV Hariç Tutar' : 'Amount Excluding VAT';
    final vatIncludedLabel = isTr ? 'KDV Dahil Tutar' : 'Amount Including VAT';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final (itemTitle, totalAmount, vatAmount) = items[index];
                    final baseAmount = _calculateBaseAmount(
                      totalAmount,
                      vatAmount,
                    );

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            label: vatExcludedLabel,
                            value: baseAmount,
                          ),
                          const SizedBox(height: 4),
                          _buildDetailRow(label: l10n.vat, value: vatAmount),
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            label: vatIncludedLabel,
                            value: totalAmount,
                            isEmphasized: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required double value,
    bool isEmphasized = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isEmphasized ? AppTheme.textPrimary : AppTheme.textSecondary,
            fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          CurrencyFormatter.formatWithSymbol(value),
          style: TextStyle(
            fontSize: 12,
            color: isEmphasized ? AppTheme.textPrimary : AppTheme.textSecondary,
            fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    return Material(
      color: isPrimary
          ? AppTheme.primaryColor
          : AppTheme.primaryColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
