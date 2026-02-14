import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../generated/app_localizations.dart';
import '../../domain/entities/calculation_result.dart';

class BreakdownBottomSheet extends StatelessWidget {
  final CalculationResult result;

  const BreakdownBottomSheet({super.key, required this.result});

  static void show(BuildContext context, CalculationResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BreakdownBottomSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isProfitable = result.isProfitable;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: isProfitable
                            ? AppTheme.profitGradient
                            : AppTheme.lossGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isProfitable
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.calculationDetails,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatDate(result.timestamp),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    // Net Profit card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: isProfitable
                            ? AppTheme.profitGradient
                            : AppTheme.lossGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.yourRevenueFromSale,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${!isProfitable ? '-' : ''}${CurrencyFormatter.formatWithSymbol(result.netProfit.abs())}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  isProfitable ? l10n.profit : l10n.loss,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '%${result.profitMargin.toStringAsFixed(1)}',
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

                    const SizedBox(height: 20),

                    // KDV Kartı - Belirgin Gösterim
                    if (result.salesVat > 0 || result.expensesVat > 0)
                      Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          gradient: result.netVat >= 0
                              ? LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFFFF6B6B,
                                    ).withValues(alpha: 0.12),
                                    const Color(
                                      0xFFEE5A6F,
                                    ).withValues(alpha: 0.12),
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.12),
                                    const Color(
                                      0xFF059669,
                                    ).withValues(alpha: 0.12),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMd,
                          ),
                          border: Border.all(
                            color: result.netVat >= 0
                                ? const Color(0xFFFF6B6B).withValues(alpha: 0.4)
                                : const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  result.netVat >= 0
                                      ? Icons.account_balance_rounded
                                      : Icons.monetization_on_rounded,
                                  color: result.netVat >= 0
                                      ? const Color(0xFFFF6B6B)
                                      : const Color(0xFF10B981),
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    result.netVat >= 0
                                        ? l10n.vatPayableToGovernment
                                        : l10n.vatRefundFromGovernment,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: result.netVat >= 0
                                          ? const Color(0xFFFF6B6B)
                                          : const Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${l10n.salesVat}: ${CurrencyFormatter.formatWithSymbol(result.salesVat)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${l10n.expensesVat}: ${CurrencyFormatter.formatWithSymbol(result.expensesVat)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Revenue & Costs overview
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniCard(
                            l10n.totalIncome,
                            CurrencyFormatter.formatWithSymbol(
                              result.totalRevenue,
                            ),
                            Icons.arrow_upward_rounded,
                            AppTheme.successColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMiniCard(
                            l10n.totalExpenses,
                            CurrencyFormatter.formatWithSymbol(
                              result.totalCosts,
                            ),
                            Icons.arrow_downward_rounded,
                            AppTheme.dangerColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Detailed breakdown
                    Text(
                      l10n.itemDetails,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildBreakdownItem(
                      context,
                      l10n.salePrice,
                      result.breakdown['salePrice'] ?? 0,
                      result.breakdown['salePriceVat'] ?? 0,
                      Icons.sell_rounded,
                      AppTheme.successColor,
                    ),
                    _buildBreakdownItem(
                      context,
                      l10n.purchasePrice,
                      result.breakdown['purchasePrice'] ?? 0,
                      result.breakdown['purchasePriceVat'] ?? 0,
                      Icons.shopping_cart_rounded,
                      AppTheme.dangerColor,
                    ),
                    _buildBreakdownItem(
                      context,
                      l10n.shippingCost,
                      result.breakdown['shippingCost'] ?? 0,
                      result.breakdown['shippingVat'] ?? 0,
                      Icons.local_shipping_rounded,
                      const Color(0xFFF59E0B),
                    ),
                    _buildBreakdownItem(
                      context,
                      l10n.commission,
                      result.breakdown['commission'] ?? 0,
                      result.breakdown['commissionVat'] ?? 0,
                      Icons.percent_rounded,
                      const Color(0xFF8B5CF6),
                    ),
                    _buildBreakdownItem(
                      context,
                      l10n.otherExpenses,
                      result.breakdown['otherExpenses'] ?? 0,
                      result.breakdown['otherExpensesVat'] ?? 0,
                      Icons.receipt_long_rounded,
                      const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context,
    String title,
    double amount,
    double vatAmount,
    IconData icon,
    Color color,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (vatAmount > 0) ...[
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${l10n.vat}: ${CurrencyFormatter.formatWithSymbol(vatAmount)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              CurrencyFormatter.formatWithSymbol(amount),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
