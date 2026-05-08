import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class BankSelectorField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool hasValue;
  final Widget? trailing;
  final SecAcntBankOption? selectedValue;
  final String? errorText;
  final bool enabled;

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
