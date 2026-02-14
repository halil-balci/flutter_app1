import '../../domain/entities/calculation_result.dart';

class CalculationResultModel extends CalculationResult {
  const CalculationResultModel({
    super.id,
    required super.netProfit,
    required super.totalRevenue,
    required super.totalCosts,
    required super.breakdown,
    required super.timestamp,
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

  factory CalculationResultModel.fromMap(Map<String, dynamic> map) {
    return CalculationResultModel(
      id: map['id'] as int?,
      netProfit: (map['netProfit'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalCosts: (map['totalCosts'] as num?)?.toDouble() ?? 0.0,
      breakdown: _breakdownFromString(map['breakdown'] as String? ?? ''),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (map['timestamp'] as int?) ?? 0,
      ),
    );
  }

  factory CalculationResultModel.fromEntity(CalculationResult entity) {
    return CalculationResultModel(
      id: entity.id,
      netProfit: entity.netProfit,
      totalRevenue: entity.totalRevenue,
      totalCosts: entity.totalCosts,
      breakdown: entity.breakdown,
      timestamp: entity.timestamp,
    );
  }

  static String _breakdownToString(Map<String, double> breakdown) {
    return breakdown.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  static Map<String, double> _breakdownFromString(String breakdownStr) {
    if (breakdownStr.isEmpty) return {};
    final map = <String, double>{};
    for (final pair in breakdownStr.split(',')) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    return map;
  }
}
