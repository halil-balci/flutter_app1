class Validators {
  /// Validate if string is a valid number
  static String? validateNumber(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty for optional fields
    }
    if (double.tryParse(value) == null) {
      return errorMessage;
    }
    if (double.parse(value) < 0) {
      return errorMessage;
    }
    return null;
  }

  /// Validate if string is a valid positive number
  static String? validatePositiveNumber(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return errorMessage;
    }
    return null;
  }

  /// Validate VAT rate (must be between 0 and 100)
  static String? validateVatRate(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty for optional fields
    }
    final vat = double.tryParse(value);
    if (vat == null || vat < 0 || vat > 100) {
      return errorMessage;
    }
    return null;
  }

  /// Check if required field is not empty
  static String? validateRequired(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  /// Validate currency amount with two decimal places
  static String? validateCurrency(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final regex = RegExp(r'^\d+\.?\d{0,2}$');
    if (!regex.hasMatch(value)) {
      return errorMessage;
    }

    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return errorMessage;
    }

    return null;
  }
}
