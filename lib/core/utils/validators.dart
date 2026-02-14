class Validators {
  static String? validateNumber(String? value, String errorMessage) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) return errorMessage;
    if (double.parse(value) < 0) return errorMessage;
    return null;
  }

  static String? validatePositiveNumber(String? value, String errorMessage) {
    if (value == null || value.isEmpty) return errorMessage;
    final number = double.tryParse(value);
    if (number == null || number < 0) return errorMessage;
    return null;
  }

  static String? validateVatRate(String? value, String errorMessage) {
    if (value == null || value.isEmpty) return null;
    final vat = double.tryParse(value);
    if (vat == null || vat < 0 || vat > 100) return errorMessage;
    return null;
  }

  static String? validateRequired(String? value, String errorMessage) {
    if (value == null || value.isEmpty) return errorMessage;
    return null;
  }

  static String? validateCurrency(String? value, String errorMessage) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^\d+\.?\d{0,2}$');
    if (!regex.hasMatch(value)) return errorMessage;
    final number = double.tryParse(value);
    if (number == null || number < 0) return errorMessage;
    return null;
  }
}
