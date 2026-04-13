import 'package:flutter/material.dart';
import '../../../sec_acnt/presentation/flow/sec_acnt_flow.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXSelectorField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool hasValue;
  final Widget? trailing;
  final SecAcntBankOption? selectedValue;
  final String? errorText;
  final bool enabled;

  const InvestXSelectorField({
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
              color: hasError ? InvestXDesignTokens.danger : Colors.transparent,
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
                            color: InvestXDesignTokens.muted,
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
                                          color: InvestXDesignTokens.muted,
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
                                        ? InvestXDesignTokens.ink
                                        : InvestXDesignTokens.muted,
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
                          color: InvestXDesignTokens.muted,
                        ),
                  ],
                ),
                if (hasError) ...<Widget>[
                  SizedBox(height: responsive.spacingSm),
                  CustomText(
                    errorText!,
                    variant: MiniAppTextVariant.bodySmall,
                    color: InvestXDesignTokens.danger,
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
