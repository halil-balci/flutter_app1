# flutter_app1

A new Flutter project.

## Projeyi Çalıştırma

### iOS'ta Çalıştırma

1. **iOS Simülatörünü başlatın:**
   ```bash
   open -a Simulator
   ```

2. **Uygulamayı çalıştırın:**
   ```bash
   flutter run -d iphone
   ```

   veya sadece:
   ```bash
   flutter run
   ```
   ve listeden iOS simülatörünü seçin.

### Android'de Çalıştırma

1. **Android Emulator'ü başlatın** (Android Studio > AVD Manager'dan)

2. **Uygulamayı çalıştırın:**
   ```bash
   flutter run -d android
   ```

   veya fiziksel Android cihaz bağlıysa:
   ```bash
   flutter run
   ```
   ve listeden Android cihazı seçin.

### Web'de Çalıştırma

**Chrome'da çalıştırın:**
```bash
flutter run -d chrome
```

Web sürümü otomatik olarak tarayıcıda açılacaktır.

## Geliştirme Sırasında Kullanışlı Komutlar

Uygulama çalışırken terminalden şu komutları kullanabilirsiniz:

- `r` → Hot reload (değişiklikleri hızlıca yansıtır)
- `R` → Hot restart (uygulamayı yeniden başlatır)
- `q` → Uygulamayı durdurur
- `p` → Ekran kılavuz çizgilerini gösterir
- `o` → Platform değiştirir (iOS/Android arası)

## Gereksinimler

- Flutter SDK
- **iOS için:** Xcode (yalnızca macOS)
- **Android için:** Android Studio ve Android SDK
- **Web için:** Chrome tarayıcısı
