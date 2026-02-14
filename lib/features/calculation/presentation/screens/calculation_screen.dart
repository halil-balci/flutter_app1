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
  final _salePriceVatController = TextEditingController(text: '0');
  final _purchasePriceController = TextEditingController();
  final _purchasePriceVatController = TextEditingController(text: '0');
  final _shippingCostController = TextEditingController();
  final _shippingVatController = TextEditingController(text: '0');
  final _commissionController = TextEditingController();
  final _commissionVatController = TextEditingController(text: '0');
  final _otherExpensesController = TextEditingController();
  final _otherExpensesVatController = TextEditingController(text: '0');

  // VAT checkbox states
  bool _salePriceVatIncluded = false;
  bool _purchasePriceVatIncluded = false;
  bool _shippingVatIncluded = false;
  bool _commissionVatIncluded = false;
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
    _salePriceVatController.dispose();
    _purchasePriceController.dispose();
    _purchasePriceVatController.dispose();
    _shippingCostController.dispose();
    _shippingVatController.dispose();
    _commissionController.dispose();
    _commissionVatController.dispose();
    _otherExpensesController.dispose();
    _otherExpensesVatController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      final provider = context.read<CalculationProvider>();

      provider.updateSalePrice(
        double.tryParse(_salePriceController.text) ?? 0,
        double.tryParse(_salePriceVatController.text) ?? 0,
        _salePriceVatIncluded,
      );
      provider.updatePurchasePrice(
        double.tryParse(_purchasePriceController.text) ?? 0,
        double.tryParse(_purchasePriceVatController.text) ?? 0,
        _purchasePriceVatIncluded,
      );
      provider.updateShippingCost(
        double.tryParse(_shippingCostController.text) ?? 0,
        double.tryParse(_shippingVatController.text) ?? 0,
        _shippingVatIncluded,
      );
      provider.updateCommission(
        double.tryParse(_commissionController.text) ?? 0,
        double.tryParse(_commissionVatController.text) ?? 0,
        _commissionVatIncluded,
      );
      provider.updateOtherExpenses(
        double.tryParse(_otherExpensesController.text) ?? 0,
        double.tryParse(_otherExpensesVatController.text) ?? 0,
        _otherExpensesVatIncluded,
      );

      provider.calculate();
      _animController.forward(from: 0);
    }
  }

  void _reset() {
    HapticFeedback.lightImpact();
    setState(() {
      _salePriceController.clear();
      _salePriceVatController.text = '0';
      _purchasePriceController.clear();
      _purchasePriceVatController.text = '0';
      _shippingCostController.clear();
      _shippingVatController.text = '0';
      _commissionController.clear();
      _commissionVatController.text = '0';
      _otherExpensesController.clear();
      _otherExpensesVatController.text = '0';
      _salePriceVatIncluded = false;
      _purchasePriceVatIncluded = false;
      _shippingVatIncluded = false;
      _commissionVatIncluded = false;
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
                        vatController: _salePriceVatController,
                        vatIncluded: _salePriceVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _salePriceVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountValidator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              double.tryParse(v) == null) {
                            return l10n.invalidNumber;
                          }
                          return null;
                        },
                        vatValidator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final vat = double.tryParse(v);
                          if (vat == null || vat < 0 || vat > 100) {
                            return l10n.invalidVatRate;
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
                        vatController: _purchasePriceVatController,
                        vatIncluded: _purchasePriceVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _purchasePriceVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountValidator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              double.tryParse(v) == null) {
                            return l10n.invalidNumber;
                          }
                          return null;
                        },
                        vatValidator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final vat = double.tryParse(v);
                          if (vat == null || vat < 0 || vat > 100) {
                            return l10n.invalidVatRate;
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
                        vatController: _shippingVatController,
                        vatIncluded: _shippingVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _shippingVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountValidator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              double.tryParse(v) == null) {
                            return l10n.invalidNumber;
                          }
                          return null;
                        },
                        vatValidator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final vat = double.tryParse(v);
                          if (vat == null || vat < 0 || vat > 100) {
                            return l10n.invalidVatRate;
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
                        vatController: _commissionVatController,
                        vatIncluded: _commissionVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _commissionVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountValidator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              double.tryParse(v) == null) {
                            return l10n.invalidNumber;
                          }
                          return null;
                        },
                        vatValidator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final vat = double.tryParse(v);
                          if (vat == null || vat < 0 || vat > 100) {
                            return l10n.invalidVatRate;
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
                        vatController: _otherExpensesVatController,
                        vatIncluded: _otherExpensesVatIncluded,
                        onVatIncludedChanged: (v) =>
                            setState(() => _otherExpensesVatIncluded = v),
                        amountLabel: l10n.amount,
                        vatLabel: l10n.vatRate,
                        vatIncludedLabel: l10n.vatIncluded,
                        amountValidator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              double.tryParse(v) == null) {
                            return l10n.invalidNumber;
                          }
                          return null;
                        },
                        vatValidator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final vat = double.tryParse(v);
                          if (vat == null || vat < 0 || vat > 100) {
                            return l10n.invalidVatRate;
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
