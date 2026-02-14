class CalculationResult {
  final int? id;
  final double netProfit;
  final double totalRevenue;
  final double totalCosts;
  final Map<String, double> breakdown;
  final DateTime timestamp;

  const CalculationResult({
    this.id,
    required this.netProfit,
    required this.totalRevenue,
    required this.totalCosts,
    required this.breakdown,
    required this.timestamp,
  });

  bool get isProfitable => netProfit > 0;

  double get profitMargin =>
      totalRevenue > 0 ? (netProfit / totalRevenue) * 100 : 0;

  // Satış KDV'si (gelir KDV)
  double get salesVat => breakdown['salePriceVat'] ?? 0;

  // Gider KDV'leri toplamı
  double get expensesVat =>
      (breakdown['purchasePriceVat'] ?? 0) +
      (breakdown['shippingVat'] ?? 0) +
      (breakdown['commissionVat'] ?? 0) +
      (breakdown['otherExpensesVat'] ?? 0);

  // Net KDV (ödenecek veya iade alınacak KDV)
  // Pozitif: Devlete ödenecek KDV
  // Negatif: Devletten iade alınacak KDV
  double get netVat => salesVat - expensesVat;

  CalculationResult copyWith({
    int? id,
    double? netProfit,
    double? totalRevenue,
    double? totalCosts,
    Map<String, double>? breakdown,
    DateTime? timestamp,
  }) {
    return CalculationResult(
      id: id ?? this.id,
      netProfit: netProfit ?? this.netProfit,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalCosts: totalCosts ?? this.totalCosts,
      breakdown: breakdown ?? this.breakdown,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
