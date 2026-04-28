import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class StepProgressCard extends StatelessWidget {
  final String title;
  final String progressLabel;
  final List<StepItem> steps;

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
