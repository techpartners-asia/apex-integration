import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ConsentCheckboxRow extends StatelessWidget {
  final String label;
  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;
  final Color activeColor;

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
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: activeColor,
                  fontWeight: MiniAppTypography.regular,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
