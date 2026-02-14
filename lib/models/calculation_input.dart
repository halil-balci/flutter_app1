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

  CalculationInput({
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

  Map<String, dynamic> toMap() {
    return {
      'salePrice': salePrice,
      'salePriceVat': salePriceVat,
      'salePriceVatIncluded': salePriceVatIncluded ? 1 : 0,
      'purchasePrice': purchasePrice,
      'purchasePriceVat': purchasePriceVat,
      'purchasePriceVatIncluded': purchasePriceVatIncluded ? 1 : 0,
      'shippingCost': shippingCost,
      'shippingVat': shippingVat,
      'shippingVatIncluded': shippingVatIncluded ? 1 : 0,
      'commission': commission,
      'commissionVat': commissionVat,
      'commissionVatIncluded': commissionVatIncluded ? 1 : 0,
      'otherExpenses': otherExpenses,
      'otherExpensesVat': otherExpensesVat,
      'otherExpensesVatIncluded': otherExpensesVatIncluded ? 1 : 0,
    };
  }

  factory CalculationInput.fromMap(Map<String, dynamic> map) {
    return CalculationInput(
      salePrice: map['salePrice'] ?? 0.0,
      salePriceVat: map['salePriceVat'] ?? 0.0,
      salePriceVatIncluded: map['salePriceVatIncluded'] == 1,
      purchasePrice: map['purchasePrice'] ?? 0.0,
      purchasePriceVat: map['purchasePriceVat'] ?? 0.0,
      purchasePriceVatIncluded: map['purchasePriceVatIncluded'] == 1,
      shippingCost: map['shippingCost'] ?? 0.0,
      shippingVat: map['shippingVat'] ?? 0.0,
      shippingVatIncluded: map['shippingVatIncluded'] == 1,
      commission: map['commission'] ?? 0.0,
      commissionVat: map['commissionVat'] ?? 0.0,
      commissionVatIncluded: map['commissionVatIncluded'] == 1,
      otherExpenses: map['otherExpenses'] ?? 0.0,
      otherExpensesVat: map['otherExpensesVat'] ?? 0.0,
      otherExpensesVatIncluded: map['otherExpensesVatIncluded'] == 1,
    );
  }

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
