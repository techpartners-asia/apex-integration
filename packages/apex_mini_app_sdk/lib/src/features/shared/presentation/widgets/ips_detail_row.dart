import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Label/value row used in portfolio, orders, and account details.
class IpsDetailRow extends StatelessWidget {
  /// Leading label.
  final String label;

  /// Text value shown on the right.
  final String? value;

  /// Custom value widget shown on the right.
  final Widget? valueWidget;

  /// Optional leading icon.
  final IconData? icon;

  /// Creates a label/value detail row.
  const IpsDetailRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
    this.icon,
  }) : assert(
         value != null || valueWidget != null,
         'Either value or valueWidget must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(
              icon,
              size: responsive.spacing.iconSizeSmall + 2,
              color: DesignTokens.muted,
            ),
            SizedBox(width: responsive.spacing.inlineSpacing * 0.75),
          ],
          Expanded(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.body3,
              color: DesignTokens.muted,
            ),
          ),
          SizedBox(width: responsive.spacing.inlineSpacing),
          Align(
            alignment: Alignment.centerRight,
            child:
                valueWidget ??
                CustomText(
                  value!,
                  variant: MiniAppTextVariant.subtitle3,
                  textAlign: TextAlign.end,
                  color: DesignTokens.muted,
                ),
          ),
        ],
      ),
    );
  }
}
