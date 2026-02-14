import '../models/calculation_input.dart';
import '../models/calculation_result.dart';

class ProfitCalculator {
  /// Calculate the total amount including or excluding VAT
  /// If VAT is included, extract the base amount
  /// If VAT is excluded, add VAT to the base amount
  double calculateTotalWithVat(
    double amount,
    double vatRate,
    bool vatIncluded,
  ) {
    if (amount == 0) return 0;

    if (vatIncluded) {
      // VAT is already included, return as is
      return amount;
    } else {
      // VAT is not included, add it
      return amount * (1 + vatRate / 100);
    }
  }

  /// Calculate the base amount (without VAT)
  double calculateBaseAmount(double amount, double vatRate, bool vatIncluded) {
    if (amount == 0) return 0;

    if (vatIncluded) {
      // Extract base amount from total
      return amount / (1 + vatRate / 100);
    } else {
      // Amount is already base amount
      return amount;
    }
  }

  /// Calculate VAT amount
  double calculateVatAmount(double amount, double vatRate, bool vatIncluded) {
    if (amount == 0) return 0;

    final baseAmount = calculateBaseAmount(amount, vatRate, vatIncluded);
    return baseAmount * (vatRate / 100);
  }

  /// Main calculation method
  CalculationResult calculate(CalculationInput input) {
    // Calculate total revenue (sale price with VAT)
    final totalRevenue = calculateTotalWithVat(
      input.salePrice,
      input.salePriceVat,
      input.salePriceVatIncluded,
    );

    // Calculate all costs with their VAT
    final purchaseCost = calculateTotalWithVat(
      input.purchasePrice,
      input.purchasePriceVat,
      input.purchasePriceVatIncluded,
    );

    final shippingCost = calculateTotalWithVat(
      input.shippingCost,
      input.shippingVat,
      input.shippingVatIncluded,
    );

    final commissionCost = calculateTotalWithVat(
      input.commission,
      input.commissionVat,
      input.commissionVatIncluded,
    );

    final otherExpensesCost = calculateTotalWithVat(
      input.otherExpenses,
      input.otherExpensesVat,
      input.otherExpensesVatIncluded,
    );

    // Calculate total costs
    final totalCosts =
        purchaseCost + shippingCost + commissionCost + otherExpensesCost;

    // Calculate net profit
    final netProfit = totalRevenue - totalCosts;

    // Create breakdown map
    final breakdown = <String, double>{
      'salePrice': totalRevenue,
      'purchasePrice': purchaseCost,
      'shippingCost': shippingCost,
      'commission': commissionCost,
      'otherExpenses': otherExpensesCost,
      'salePriceVat': calculateVatAmount(
        input.salePrice,
        input.salePriceVat,
        input.salePriceVatIncluded,
      ),
      'purchasePriceVat': calculateVatAmount(
        input.purchasePrice,
        input.purchasePriceVat,
        input.purchasePriceVatIncluded,
      ),
      'shippingVat': calculateVatAmount(
        input.shippingCost,
        input.shippingVat,
        input.shippingVatIncluded,
      ),
      'commissionVat': calculateVatAmount(
        input.commission,
        input.commissionVat,
        input.commissionVatIncluded,
      ),
      'otherExpensesVat': calculateVatAmount(
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
