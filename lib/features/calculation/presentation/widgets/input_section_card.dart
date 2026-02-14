import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';

class InputSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController amountController;
  final TextEditingController vatController;
  final bool vatIncluded;
  final ValueChanged<bool> onVatIncludedChanged;
  final String amountLabel;
  final String vatLabel;
  final String vatIncludedLabel;
  final String? Function(String?)? amountValidator;
  final String? Function(String?)? vatValidator;

  const InputSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.amountController,
    required this.vatController,
    required this.vatIncluded,
    required this.onVatIncludedChanged,
    required this.amountLabel,
    required this.vatLabel,
    required this.vatIncludedLabel,
    this.amountValidator,
    this.vatValidator,
  });

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
                  child: Icon(icon, color: AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
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
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: amountLabel,
                      prefixText: '₺ ',
                      prefixStyle: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    validator: amountValidator,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: vatController,
                    decoration: InputDecoration(
                      labelText: vatLabel,
                      suffixText: '%',
                      suffixStyle: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    validator: vatValidator,
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
                    value: vatIncluded,
                    onChanged: (value) => onVatIncludedChanged(value ?? false),
                  ),
                  GestureDetector(
                    onTap: () => onVatIncludedChanged(!vatIncluded),
                    child: Text(
                      vatIncludedLabel,
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
