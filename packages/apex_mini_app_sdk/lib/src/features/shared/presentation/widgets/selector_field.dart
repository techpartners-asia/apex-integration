import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SelectorField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool hasValue;
  final Widget? trailing;
  final SecAcntBankOption? selectedValue;
  final String? errorText;
  final bool enabled;

  const SelectorField({
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
    final ThemeData theme = Theme.of(context);
    final bool hasError = errorText != null && errorText!.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(responsive.radiusMd),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusMd),
            border: Border.all(
              color: hasError ? DesignTokens.danger : Colors.transparent,
            ),
          ),
          child: Padding(
            padding: responsive.insetsSymmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomText(
                            label,
                            variant: MiniAppTextVariant.label,
                            color: DesignTokens.muted,
                          ),
                          SizedBox(height: responsive.dp(6)),
                          Row(
                            children: <Widget>[
                              Visibility(
                                visible:
                                    selectedValue != null &&
                                    selectedValue!.logoUrl.isNotEmpty,
                                child: Image.network(
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
                              ),
                              Visibility(
                                visible: selectedValue != null,
                                child: SizedBox(width: responsive.spacingMd),
                              ),
                              Expanded(
                                child: Text(
                                  value,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: hasValue
                                        ? DesignTokens.ink
                                        : DesignTokens.muted,
                                    fontWeight: hasValue
                                        ? MiniAppTypography.semiBold
                                        : MiniAppTypography.regular,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing ??
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: DesignTokens.muted,
                        ),
                  ],
                ),
                if (hasError) ...<Widget>[
                  SizedBox(height: responsive.spacingSm),
                  CustomText(
                    errorText!,
                    variant: MiniAppTextVariant.bodySmall,
                    color: DesignTokens.danger,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
