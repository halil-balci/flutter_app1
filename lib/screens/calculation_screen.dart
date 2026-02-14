import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../generated/app_localizations.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result_card.dart';

class CalculationScreen extends StatefulWidget {
  const CalculationScreen({super.key});

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
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

  // VAT included checkboxes
  bool _salePriceVatIncluded = false;
  bool _purchasePriceVatIncluded = false;
  bool _shippingVatIncluded = false;
  bool _commissionVatIncluded = false;
  bool _otherExpensesVatIncluded = false;

  @override
  void dispose() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<CalculationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calculator),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
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
              provider.reset();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sale Price Section
            _buildInputSection(
              l10n.salePrice,
              _salePriceController,
              _salePriceVatController,
              _salePriceVatIncluded,
              (value) => setState(() => _salePriceVatIncluded = value),
              l10n,
            ),
            const Divider(height: 32),

            // Purchase Price Section
            _buildInputSection(
              l10n.purchasePrice,
              _purchasePriceController,
              _purchasePriceVatController,
              _purchasePriceVatIncluded,
              (value) => setState(() => _purchasePriceVatIncluded = value),
              l10n,
            ),
            const Divider(height: 32),

            // Shipping Cost Section
            _buildInputSection(
              l10n.shippingCost,
              _shippingCostController,
              _shippingVatController,
              _shippingVatIncluded,
              (value) => setState(() => _shippingVatIncluded = value),
              l10n,
            ),
            const Divider(height: 32),

            // Commission Section
            _buildInputSection(
              l10n.commission,
              _commissionController,
              _commissionVatController,
              _commissionVatIncluded,
              (value) => setState(() => _commissionVatIncluded = value),
              l10n,
            ),
            const Divider(height: 32),

            // Other Expenses Section
            _buildInputSection(
              l10n.otherExpenses,
              _otherExpensesController,
              _otherExpensesVatController,
              _otherExpensesVatIncluded,
              (value) => setState(() => _otherExpensesVatIncluded = value),
              l10n,
            ),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text(l10n.calculate),
            ),
            const SizedBox(height: 24),

            // Result Section
            if (provider.hasResult) ResultCard(result: provider.currentResult!),

            // Error Message
            if (provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Card(
                  color: Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(
    String title,
    TextEditingController amountController,
    TextEditingController vatController,
    bool vatIncluded,
    ValueChanged<bool> onVatIncludedChanged,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: l10n.amount,
                  border: const OutlineInputBorder(),
                  prefixText: '₺ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Allow empty for optional fields
                  }
                  if (double.tryParse(value) == null) {
                    return l10n.invalidNumber;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: vatController,
                decoration: InputDecoration(
                  labelText: l10n.vatRate,
                  border: const OutlineInputBorder(),
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  final vat = double.tryParse(value);
                  if (vat == null || vat < 0 || vat > 100) {
                    return l10n.invalidVatRate;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: Text(l10n.vatIncluded),
          value: vatIncluded,
          onChanged: (value) => onVatIncludedChanged(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
