import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
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
                          const Text(
                            'Hesaplama Detayları',
                            style: TextStyle(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isProfitable ? 'Net Kar' : 'Net Zarar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.formatWithSymbol(
                                  result.netProfit.abs(),
                                ),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '%${result.profitMargin.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Revenue & Costs overview
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniCard(
                            'Toplam Gelir',
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
                            'Toplam Maliyet',
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
                    const Text(
                      'Kalem Detayları',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildBreakdownItem(
                      'Satış Fiyatı',
                      result.breakdown['salePrice'] ?? 0,
                      result.breakdown['salePriceVat'] ?? 0,
                      Icons.sell_rounded,
                      AppTheme.successColor,
                    ),
                    _buildBreakdownItem(
                      'Alış Fiyatı',
                      result.breakdown['purchasePrice'] ?? 0,
                      result.breakdown['purchasePriceVat'] ?? 0,
                      Icons.shopping_cart_rounded,
                      AppTheme.dangerColor,
                    ),
                    _buildBreakdownItem(
                      'Kargo',
                      result.breakdown['shippingCost'] ?? 0,
                      result.breakdown['shippingVat'] ?? 0,
                      Icons.local_shipping_rounded,
                      const Color(0xFFF59E0B),
                    ),
                    _buildBreakdownItem(
                      'Komisyon',
                      result.breakdown['commission'] ?? 0,
                      result.breakdown['commissionVat'] ?? 0,
                      Icons.percent_rounded,
                      const Color(0xFF8B5CF6),
                    ),
                    _buildBreakdownItem(
                      'Diğer Masraflar',
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
    String title,
    double amount,
    double vatAmount,
    IconData icon,
    Color color,
  ) {
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
                  Text(
                    'KDV: ${CurrencyFormatter.formatWithSymbol(vatAmount)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatWithSymbol(amount),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
