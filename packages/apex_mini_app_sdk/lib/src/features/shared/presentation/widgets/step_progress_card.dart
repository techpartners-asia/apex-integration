import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Card that renders a progress label and a list of actionable steps.
class StepProgressCard extends StatelessWidget {
  /// Card title.
  final String title;

  /// Compact progress label, for example `1/3`.
  final String progressLabel;

  /// Step rows shown inside the card.
  final List<StepItem> steps;

  /// Creates a step progress card.
  const StepProgressCard({
    super.key,
    required this.title,
    required this.progressLabel,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SectionCard(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomText(
                title,
                variant: MiniAppTextVariant.subtitle2,
              ),
            ),
            Container(
              width: responsive.dp(44),
              height: responsive.dp(44),
              decoration: BoxDecoration(
                color: DesignTokens.softSurface,
                shape: BoxShape.circle,
                border: Border.all(color: DesignTokens.border),
              ),
              alignment: Alignment.center,
              child: CustomText(
                progressLabel,
                variant: MiniAppTextVariant.buttonMedium,
                color: DesignTokens.ink,
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing.cardGap),
        ...steps.map(
          (StepItem step) => Padding(
            padding: EdgeInsets.only(bottom: responsive.spacing.inlineSpacing),
            child: ActionListTile(
              title: step.title,
              status: step.status,
              onTap: step.onTap,
            ),
          ),
        ),
      ],
    );
  }
}
