import 'package:flutter/foundation.dart';
import '../../domain/entities/calculation_input.dart';
import '../../domain/entities/calculation_result.dart';
import '../../domain/usecases/calculate_profit.dart';
import '../../domain/usecases/manage_history.dart';
import '../../data/services/export_service.dart';

class CalculationProvider extends ChangeNotifier {
  final CalculateProfitUseCase _calculateProfit;
  final SaveCalculationUseCase _saveCalculation;
  final GetHistoryUseCase _getHistory;
  final DeleteCalculationUseCase _deleteCalculation;
  final ClearHistoryUseCase _clearHistory;
  final ExportService _exportService;

  CalculationProvider({
    required CalculateProfitUseCase calculateProfit,
    required SaveCalculationUseCase saveCalculation,
    required GetHistoryUseCase getHistory,
    required DeleteCalculationUseCase deleteCalculation,
    required ClearHistoryUseCase clearHistory,
    required ExportService exportService,
  }) : _calculateProfit = calculateProfit,
       _saveCalculation = saveCalculation,
       _getHistory = getHistory,
       _deleteCalculation = deleteCalculation,
       _clearHistory = clearHistory,
       _exportService = exportService;

  CalculationInput _currentInput = CalculationInput.empty;
  CalculationResult? _currentResult;
  List<CalculationResult> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  CalculationInput get currentInput => _currentInput;
  CalculationResult? get currentResult => _currentResult;
  List<CalculationResult> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasResult => _currentResult != null;

  // Update input
  void updateInput(CalculationInput input) {
    _currentInput = input;
    notifyListeners();
  }

  void updateSalePrice(double value, double vat, bool vatIncluded) {
    _currentInput = _currentInput.copyWith(
      salePrice: value,
      salePriceVat: vat,
      salePriceVatIncluded: vatIncluded,
    );
    notifyListeners();
  }

  void updatePurchasePrice(double value, double vat, bool vatIncluded) {
    _currentInput = _currentInput.copyWith(
      purchasePrice: value,
      purchasePriceVat: vat,
      purchasePriceVatIncluded: vatIncluded,
    );
    notifyListeners();
  }

  void updateShippingCost(double value, double vat, bool vatIncluded) {
    _currentInput = _currentInput.copyWith(
      shippingCost: value,
      shippingVat: vat,
      shippingVatIncluded: vatIncluded,
    );
    notifyListeners();
  }

  void updateCommission(double value, double vat, bool vatIncluded) {
    _currentInput = _currentInput.copyWith(
      commission: value,
      commissionVat: vat,
      commissionVatIncluded: vatIncluded,
    );
    notifyListeners();
  }

  void updateOtherExpenses(double value, double vat, bool vatIncluded) {
    _currentInput = _currentInput.copyWith(
      otherExpenses: value,
      otherExpensesVat: vat,
      otherExpensesVatIncluded: vatIncluded,
    );
    notifyListeners();
  }

  // Calculate
  void calculate() {
    try {
      _errorMessage = null;
      _currentResult = _calculateProfit(_currentInput);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _currentResult = null;
      notifyListeners();
    }
  }

  // Save
  Future<void> saveCalculation() async {
    if (_currentResult == null) {
      _errorMessage = 'No calculation to save';
      notifyListeners();
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      final id = await _saveCalculation(_currentResult!, _currentInput);
      _currentResult = _currentResult!.copyWith(id: id);
      await loadHistory();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Load history
  Future<void> loadHistory() async {
    try {
      _isLoading = true;
      notifyListeners();
      _history = await _getHistory();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete
  Future<void> deleteCalculationById(int id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _deleteCalculation(id);
      await loadHistory();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Clear history
  Future<void> clearAllHistory() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _clearHistory();
      _history = [];
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Export PDF
  Future<String?> exportToPdf(CalculationResult result, {String? title}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final path = await _exportService.exportToPdf(result, title: title);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return path;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Export CSV
  Future<String?> exportHistoryToCsv() async {
    try {
      _isLoading = true;
      notifyListeners();
      final path = await _exportService.exportToCsv(_history);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return path;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Share
  Future<void> shareFile(String filePath, {String? subject}) async {
    try {
      await _exportService.shareFile(filePath, subject: subject);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Reset
  void reset() {
    _currentInput = CalculationInput.empty;
    _currentResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
