// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Profit Calculator';

  @override
  String get calculator => 'Calculator';

  @override
  String get history => 'History';

  @override
  String get salePrice => 'Sale Price';

  @override
  String get purchasePrice => 'Purchase Price';

  @override
  String get shippingCost => 'Shipping Cost';

  @override
  String get commission => 'Commission';

  @override
  String get otherExpenses => 'Other Expenses';

  @override
  String get vatRate => 'VAT Rate (%)';

  @override
  String get vatIncluded => 'VAT Included';

  @override
  String get amount => 'Amount';

  @override
  String get calculate => 'Calculate';

  @override
  String get netProfit => 'Net Profit';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalCosts => 'Total Costs';

  @override
  String get breakdown => 'Breakdown';

  @override
  String get save => 'Save';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get delete => 'Delete';

  @override
  String get noHistory => 'No calculation history';

  @override
  String get calculationSaved => 'Calculation saved successfully';

  @override
  String get calculationDeleted => 'Calculation deleted';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get exportSuccess => 'Export completed successfully';

  @override
  String get error => 'Error';

  @override
  String get invalidInput => 'Please enter valid values';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidNumber => 'Please enter a valid number';

  @override
  String get invalidVatRate => 'VAT rate must be between 0 and 100';

  @override
  String get confirmClearHistory =>
      'Are you sure you want to clear all history?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get profitReport => 'Profit Report';

  @override
  String get date => 'Date';

  @override
  String get fillAllFields => 'Please fill all required fields';
}
