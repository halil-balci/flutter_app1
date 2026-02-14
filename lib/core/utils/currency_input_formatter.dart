import 'package:flutter/services.dart';

/// Anlık para formatlaması yapan TextInputFormatter
/// Format: 1.000.000,00 (binlik ayırıcı nokta, ondalık virgül)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Eğer boş ise formatlamaya gerek yok
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Silme işlemi kontrolü
    final isDeleting = newValue.text.length < oldValue.text.length;

    // Sadece rakam, virgül ve nokta dışındaki karakterleri temizle
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d,]'), '');

    // Birden fazla virgül varsa sadece ilkini tut
    final commaIndex = cleanedText.indexOf(',');
    if (commaIndex != -1) {
      final beforeComma = cleanedText.substring(0, commaIndex);
      final afterComma = cleanedText
          .substring(commaIndex + 1)
          .replaceAll(',', '')
          .substring(0, 2); // Maksimum 2 ondalık basamak
      cleanedText = '$beforeComma,$afterComma';
    }

    // Virgülden önceki ve sonraki kısımları ayır
    List<String> parts = cleanedText.split(',');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Ondalık kısım maksimum 2 basamak olmalı
    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    // Tam sayı kısmına binlik ayırıcı ekle
    String formattedInteger = _formatWithThousandSeparator(integerPart);

    // Son formatlanmış text
    String formattedText = formattedInteger;
    if (cleanedText.contains(',')) {
      formattedText += ',$decimalPart';
    }

    // Eğer hiç rakam yoksa 0,00 göster
    if (formattedInteger.isEmpty) {
      formattedText = '0,00';
    } else if (!cleanedText.contains(',') && !isDeleting) {
      // Virgül yoksa ve silme işlemi değilse, virgülü ekle
      formattedText += ',00';
    }

    // Cursor pozisyonunu hesapla
    int selectionIndex;
    if (cleanedText.contains(',')) {
      // Virgül varsa, virgülden önceki rakam sayısını bul
      final beforeCommaLength = parts[0].length;
      // Binlik ayırıcılar dahil virgülün pozisyonunu hesapla
      selectionIndex = _calculateCursorPosition(
        formattedInteger,
        beforeCommaLength,
      );
    } else {
      // Virgül yoksa, virgülden önceki pozisyona yerleştir
      selectionIndex = formattedInteger.length;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  /// Binlik ayırıcılarla formatlama
  String _formatWithThousandSeparator(String number) {
    if (number.isEmpty) return '';

    // Başındaki sıfırları kaldır (sadece 0 kalmasın diye)
    number = number.replaceFirst(RegExp(r'^0+'), '');
    if (number.isEmpty) return '0';

    // Tersine çevir, 3'lü gruplara ayır, nokta ekle, tekrar tersine çevir
    final reversed = number.split('').reversed.join();
    final groups = <String>[];

    for (int i = 0; i < reversed.length; i += 3) {
      final end = i + 3;
      groups.add(
        reversed.substring(i, end > reversed.length ? reversed.length : end),
      );
    }

    return groups.join('.').split('').reversed.join();
  }

  /// Cursor pozisyonunu hesapla (binlik ayırıcılar dahil)
  int _calculateCursorPosition(String formattedInteger, int digitCount) {
    int position = 0;
    int digits = 0;

    for (int i = 0; i < formattedInteger.length; i++) {
      if (formattedInteger[i] != '.') {
        digits++;
        if (digits == digitCount) {
          position = i + 1;
          break;
        }
      }
      position = i + 1;
    }

    return position;
  }
}
