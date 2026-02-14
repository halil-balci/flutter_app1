class CalculationInput {
  final double salePrice;
  final double salePriceVat;
  final bool salePriceVatIncluded;

  final double purchasePrice;
  final double purchasePriceVat;
  final bool purchasePriceVatIncluded;

  final double shippingCost;
  final double shippingVat;
  final bool shippingVatIncluded;

  final double commission;
  final double commissionVat;
  final bool commissionVatIncluded;

  final double otherExpenses;
  final double otherExpensesVat;
  final bool otherExpensesVatIncluded;

  const CalculationInput({
    required this.salePrice,
    required this.salePriceVat,
    required this.salePriceVatIncluded,
    required this.purchasePrice,
    required this.purchasePriceVat,
    required this.purchasePriceVatIncluded,
    required this.shippingCost,
    required this.shippingVat,
    required this.shippingVatIncluded,
    required this.commission,
    required this.commissionVat,
    required this.commissionVatIncluded,
    required this.otherExpenses,
    required this.otherExpensesVat,
    required this.otherExpensesVatIncluded,
  });

  static const empty = CalculationInput(
    salePrice: 0,
    salePriceVat: 0,
    salePriceVatIncluded: false,
    purchasePrice: 0,
    purchasePriceVat: 0,
    purchasePriceVatIncluded: false,
    shippingCost: 0,
    shippingVat: 0,
    shippingVatIncluded: false,
    commission: 0,
    commissionVat: 0,
    commissionVatIncluded: false,
    otherExpenses: 0,
    otherExpensesVat: 0,
    otherExpensesVatIncluded: false,
  );

  CalculationInput copyWith({
    double? salePrice,
    double? salePriceVat,
    bool? salePriceVatIncluded,
    double? purchasePrice,
    double? purchasePriceVat,
    bool? purchasePriceVatIncluded,
    double? shippingCost,
    double? shippingVat,
    bool? shippingVatIncluded,
    double? commission,
    double? commissionVat,
    bool? commissionVatIncluded,
    double? otherExpenses,
    double? otherExpensesVat,
    bool? otherExpensesVatIncluded,
  }) {
    return CalculationInput(
      salePrice: salePrice ?? this.salePrice,
      salePriceVat: salePriceVat ?? this.salePriceVat,
      salePriceVatIncluded: salePriceVatIncluded ?? this.salePriceVatIncluded,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchasePriceVat: purchasePriceVat ?? this.purchasePriceVat,
      purchasePriceVatIncluded:
          purchasePriceVatIncluded ?? this.purchasePriceVatIncluded,
      shippingCost: shippingCost ?? this.shippingCost,
      shippingVat: shippingVat ?? this.shippingVat,
      shippingVatIncluded: shippingVatIncluded ?? this.shippingVatIncluded,
      commission: commission ?? this.commission,
      commissionVat: commissionVat ?? this.commissionVat,
      commissionVatIncluded:
          commissionVatIncluded ?? this.commissionVatIncluded,
      otherExpenses: otherExpenses ?? this.otherExpenses,
      otherExpensesVat: otherExpensesVat ?? this.otherExpensesVat,
      otherExpensesVatIncluded:
          otherExpensesVatIncluded ?? this.otherExpensesVatIncluded,
    );
  }
}
