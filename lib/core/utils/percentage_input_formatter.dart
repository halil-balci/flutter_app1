import 'package:flutter/services.dart';

/// Yüzde değerleri için özel formatter
/// Format: 0.00 - 99.99 arası
class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Eğer boş ise formatlamaya gerek yok
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Sadece rakam ve nokta kabul et
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Birden fazla nokta varsa sadece ilkini tut
    final dotIndex = cleanedText.indexOf('.');
    if (dotIndex != -1) {
      final beforeDot = cleanedText.substring(0, dotIndex);
      final afterDotText = cleanedText
          .substring(dotIndex + 1)
          .replaceAll('.', '');
      final afterDot = afterDotText.length > 2
          ? afterDotText.substring(0, 2)
          : afterDotText;
      cleanedText = '$beforeDot.$afterDot';
    }

    // Noktadan önceki ve sonraki kısımları ayır
    List<String> parts = cleanedText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Tam sayı kısmı maksimum 2 basamak (0-99)
    if (integerPart.length > 2) {
      integerPart = integerPart.substring(0, 2);
    }

    // Ondalık kısım maksimum 2 basamak
    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    // Başındaki sıfırları temizle (sadece tek 0 kalmalı eğer integer part 0 ise)
    if (integerPart.length > 1) {
      integerPart = integerPart.replaceFirst(RegExp(r'^0+'), '');
      if (integerPart.isEmpty) integerPart = '0';
    }

    // Son formatlanmış text
    String formattedText = integerPart;
    if (cleanedText.contains('.')) {
      formattedText += '.$decimalPart';
    }

    // Eğer hiç rakam yoksa 0.00 göster
    if (formattedText.isEmpty || formattedText == '.') {
      formattedText = '0.00';
    } else if (!cleanedText.contains('.')) {
      // Nokta yoksa ekle
      formattedText += '.00';
    } else if (decimalPart.isEmpty) {
      formattedText += '00';
    } else if (decimalPart.length == 1) {
      formattedText += '0';
    }

    // Cursor pozisyonunu hesapla
    // Kullanıcının girdiği pozisyonu mümkün olduğunca koru
    int selectionIndex = newValue.selection.baseOffset;

    // Format sonrası eklenen karakterleri hesaba kat
    // Örneğin "5" -> "5.00" olduğunda cursor 1'den 1'de kalmalı
    final originalCursor = newValue.selection.baseOffset;
    final formattedLength = formattedText.length;

    // Cursor pozisyonunu sınırla
    selectionIndex = originalCursor.clamp(0, formattedLength);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
