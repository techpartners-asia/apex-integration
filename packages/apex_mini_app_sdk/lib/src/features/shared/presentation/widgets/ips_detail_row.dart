import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsDetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final IconData? icon;

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
              variant: MiniAppTextVariant.bodySmall,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: DesignTokens.muted,
                fontWeight: MiniAppTypography.regular,
              ),
            ),
          ),
          SizedBox(width: responsive.spacing.inlineSpacing),
          Align(
            alignment: Alignment.centerRight,
            child:
                valueWidget ??
                CustomText(
                  value!,
                  variant: MiniAppTextVariant.body,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: DesignTokens.muted,
                    fontWeight: MiniAppTypography.semiBold
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
