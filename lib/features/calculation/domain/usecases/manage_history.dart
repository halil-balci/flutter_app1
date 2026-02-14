import '../entities/calculation_input.dart';
import '../entities/calculation_result.dart';
import '../repositories/calculation_repository.dart';

class SaveCalculationUseCase {
  final CalculationRepository repository;

  SaveCalculationUseCase(this.repository);

  Future<int> call(CalculationResult result, CalculationInput input) {
    return repository.saveCalculation(result, input);
  }
}

class GetHistoryUseCase {
  final CalculationRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<CalculationResult>> call() {
    return repository.getHistory();
  }
}

class DeleteCalculationUseCase {
  final CalculationRepository repository;

  DeleteCalculationUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteCalculation(id);
  }
}

class ClearHistoryUseCase {
  final CalculationRepository repository;

  ClearHistoryUseCase(this.repository);

  Future<void> call() {
    return repository.clearHistory();
  }
}
