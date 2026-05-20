import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Floating-label field that opens the bank selection sheet.
class BankSelectorField extends StatelessWidget {
  /// Label shown above the selected bank/placeholder.
  final String label;

  /// Selected bank value or placeholder text.
  final String value;

  /// Callback fired when the field is tapped.
  final VoidCallback onTap;

  /// Whether [value] represents a real selection.
  final bool hasValue;

  /// Optional trailing widget, defaulting to a dropdown chevron.
  final Widget? trailing;

  /// Selected bank used to render a logo when available.
  final SecAcntBankOption? selectedValue;

  /// Optional validation error text.
  final String? errorText;

  /// Whether the field can be tapped.
  final bool enabled;

  /// Creates a bank selector field.
  const BankSelectorField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    required this.hasValue,
    this.trailing,
    this.selectedValue,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return FloatingLabelFieldShell(
      label: label,
      placeholder: value,
      hasValue: hasValue,
      enabled: enabled,
      errorText: errorText,
      onTap: onTap,
      trailing:
          trailing ??
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: DesignTokens.muted,
          ),
      child: Row(
        children: <Widget>[
          if (selectedValue != null && selectedValue!.logoUrl.isNotEmpty) ...[
            Image.network(
              selectedValue?.logoUrl ?? '',
              width: 16,
              height: 16,
              errorBuilder:
                  (
                    BuildContext context,
                    Object exception,
                    StackTrace? stackTrace,
                  ) {
                    return const Icon(
                      Icons.apartment,
                      color: DesignTokens.muted,
                      size: 20,
                    );
                  },
            ),
            SizedBox(width: responsive.spacingMd),
          ],
          Expanded(
            child: CustomText(
              value,
              variant: hasValue
                  ? MiniAppTextVariant.subtitle3
                  : MiniAppTextVariant.body3,
              color: hasValue ? DesignTokens.ink : DesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}
