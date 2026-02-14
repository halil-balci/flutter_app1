# E-Commerce Profit Calculator / E-Ticaret Kar Hesaplayıcı

A Flutter application for e-commerce sellers to calculate profit/loss by tracking sales, costs, and various expenses with VAT handling.

E-ticaret satıcıları için satış, maliyet ve çeşitli giderleri KDV ile birlikte takip ederek kar/zarar hesaplayan bir Flutter uygulaması.

## Features / Özellikler

### English
- **Multi-language Support**: Turkish and English localization
- **Comprehensive Calculation**: Calculate net profit from sales price, purchase price, shipping cost, commission, and other expenses - all with customizable VAT rates
- **VAT Flexibility**: Specify whether VAT is included or excluded for each cost item
- **History Management**: Save calculations to local database
- **Export Capabilities**: Export as PDF or CSV, share files
- **Detailed Breakdown**: View comprehensive cost breakdown with VAT details
- **Modern UI**: Material Design 3 with intuitive bottom navigation

### Türkçe
- **Çoklu Dil Desteği**: Türkçe ve İngilizce yerelleştirme
- **Kapsamlı Hesaplama**: Satış fiyatı, alış fiyatı, kargo ücreti, komisyon ve diğer masraflar için özelleştirilebilir KDV oranlarıyla net kar hesaplama
- **KDV Esnekliği**: Her maliyet kalemi için KDV'nin dahil mi yoksa hariç mi olduğunu belirtin
- **Geçmiş Yönetimi**: Hesaplamaları yerel veritabanına kaydetme
- **Dışa Aktarma**: PDF veya CSV olarak dışa aktarma, dosya paylaşma
- **Detaylı Döküm**: KDV detaylarıyla kapsamlı maliyet dökümünü görüntüleme
- **Modern Arayüz**: Sezgisel alt navigasyonla Material Design 3

## Screenshot / Ekran Görüntüsü

*(Screenshots will be added after running the app)*

## Installation / Kurulum

```bash
# Clone the repository / Depoyu klonlayın
git clone <repository-url>

# Navigate to project directory / Proje dizinine gidin
cd flutter_app1

# Install dependencies / Bağımlılıkları yükleyin
flutter pub get

# Run the app / Uygulamayı çalıştırın
flutter run
```

## Usage / Kullanım

### Calculating Profit / Kar Hesaplama

1. **Calculator tab / Hesaplayıcı sekmesi**: Enter all cost items
2. For each item / Her kalem için:
   - Amount / Tutar
   - VAT rate (%) / KDV oranı (%)
   - Check "VAT Included" if applicable / Geçerliyse "KDV Dahil" işaretleyin
3. Click **Calculate / Hesapla**
4. View results with detailed breakdown / Detaylı dökümle sonuçları görüntüleyin
5. Save or export as PDF / Kaydedin veya PDF olarak dışa aktarın

### Managing History / Geçmiş Yönetimi

1. **History tab / Geçmiş sekmesi**: View all saved calculations
2. Tap to see details / Detayları görmek için dokunun
3. Swipe to delete / Silmek için kaydırın
4. Export all as CSV / Tümünü CSV olarak dışa aktarın

## VAT Calculation Logic / KDV Hesaplama Mantığı

**VAT Included / KDV Dahil:**
- Base Amount = Amount / (1 + VAT% / 100)
- Total = Amount

**VAT Excluded / KDV Hariç:**
- Base Amount = Amount
- Total = Amount × (1 + VAT% / 100)

## Architecture / Mimari

- **Pattern**: MVVM with Provider
- **State Management**: Provider (ChangeNotifier)
- **Database**: SQLite (sqflite)
- **Export**: PDF and CSV
- **Localization**: flutter_localizations with .arb files

## Dependencies / Bağımlılıklar

- `provider` - State management
- `sqflite` - Local database
- `path_provider` - File system access
- `pdf` - PDF generation
- `csv` - CSV export
- `share_plus` - File sharing
- `intl` - Formatting
- `flutter_localizations` - Multi-language support

## Project Structure / Proje Yapısı

```
lib/
├── generated/          # Auto-generated localization files
├── l10n/              # Localization source files (.arb)
├── models/            # Data models
├── providers/         # State management
├── screens/           # UI screens
├── services/          # Business logic
├── utils/             # Utilities
├── widgets/           # Reusable widgets
└── main.dart          # App entry point
```

## Development / Geliştirme

### Running on iOS / iOS'ta Çalıştırma

```bash
open -a Simulator
flutter run -d iphone
```

### Running on Android / Android'de Çalıştırma

```bash
flutter run -d android
```

### Running on Web / Web'de Çalıştırma

```bash
flutter run -d chrome
```

### Hot Reload Commands / Hot Reload Komutları

- `r` → Hot reload
- `R` → Hot restart
- `q` → Quit
- `p` → Show grid overlay
- `o` → Switch platform (iOS/Android)

## Testing / Test

```bash
flutter test
```

## Building for Release / Yayın İçin Derleme

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Requirements / Gereksinimler

- Flutter SDK ^3.10.8
- Dart SDK
- **For iOS**: Xcode (macOS only)
- **For Android**: Android Studio and Android SDK
- **For Web**: Chrome browser

## Troubleshooting / Sorun Giderme

### Localization files not generated
```bash
flutter clean
flutter pub get
```

### Database reset needed
Use "Clear History" in the app or run `flutter clean`

## Future Enhancements / Gelecek Geliştirmeler

- [ ] Multiple currency support / Çoklu para birimi desteği
- [ ] Cloud backup / Bulut yedekleme
- [ ] Analytics dashboard / Analitik panosu
- [ ] Bulk import / Toplu içe aktarma
- [ ] Category management / Kategori yönetimi

## License / Lisans

This project is created for educational purposes.
Bu proje eğitim amaçlı oluşturulmuştur.

## Author / Yazar

Created with Flutter and ❤️
