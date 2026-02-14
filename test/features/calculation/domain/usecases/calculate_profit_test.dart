import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app1/features/calculation/domain/entities/calculation_input.dart';
import 'package:flutter_app1/features/calculation/domain/usecases/calculate_profit.dart';

void main() {
  late CalculateProfitUseCase calculateProfit;

  setUp(() {
    calculateProfit = CalculateProfitUseCase();
  });

  group('CalculateProfitUseCase -', () {
    group('Temel hesaplamalar -', () {
      test('KDV hariç hesaplama - basit kar senaryosu', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000, // Satış fiyatı
          salePriceVat: 20, // %20 KDV
          salePriceVatIncluded: false, // KDV hariç
          purchasePrice: 500, // Alış fiyatı
          purchasePriceVat: 20, // %20 KDV
          purchasePriceVatIncluded: false, // KDV hariç
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Toplam gelir: 1000 + (1000 * 0.20) = 1200
        expect(result.totalRevenue, 1200);
        // Toplam maliyet: 500 + (500 * 0.20) = 600
        expect(result.totalCosts, 600);
        // Net kar: 1200 - 600 = 600
        expect(result.netProfit, 600);
        // Kar marjı: (600 / 1200) * 100 = 50%
        expect(result.profitMargin, 50);
        // Satış KDV: 1000 * 0.20 = 200
        expect(result.salesVat, 200);
        // Gider KDV: 500 * 0.20 = 100
        expect(result.expensesVat, 100);
        // Net KDV: 200 - 100 = 100 (ödenecek)
        expect(result.netVat, 100);
      });

      test('KDV dahil hesaplama - basit kar senaryosu', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1200, // Satış fiyatı (KDV dahil)
          salePriceVat: 20, // %20 KDV
          salePriceVatIncluded: true, // KDV dahil
          purchasePrice: 600, // Alış fiyatı (KDV dahil)
          purchasePriceVat: 20, // %20 KDV
          purchasePriceVatIncluded: true, // KDV dahil
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Toplam gelir: 1200 (KDV dahil)
        expect(result.totalRevenue, 1200);
        // Toplam maliyet: 600 (KDV dahil)
        expect(result.totalCosts, 600);
        // Net kar: 1200 - 600 = 600
        expect(result.netProfit, 600);
        // Satış KDV: 1200 / 1.20 * 0.20 = 200
        expect(result.salesVat, closeTo(200, 0.01));
        // Gider KDV: 600 / 1.20 * 0.20 = 100
        expect(result.expensesVat, closeTo(100, 0.01));
      });

      test('Zarar senaryosu - negatif kar', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 500, // Satış fiyatı
          salePriceVat: 20,
          salePriceVatIncluded: false,
          purchasePrice: 800, // Alış fiyatı (satıştan yüksek)
          purchasePriceVat: 20,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Toplam gelir: 500 * 1.20 = 600
        expect(result.totalRevenue, 600);
        // Toplam maliyet: 800 * 1.20 = 960
        expect(result.totalCosts, 960);
        // Net kar (zarar): 600 - 960 = -360
        expect(result.netProfit, -360);
        expect(result.isProfitable, false);
        // Kar marjı negatif
        expect(result.profitMargin, -60);
      });
    });

    group('Komisyon hesaplamaları -', () {
      test('Komisyon hesaplama - satış fiyatının yüzdesi olarak', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000, // Satış fiyatı
          salePriceVat: 20,
          salePriceVatIncluded: false,
          purchasePrice: 500,
          purchasePriceVat: 20,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 10, // %10 komisyon
          commissionVat: 20, // Komisyon üzerine %20 KDV
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Komisyon tabanı: KDV dahil satış tutarı 1200 * 0.10 = 120
        // Komisyon KDV ile: 120 * 1.20 = 144
        expect(result.breakdown['commission'], 144);
        // Komisyon KDV: 120 * 0.20 = 24
        expect(result.breakdown['commissionVat'], 24);
        // Toplam maliyet: 600 + 144 = 744
        expect(result.totalCosts, 744);
        // Net kar: 1200 - 744 = 456
        expect(result.netProfit, 456);
      });

      test('Komisyon 0-100 arası kontrol - %0 geçerli', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000,
          salePriceVat: 0,
          salePriceVatIncluded: false,
          purchasePrice: 500,
          purchasePriceVat: 0,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0, // %0 komisyon
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        expect(result.breakdown['commission'], 0);
        expect(result.netProfit, 500); // 1000 - 500
      });

      test('Komisyon 0-100 arası kontrol - %100 geçerli', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000,
          salePriceVat: 0,
          salePriceVatIncluded: false,
          purchasePrice: 0,
          purchasePriceVat: 0,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 100, // %100 komisyon (tüm satış geliri)
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Komisyon tutarı: 1000 * 1.00 = 1000
        expect(result.breakdown['commission'], 1000);
        // Net kar: 1000 - 1000 = 0
        expect(result.netProfit, 0);
      });
    });

    group('KDV oranları validasyonu -', () {
      test('KDV %0 geçerli', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000,
          salePriceVat: 0, // %0 KDV
          salePriceVatIncluded: false,
          purchasePrice: 500,
          purchasePriceVat: 0,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        expect(result.totalRevenue, 1000); // KDV yok
        expect(result.totalCosts, 500); // KDV yok
        expect(result.salesVat, 0);
        expect(result.expensesVat, 0);
        expect(result.netVat, 0);
      });

      test('KDV %100 geçerli - ekstrem durum', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000,
          salePriceVat: 100, // %100 KDV
          salePriceVatIncluded: false,
          purchasePrice: 500,
          purchasePriceVat: 100,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Toplam gelir: 1000 * 2 = 2000
        expect(result.totalRevenue, 2000);
        // Toplam maliyet: 500 * 2 = 1000
        expect(result.totalCosts, 1000);
        // Satış KDV: 1000
        expect(result.salesVat, 1000);
        // Gider KDV: 500
        expect(result.expensesVat, 500);
      });
    });

    group('Tüm giderler dahil - karmaşık senaryo -', () {
      test('Tüm gider kalemleriyle hesaplama', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 2000, // Satış
          salePriceVat: 20,
          salePriceVatIncluded: false,
          purchasePrice: 1000, // Alış
          purchasePriceVat: 20,
          purchasePriceVatIncluded: false,
          shippingCost: 50, // Kargo
          shippingVat: 20,
          shippingVatIncluded: false,
          commission: 5, // %5 komisyon
          commissionVat: 20,
          commissionVatIncluded: false,
          otherExpenses: 100, // Diğer masraflar
          otherExpensesVat: 20,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Gelir: 2000 * 1.20 = 2400
        expect(result.totalRevenue, 2400);

        // Maliyet hesaplamaları:
        // - Alış: 1000 * 1.20 = 1200
        // - Kargo: 50 * 1.20 = 60
        // - Komisyon: (2400 * 0.05) * 1.20 = 144
        // - Diğer: 100 * 1.20 = 120
        // Toplam: 1200 + 60 + 144 + 120 = 1524
        expect(result.totalCosts, 1524);

        // Net kar: 2400 - 1524 = 876
        expect(result.netProfit, 876);

        // KDV kontrolü
        // Satış KDV: 2000 * 0.20 = 400
        expect(result.salesVat, 400);

        // Gider KDV: 200 + 10 + 24 + 20 = 254
        expect(result.expensesVat, 254);

        // Net KDV: 400 - 254 = 146 (ödenecek)
        expect(result.netVat, 146);
      });

      test('Ondalıklı sayılarla hesaplama', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1234.56, // Ondalıklı satış fiyatı
          salePriceVat: 18, // %18 KDV
          salePriceVatIncluded: false,
          purchasePrice: 789.12, // Ondalıklı alış fiyatı
          purchasePriceVat: 18,
          purchasePriceVatIncluded: false,
          shippingCost: 25.50,
          shippingVat: 18,
          shippingVatIncluded: false,
          commission: 3.5, // %3.5 komisyon
          commissionVat: 18,
          commissionVatIncluded: false,
          otherExpenses: 50.75,
          otherExpensesVat: 18,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        // Sonuçların ondalıklı olduğunu kontrol et
        expect(result.totalRevenue, closeTo(1456.78, 0.01)); // 1234.56 * 1.18
        expect(result.netProfit, greaterThan(0)); // Kar var
        expect(result.isProfitable, true);

        // KDV miktarlarının hesaplandığını kontrol et
        expect(result.salesVat, closeTo(222.22, 0.01)); // 1234.56 * 0.18
        expect(result.expensesVat, greaterThan(0));
        expect(result.netVat, greaterThan(0)); // Net ödenecek KDV var
      });
    });

    group('Sıfır değerler -', () {
      test('Tüm değerler sıfır - boş hesaplama', () {
        // Arrange
        const input = CalculationInput.empty;

        // Act
        final result = calculateProfit(input);

        // Assert
        expect(result.totalRevenue, 0);
        expect(result.totalCosts, 0);
        expect(result.netProfit, 0);
        expect(result.profitMargin, 0);
        expect(result.salesVat, 0);
        expect(result.expensesVat, 0);
        expect(result.netVat, 0);
      });

      test('Sadece satış fiyatı var - saf kar', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000,
          salePriceVat: 20,
          salePriceVatIncluded: false,
          purchasePrice: 0,
          purchasePriceVat: 0,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        expect(result.totalRevenue, 1200);
        expect(result.totalCosts, 0);
        expect(result.netProfit, 1200);
        expect(result.profitMargin, 100); // %100 kar marjı
      });
    });

    group('KDV dahil/hariç karışık senaryolar -', () {
      test('Satış KDV dahil, alış KDV hariç', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1200, // KDV dahil
          salePriceVat: 20,
          salePriceVatIncluded: true,
          purchasePrice: 500, // KDV hariç
          purchasePriceVat: 20,
          purchasePriceVatIncluded: false,
          shippingCost: 0,
          shippingVat: 0,
          shippingVatIncluded: false,
          commission: 0,
          commissionVat: 0,
          commissionVatIncluded: false,
          otherExpenses: 0,
          otherExpensesVat: 0,
          otherExpensesVatIncluded: false,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        expect(result.totalRevenue, 1200); // KDV dahil
        expect(result.totalCosts, 600); // 500 * 1.20
        expect(result.netProfit, 600);
      });

      test('Farklı gider kalemlerinde farklı KDV durumları', () {
        // Arrange
        final input = CalculationInput(
          salePrice: 1000,
          salePriceVat: 20,
          salePriceVatIncluded: false,
          purchasePrice: 600, // KDV dahil
          purchasePriceVat: 20,
          purchasePriceVatIncluded: true,
          shippingCost: 50, // KDV hariç
          shippingVat: 20,
          shippingVatIncluded: false,
          commission: 5,
          commissionVat: 20,
          commissionVatIncluded: false,
          otherExpenses: 120, // KDV dahil
          otherExpensesVat: 20,
          otherExpensesVatIncluded: true,
        );

        // Act
        final result = calculateProfit(input);

        // Assert
        expect(result.totalRevenue, 1200); // 1000 * 1.20
        // Maliyetler:
        // - Alış: 600 (KDV dahil)
        // - Kargo: 50 * 1.20 = 60
        // - Komisyon: (1200 * 0.05) * 1.20 = 72
        // - Diğer: 120 (KDV dahil)
        // Toplam: 852
        expect(result.totalCosts, 852);
        expect(result.netProfit, closeTo(348, 0.01));
      });
    });

    group('Timestamp ve metadata -', () {
      test('Hesaplama sonucu timestamp içermeli', () {
        // Arrange
        const input = CalculationInput.empty;
        final beforeTime = DateTime.now();

        // Act
        final result = calculateProfit(input);

        // Assert
        final afterTime = DateTime.now();
        expect(
          result.timestamp.isAfter(beforeTime) ||
              result.timestamp.isAtSameMomentAs(beforeTime),
          true,
        );
        expect(
          result.timestamp.isBefore(afterTime) ||
              result.timestamp.isAtSameMomentAs(afterTime),
          true,
        );
      });
    });
  });
}
