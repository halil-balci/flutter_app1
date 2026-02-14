import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/app_localizations.dart';
import '../providers/calculation_provider.dart';
import '../widgets/input_section_card.dart';
import '../widgets/profit_summary_card.dart';

class CalculationScreen extends StatefulWidget {
  const CalculationScreen({super.key});

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _salePriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _shippingCostController = TextEditingController();
  final _commissionController = TextEditingController();
  final _otherExpensesController = TextEditingController();

  // Focus Nodes
  final _salePriceFocusNode = FocusNode();
  final _purchasePriceFocusNode = FocusNode();
  final _shippingCostFocusNode = FocusNode();
  final _commissionFocusNode = FocusNode();
  final _otherExpensesFocusNode = FocusNode();

  // VAT values
  double _salePriceVat = 0;
  double _purchasePriceVat = 0;
  double _shippingVat = 20;
  double _commissionVat = 20;
  double _otherExpensesVat = 0;

  // VAT checkbox states
  bool _salePriceVatIncluded = false;
  bool _purchasePriceVatIncluded = false;
  bool _shippingVatIncluded = true;
  bool _commissionVatIncluded = true;
  bool _otherExpensesVatIncluded = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _salePriceController.dispose();
    _purchasePriceController.dispose();
    _shippingCostController.dispose();
    _commissionController.dispose();
    _otherExpensesController.dispose();

    _salePriceFocusNode.dispose();
    _purchasePriceFocusNode.dispose();
    _shippingCostFocusNode.dispose();
    _commissionFocusNode.dispose();
    _otherExpensesFocusNode.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      final provider = context.read<CalculationProvider>();

      provider.updateSalePrice(
        _parseAmount(_salePriceController.text),
        _salePriceVat,
        _salePriceVatIncluded,
      );
      provider.updatePurchasePrice(
        _parseAmount(_purchasePriceController.text),
        _purchasePriceVat,
        _purchasePriceVatIncluded,
      );
      provider.updateShippingCost(
        _parseAmount(_shippingCostController.text),
        _shippingVat,
        _shippingVatIncluded,
      );
      provider.updateCommission(
        _parsePercentage(_commissionController.text),
        _commissionVat,
        _commissionVatIncluded,
      );
      provider.updateOtherExpenses(
        _parseAmount(_otherExpensesController.text),
        _otherExpensesVat,
        _otherExpensesVatIncluded,
      );

