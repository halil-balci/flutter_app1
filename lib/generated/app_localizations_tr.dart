// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Kar Hesaplayıcı';

  @override
  String get calculator => 'Hesaplayıcı';

  @override
  String get history => 'Geçmiş';

  @override
  String get salePrice => 'Satış Fiyatı';

  @override
  String get purchasePrice => 'Alış Fiyatı';

  @override
  String get shippingCost => 'Kargo Ücreti';

  @override
  String get commission => 'Komisyon';

  @override
  String get commissionRate => 'Oran';

  @override
  String get invalidCommissionRate =>
      'Komisyon oranı 0 ile 99.99 arasında olmalıdır';

  @override
  String get otherExpenses => 'Diğer Masraflar';

  @override
  String get vatRate => 'KDV Oranı (%)';

  @override
  String get vatIncluded => 'KDV Dahil';

  @override
  String get amount => 'Tutar';

  @override
  String get calculate => 'Hesapla';

  @override
  String get netProfit => 'Net Kar';

  @override
  String get totalRevenue => 'Toplam Gelir';

  @override
  String get totalCosts => 'Toplam Maliyet';

  @override
  String get breakdown => 'Detaylar';

  @override
  String get save => 'Kaydet';

  @override
  String get exportPdf => 'PDF Aktar';

  @override
  String get exportCsv => 'CSV Aktar';

  @override
  String get clearHistory => 'Geçmişi Temizle';

  @override
  String get delete => 'Sil';

  @override
  String get noHistory => 'Hesaplama geçmişi yok';

  @override
  String get calculationSaved => 'Hesaplama başarıyla kaydedildi';

  @override
  String get calculationDeleted => 'Hesaplama silindi';

  @override
  String get historyCleared => 'Geçmiş temizlendi';

  @override
  String get exportSuccess => 'Dışa aktarma başarıyla tamamlandı';

  @override
  String get error => 'Hata';

  @override
  String get invalidInput => 'Lütfen geçerli değerler girin';

  @override
  String get requiredField => 'Bu alan zorunludur';

  @override
  String get invalidNumber => 'Lütfen geçerli bir sayı girin';

  @override
  String get invalidVatRate => 'KDV oranı 0 ile 100 arasında olmalıdır';

  @override
  String get confirmClearHistory =>
      'Tüm geçmişi temizlemek istediğinizden emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get profitReport => 'Kar Raporu';

  @override
  String get date => 'Tarih';

  @override
  String get fillAllFields => 'Lütfen tüm gerekli alanları doldurun';

  @override
  String get yourRevenueFromSale => 'Satıştan Elde Ettiğiniz Gelir';

  @override
  String get profit => 'KAR';

  @override
  String get loss => 'ZARAR';

  @override
  String get vatPayableToGovernment => 'Devlete Ödenecek KDV';

  @override
  String get vatRefundFromGovernment => 'Devletten İade Alınacak KDV';

  @override
  String get salesVat => 'Satış KDV';

  @override
  String get expensesVat => 'Gider KDV';

  @override
  String get calculationDetails => 'Hesaplama Detayları';

  @override
  String get totalIncome => 'Toplam Gelir';

  @override
  String get totalExpenses => 'Toplam Masraf';

  @override
  String get itemDetails => 'Kalem Detayları';

  @override
  String get profitMargin => 'Kar Marjı';

  @override
  String get saveButton => 'Kaydet';

  @override
  String get pdfButton => 'PDF';

  @override
  String get vat => 'KDV';
}
