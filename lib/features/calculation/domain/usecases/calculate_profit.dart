import '../entities/calculation_input.dart';
import '../entities/calculation_result.dart';

class CalculateProfitUseCase {
  /// Calculate the total amount including or excluding VAT
  double _calculateTotalWithVat(
    double amount,
    double vatRate,
    bool vatIncluded,
  ) {
    if (amount == 0) return 0;
    if (vatIncluded) return amount;
    return amount * (1 + vatRate / 100);
  }

  /// Calculate the base amount (without VAT)
  double _calculateBaseAmount(double amount, double vatRate, bool vatIncluded) {
    if (amount == 0) return 0;
    if (vatIncluded) return amount / (1 + vatRate / 100);
    return amount;
  }

  /// Calculate VAT amount
  double _calculateVatAmount(double amount, double vatRate, bool vatIncluded) {
    if (amount == 0) return 0;
    final baseAmount = _calculateBaseAmount(amount, vatRate, vatIncluded);
    return baseAmount * (vatRate / 100);
  }

  /// Execute the profit calculation
  CalculationResult call(CalculationInput input) {
    final totalRevenue = _calculateTotalWithVat(
      input.salePrice,
      input.salePriceVat,
      input.salePriceVatIncluded,
    );

    final purchaseCost = _calculateTotalWithVat(
      input.purchasePrice,
      input.purchasePriceVat,
      input.purchasePriceVatIncluded,
    );

    final shippingCost = _calculateTotalWithVat(
      input.shippingCost,
      input.shippingVat,
      input.shippingVatIncluded,
    );

    // Calculate commission as a percentage of sale price (excluding VAT)
    final salePriceBase = _calculateBaseAmount(
      input.salePrice,
      input.salePriceVat,
      input.salePriceVatIncluded,
    );
    final commissionBase = salePriceBase * (input.commission / 100);
    final commissionCost = _calculateTotalWithVat(
      commissionBase,
      input.commissionVat,
      input.commissionVatIncluded,
    );

    final otherExpensesCost = _calculateTotalWithVat(
      input.otherExpenses,
      input.otherExpensesVat,
      input.otherExpensesVatIncluded,
    );

    final totalCosts =
        purchaseCost + shippingCost + commissionCost + otherExpensesCost;
    final netProfit = totalRevenue - totalCosts;

    final breakdown = <String, double>{
      'salePrice': totalRevenue,
      'purchasePrice': purchaseCost,
      'shippingCost': shippingCost,
      'commission': commissionCost,
      'otherExpenses': otherExpensesCost,
      'salePriceVat': _calculateVatAmount(
        input.salePrice,
        input.salePriceVat,
        input.salePriceVatIncluded,
      ),
      'purchasePriceVat': _calculateVatAmount(
        input.purchasePrice,
        input.purchasePriceVat,
        input.purchasePriceVatIncluded,
      ),
      'shippingVat': _calculateVatAmount(
        input.shippingCost,
        input.shippingVat,
        input.shippingVatIncluded,
      ),
      'commissionVat': _calculateVatAmount(
        commissionBase,
        input.commissionVat,
        input.commissionVatIncluded,
      ),
      'otherExpensesVat': _calculateVatAmount(
        input.otherExpenses,
        input.otherExpensesVat,
        input.otherExpensesVatIncluded,
      ),
    };

    return CalculationResult(
      netProfit: netProfit,
      totalRevenue: totalRevenue,
      totalCosts: totalCosts,
      breakdown: breakdown,
      timestamp: DateTime.now(),
    );
  }
}
