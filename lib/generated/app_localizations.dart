import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Profit Calculator'**
  String get appTitle;

  /// Calculator tab label
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Sale price input label
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get salePrice;

  /// Purchase price input label
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePrice;

  /// Shipping cost input label
  ///
  /// In en, this message translates to:
  /// **'Shipping Cost'**
  String get shippingCost;

  /// E-commerce commission input label
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// Other expenses input label
  ///
  /// In en, this message translates to:
  /// **'Other Expenses'**
  String get otherExpenses;

  /// VAT rate input label
  ///
  /// In en, this message translates to:
  /// **'VAT Rate (%)'**
  String get vatRate;

  /// VAT included checkbox label
  ///
  /// In en, this message translates to:
  /// **'VAT Included'**
  String get vatIncluded;

  /// Amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Calculate button label
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// Net profit label
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// Total revenue label
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// Total costs label
  ///
  /// In en, this message translates to:
  /// **'Total Costs'**
  String get totalCosts;

  /// Cost breakdown section label
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Export to PDF button label
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// Export to CSV button label
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// Clear history button label
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Empty history message
  ///
  /// In en, this message translates to:
  /// **'No calculation history'**
  String get noHistory;

  /// Success message when calculation is saved
  ///
  /// In en, this message translates to:
  /// **'Calculation saved successfully'**
  String get calculationSaved;

  /// Success message when calculation is deleted
  ///
  /// In en, this message translates to:
  /// **'Calculation deleted'**
  String get calculationDeleted;

  /// Success message when history is cleared
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// Success message for export
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully'**
  String get exportSuccess;

  /// Error message prefix
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Invalid input error message
  ///
  /// In en, this message translates to:
  /// **'Please enter valid values'**
  String get invalidInput;

  /// Required field error message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Invalid number error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumber;

  /// Invalid VAT rate error message
  ///
  /// In en, this message translates to:
  /// **'VAT rate must be between 0 and 100'**
  String get invalidVatRate;

  /// Confirmation dialog message for clearing history
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all history?'**
  String get confirmClearHistory;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// PDF report title
  ///
  /// In en, this message translates to:
  /// **'Profit Report'**
  String get profitReport;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Message when not all fields are filled
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllFields;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
