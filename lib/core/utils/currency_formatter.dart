import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00');
  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _shortDateFormatter = DateFormat('dd MMM yyyy');

  static String format(double value) => _formatter.format(value);

  static String formatWithSymbol(double value) =>
      '₺${_formatter.format(value)}';

  static String formatDate(DateTime date) => _dateFormatter.format(date);

  static String formatShortDate(DateTime date) =>
      _shortDateFormatter.format(date);
}
