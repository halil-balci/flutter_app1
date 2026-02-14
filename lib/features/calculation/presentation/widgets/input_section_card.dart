import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../../../../core/utils/percentage_input_formatter.dart';

class InputSectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final TextEditingController amountController;
  final double initialVat;
  final ValueChanged<double> onVatChanged;
  final bool vatIncluded;
  final ValueChanged<bool> onVatIncludedChanged;
  final String amountLabel;
  final String vatLabel;
  final String vatIncludedLabel;
  final String? Function(String?)? amountValidator;
  final bool isPercentage;
  final FocusNode? amountFocusNode;

  const InputSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.amountController,
    required this.initialVat,
    required this.onVatChanged,
    required this.vatIncluded,
    required this.onVatIncludedChanged,
    required this.amountLabel,
    required this.vatLabel,
    required this.vatIncludedLabel,
    this.amountValidator,
    this.isPercentage = false,
    this.amountFocusNode,
  });

  @override
  State<InputSectionCard> createState() => _InputSectionCardState();
}

class _InputSectionCardState extends State<InputSectionCard> {
  late double _selectedVat;
  final List<double> _vatOptions = [0, 1, 10, 20];

  @override
  void initState() {
    super.initState();
    _selectedVat = widget.initialVat;

    // İlk açılışta eğer amount controller boşsa formatla
    if (widget.amountController.text.isEmpty) {
      if (widget.isPercentage) {
        widget.amountController.text = '0.00';
      } else {
        widget.amountController.text = '0,00';
      }
    }

    // Focus listener ekle
    widget.amountFocusNode?.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.amountFocusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    if (widget.amountFocusNode?.hasFocus ?? false) {
      final text = widget.amountController.text;

      if (widget.isPercentage) {
        // Percentage için: 0.00 ise temizle, değilse cursor noktanın solunda
        if (text == '0.00') {
          widget.amountController.clear();
        } else {
          final dotIndex = text.indexOf('.');
          if (dotIndex != -1) {
            widget.amountController.selection = TextSelection.collapsed(
              offset: dotIndex,
            );
          }
        }
      } else {
        // Para birimi için: 0,00 ise temizle, değilse cursor virgülden önce
        if (text == '0,00') {
          widget.amountController.clear();
        } else {
          final commaIndex = text.indexOf(',');
          if (commaIndex != -1) {
            widget.amountController.selection = TextSelection.collapsed(
              offset: commaIndex,
            );
          }
        }
      }
    }
  }

  void _showVatPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.vatLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._vatOptions.map((vat) {
                final isSelected = vat == _selectedVat;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedVat = vat);
                    widget.onVatChanged(vat);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withValues(alpha: 0.1)
                          : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '%${vat.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount and VAT inputs
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: widget.amountController,
                    focusNode: widget.amountFocusNode,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.amountLabel,
                      prefixText: widget.isPercentage ? null : '₺ ',
                      prefixStyle: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      suffixText: widget.isPercentage ? ' %' : null,
                      suffixStyle: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: widget.isPercentage
                        ? [PercentageInputFormatter()]
                        : [CurrencyInputFormatter()],
                    validator: widget.amountValidator,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: _showVatPicker,
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: widget.vatLabel,
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.textSecondary,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '%${_selectedVat.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // VAT checkbox
            Transform.translate(
              offset: const Offset(-12, 0),
              child: Row(
                children: [
                  Checkbox(
                    value: widget.vatIncluded,
                    onChanged: (value) =>
                        widget.onVatIncludedChanged(value ?? false),
                  ),
                  GestureDetector(
                    onTap: () =>
                        widget.onVatIncludedChanged(!widget.vatIncluded),
                    child: Text(
                      widget.vatIncludedLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
