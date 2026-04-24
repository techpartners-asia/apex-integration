import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsQuantitySelectorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final ValueChanged<int> onChanged;
  final bool enabled;
  final String? errorText;

  const IpsQuantitySelectorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.cardRadius,
        border: Border.all(color: DesignTokens.border),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
          ),
          SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: DesignTokens.muted,
              height: 1.45,
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          Row(
            children: <Widget>[
              QuantityButton(
                icon: Icons.remove_rounded,
                enabled: enabled && value > 0,
                onTap: () => onChanged(value > 0 ? value - 1 : 0),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      value.toString(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: MiniAppTypography.bold,
                        color: DesignTokens.ink,
                      ),
                    ),
                    Text(
                      l10n.commonPackUnit,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: DesignTokens.muted,
                        letterSpacing: 1.4,
                        fontWeight: MiniAppTypography.bold,
                      ),
                    ),
                  ],
                ),
              ),
              QuantityButton(
                icon: Icons.add_rounded,
                enabled: enabled,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
          if (errorText != null && errorText!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing),
            CustomText(
              errorText!,
              variant: MiniAppTextVariant.bodySmall,
              color: DesignTokens.danger,
            ),
          ],
        ],
      ),
    );
  }
}
