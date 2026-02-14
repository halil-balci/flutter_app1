import '../../domain/entities/calculation_input.dart';

class CalculationInputModel extends CalculationInput {
  const CalculationInputModel({
    required super.salePrice,
    required super.salePriceVat,
    required super.salePriceVatIncluded,
    required super.purchasePrice,
    required super.purchasePriceVat,
    required super.purchasePriceVatIncluded,
    required super.shippingCost,
    required super.shippingVat,
    required super.shippingVatIncluded,
    required super.commission,
    required super.commissionVat,
    required super.commissionVatIncluded,
    required super.otherExpenses,
    required super.otherExpensesVat,
    required super.otherExpensesVatIncluded,
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

  factory CalculationInputModel.fromMap(Map<String, dynamic> map) {
    return CalculationInputModel(
      salePrice: (map['salePrice'] as num?)?.toDouble() ?? 0.0,
      salePriceVat: (map['salePriceVat'] as num?)?.toDouble() ?? 0.0,
      salePriceVatIncluded: map['salePriceVatIncluded'] == 1,
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      purchasePriceVat: (map['purchasePriceVat'] as num?)?.toDouble() ?? 0.0,
      purchasePriceVatIncluded: map['purchasePriceVatIncluded'] == 1,
      shippingCost: (map['shippingCost'] as num?)?.toDouble() ?? 0.0,
      shippingVat: (map['shippingVat'] as num?)?.toDouble() ?? 0.0,
      shippingVatIncluded: map['shippingVatIncluded'] == 1,
      commission: (map['commission'] as num?)?.toDouble() ?? 0.0,
      commissionVat: (map['commissionVat'] as num?)?.toDouble() ?? 0.0,
      commissionVatIncluded: map['commissionVatIncluded'] == 1,
      otherExpenses: (map['otherExpenses'] as num?)?.toDouble() ?? 0.0,
      otherExpensesVat: (map['otherExpensesVat'] as num?)?.toDouble() ?? 0.0,
      otherExpensesVatIncluded: map['otherExpensesVatIncluded'] == 1,
    );
  }

  factory CalculationInputModel.fromEntity(CalculationInput entity) {
    return CalculationInputModel(
      salePrice: entity.salePrice,
      salePriceVat: entity.salePriceVat,
      salePriceVatIncluded: entity.salePriceVatIncluded,
      purchasePrice: entity.purchasePrice,
      purchasePriceVat: entity.purchasePriceVat,
      purchasePriceVatIncluded: entity.purchasePriceVatIncluded,
      shippingCost: entity.shippingCost,
      shippingVat: entity.shippingVat,
      shippingVatIncluded: entity.shippingVatIncluded,
      commission: entity.commission,
      commissionVat: entity.commissionVat,
      commissionVatIncluded: entity.commissionVatIncluded,
      otherExpenses: entity.otherExpenses,
      otherExpensesVat: entity.otherExpensesVat,
      otherExpensesVatIncluded: entity.otherExpensesVatIncluded,
    );
  }
}
