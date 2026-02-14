import 'package:flutter/foundation.dart';
import '../models/calculation_input.dart';
import '../models/calculation_result.dart';
import '../services/profit_calculator.dart';
import '../services/database_service.dart';
import '../services/export_service.dart';

class CalculationProvider extends ChangeNotifier {
  final ProfitCalculator _calculator = ProfitCalculator();
  final DatabaseService _database = DatabaseService.instance;
  final ExportService _exportService = ExportService();

  CalculationInput _currentInput = CalculationInput(
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

  // Update input fields
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

  // Calculate profit
  void calculate() {
    try {
      _errorMessage = null;
      _currentResult = _calculator.calculate(_currentInput);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _currentResult = null;
      notifyListeners();
    }
  }

  // Save calculation to database
  Future<void> saveCalculation() async {
    if (_currentResult == null) {
      _errorMessage = 'No calculation to save';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final id = await _database.saveCalculation(
        _currentResult!,
        _currentInput,
      );
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

  // Load calculation history
  Future<void> loadHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      _history = await _database.getHistory();

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete a calculation
  Future<void> deleteCalculation(int id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _database.deleteCalculation(id);
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

  // Clear all history
  Future<void> clearHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _database.clearHistory();
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

  // Export single calculation to PDF
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

  // Export history to CSV
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

  // Share file
  Future<void> shareFile(String filePath, {String? subject}) async {
    try {
      await _exportService.shareFile(filePath, subject: subject);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Reset calculator
  void reset() {
    _currentInput = CalculationInput(
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
    _currentResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
