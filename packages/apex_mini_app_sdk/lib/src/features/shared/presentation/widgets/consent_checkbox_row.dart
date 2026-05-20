import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Inline consent checkbox row used by agreement/contract screens.
class ConsentCheckboxRow extends StatelessWidget {
  /// Consent label text.
  final String label;

  /// Whether the consent is currently accepted.
  final bool accepted;

  /// Called with the new accepted value when the row is tapped.
  final ValueChanged<bool> onAcceptedChanged;

  /// Active checkbox and label color.
  final Color activeColor;

  /// Creates an inline consent checkbox row.
  const ConsentCheckboxRow({
    super.key,
    required this.label,
    required this.accepted,
    required this.onAcceptedChanged,
    this.activeColor = DesignTokens.rose,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color checkboxColor = accepted
        ? activeColor
        : DesignTokens.agreementUnchecked;

    return InkWell(
      onTap: () => onAcceptedChanged(!accepted),
      borderRadius: BorderRadius.circular(responsive.radius(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: responsive.dp(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: responsive.dp(14),
              height: responsive.dp(14),
              margin: responsive.insetsOnly(top: 3),
              decoration: BoxDecoration(
                color: accepted ? checkboxColor : Colors.transparent,
                borderRadius: BorderRadius.circular(responsive.radius(4)),
                border: Border.all(color: checkboxColor, width: 1.2),
              ),
              child: accepted
                  ? Icon(
                      Icons.check_rounded,
                      size: responsive.dp(10),
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: responsive.dp(8)),
            Expanded(
              child: CustomText(
                label,
                variant: MiniAppTextVariant.caption1,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
