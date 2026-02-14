class CalculationResult {
  final int? id;
  final double netProfit;
  final double totalRevenue;
  final double totalCosts;
  final Map<String, double> breakdown;
  final DateTime timestamp;

  CalculationResult({
    this.id,
    required this.netProfit,
    required this.totalRevenue,
    required this.totalCosts,
    required this.breakdown,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'netProfit': netProfit,
      'totalRevenue': totalRevenue,
      'totalCosts': totalCosts,
      'breakdown': _breakdownToString(breakdown),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory CalculationResult.fromMap(Map<String, dynamic> map) {
    return CalculationResult(
      id: map['id'],
      netProfit: map['netProfit'] ?? 0.0,
      totalRevenue: map['totalRevenue'] ?? 0.0,
      totalCosts: map['totalCosts'] ?? 0.0,
      breakdown: _breakdownFromString(map['breakdown'] ?? '{}'),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  static String _breakdownToString(Map<String, double> breakdown) {
    final entries = breakdown.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    return entries;
  }

  static Map<String, double> _breakdownFromString(String breakdownStr) {
    if (breakdownStr.isEmpty) return {};
    final map = <String, double>{};
    final pairs = breakdownStr.split(',');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    return map;
  }

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

  bool get isProfitable => netProfit > 0;

  double get profitMargin =>
      totalRevenue > 0 ? (netProfit / totalRevenue) * 100 : 0;
}
