import '../../domain/entities/calculation_input.dart';
import '../../domain/entities/calculation_result.dart';
import '../../domain/repositories/calculation_repository.dart';
import '../datasources/calculation_local_datasource.dart';
import '../models/calculation_input_model.dart';
import '../models/calculation_result_model.dart';

class CalculationRepositoryImpl implements CalculationRepository {
  final CalculationLocalDataSource localDataSource;

  CalculationRepositoryImpl({required this.localDataSource});

  @override
  Future<int> saveCalculation(
    CalculationResult result,
    CalculationInput input,
  ) {
    final resultModel = CalculationResultModel.fromEntity(result);
    final inputModel = CalculationInputModel.fromEntity(input);
    return localDataSource.insertCalculation(resultModel, inputModel);
  }

  @override
  Future<List<CalculationResult>> getHistory() {
    return localDataSource.fetchHistory();
  }

  @override
  Future<CalculationResult?> getCalculationById(int id) {
    return localDataSource.fetchById(id);
  }

  @override
  Future<CalculationInput?> getInputById(int id) {
    return localDataSource.fetchInputById(id);
  }

  @override
  Future<void> deleteCalculation(int id) {
    return localDataSource.removeCalculation(id).then((_) {});
  }

  @override
  Future<void> clearHistory() {
    return localDataSource.removeAll().then((_) {});
  }
}