      provider.calculate();
      _animController.forward(from: 0);
    }
  }

  double _parseAmount(String text) {
    return double.tryParse(text.replaceAll('.', '').replaceAll(',', '.')) ?? 0;
  }

  double _parsePercentage(String text) {
    // Percentage formatı zaten nokta ile ayrılmış (5.00)
    return double.tryParse(text) ?? 0;
  }

  void _reset() {
    HapticFeedback.lightImpact();
    setState(() {
      _salePriceController.clear();
      _purchasePriceController.clear();
      _shippingCostController.clear();
      _commissionController.clear();
      _otherExpensesController.clear();

      _salePriceVat = 0;
      _purchasePriceVat = 0;
      _shippingVat = 20;
      _commissionVat = 20;
      _otherExpensesVat = 0;

      _salePriceVatIncluded = false;
      _purchasePriceVatIncluded = false;
      _shippingVatIncluded = true;
      _commissionVatIncluded = true;
      _otherExpensesVatIncluded = false;
    });
    context.read<CalculationProvider>().reset();
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<CalculationProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern gradient app bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                l10n.calculator,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -40,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: _reset,
                tooltip: 'Sıfırla',
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Sale Price
                      InputSectionCard(
                        title: l10n.salePrice,
                        icon: Icons.sell_rounded,
                        amountController: _salePriceController,
                        initialVat: _salePriceVat,
                        onVatChanged: (vat) =>
                            setState(() => _salePriceVat = vat),
                        vatIncluded: _salePriceVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _salePriceVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountFocusNode: _salePriceFocusNode,
                        amountValidator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final text = v
                                .replaceAll('.', '')
                                .replaceAll(',', '.');
                            if (double.tryParse(text) == null) {
                              return l10n.invalidNumber;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Purchase Price
                      InputSectionCard(
                        title: l10n.purchasePrice,
                        icon: Icons.shopping_cart_rounded,
                        amountController: _purchasePriceController,
                        initialVat: _purchasePriceVat,
                        onVatChanged: (vat) =>
                            setState(() => _purchasePriceVat = vat),
                        vatIncluded: _purchasePriceVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _purchasePriceVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountFocusNode: _purchasePriceFocusNode,
                        amountValidator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final text = v
                                .replaceAll('.', '')
                                .replaceAll(',', '.');
                            if (double.tryParse(text) == null) {
                              return l10n.invalidNumber;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Shipping Cost
                      InputSectionCard(
                        title: l10n.shippingCost,
                        icon: Icons.local_shipping_rounded,
                        amountController: _shippingCostController,
                        initialVat: _shippingVat,
                        onVatChanged: (vat) =>
                            setState(() => _shippingVat = vat),
                        vatIncluded: _shippingVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _shippingVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountFocusNode: _shippingCostFocusNode,
                        amountValidator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final text = v
                                .replaceAll('.', '')
                                .replaceAll(',', '.');
                            if (double.tryParse(text) == null) {
                              return l10n.invalidNumber;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Commission
                      InputSectionCard(
                        title: l10n.commission,
                        icon: Icons.percent_rounded,
                        amountController: _commissionController,
                        initialVat: _commissionVat,
                        onVatChanged: (vat) =>
                            setState(() => _commissionVat = vat),
                        vatIncluded: _commissionVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _commissionVatIncluded = v),
                        amountLabel: l10n.commissionRate, // Komisyon oranı
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        isPercentage: true, // Yüzde olarak göster
                        amountFocusNode: _commissionFocusNode,
                        amountValidator: (v) {
                          if (v != null && v.isNotEmpty) {
                            // Percentage formatı zaten nokta ile ayrılmış (5.00)
                            final rate = double.tryParse(v);
                            if (rate == null) {
                              return l10n.invalidNumber;
                            }
                            if (rate < 0 || rate > 99.99) {
                              return l10n.invalidCommissionRate;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Other Expenses
                      InputSectionCard(
                        title: l10n.otherExpenses,
                        icon: Icons.receipt_long_rounded,
                        amountController: _otherExpensesController,
                        initialVat: _otherExpensesVat,
                        onVatChanged: (vat) =>
                            setState(() => _otherExpensesVat = vat),
                        vatIncluded: _otherExpensesVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _otherExpensesVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountFocusNode: _otherExpensesFocusNode,
                        amountValidator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final text = v
                                .replaceAll('.', '')
                                .replaceAll(',', '.');
                            if (double.tryParse(text) == null) {
                              return l10n.invalidNumber;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Calculate Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSm,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _calculate,
                            icon: const Icon(Icons.calculate_rounded, size: 22),
                            label: Text(l10n.calculate),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusSm,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Result Section
                      if (provider.hasResult)
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(_fadeAnim),
                            child: ProfitSummaryCard(
                              result: provider.currentResult!,
                              isLoading: provider.isLoading,
                              onSave: () async {
                                await provider.saveCalculation();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.calculationSaved),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              onExport: () async {
                                final path = await provider.exportToPdf(
                                  provider.currentResult!,
                                  title: l10n.profitReport,
                                );
                                if (path != null && context.mounted) {
                                  await provider.shareFile(
                                    path,
                                    subject: l10n.profitReport,
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                      // Error
                      if (provider.errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.dangerColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSm,
                            ),
                            border: Border.all(
                              color: AppTheme.dangerColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: AppTheme.dangerColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: const TextStyle(
                                    color: AppTheme.dangerColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
