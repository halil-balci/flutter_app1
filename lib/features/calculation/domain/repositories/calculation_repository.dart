import '../entities/calculation_input.dart';
import '../entities/calculation_result.dart';

abstract class CalculationRepository {
  /// Save a calculation result with its input to persistent storage
  Future<int> saveCalculation(CalculationResult result, CalculationInput input);

  /// Load all calculation history, ordered by most recent first
  Future<List<CalculationResult>> getHistory();

  /// Get a single calculation by its ID
  Future<CalculationResult?> getCalculationById(int id);

  /// Get the input data for a specific calculation
  Future<CalculationInput?> getInputById(int id);

  /// Delete a single calculation by its ID
  Future<void> deleteCalculation(int id);

  /// Clear all calculation history
  Future<void> clearHistory();
}
