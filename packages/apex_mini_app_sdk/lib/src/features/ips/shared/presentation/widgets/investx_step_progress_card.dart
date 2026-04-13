import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';
import 'investx_item.dart';
import 'investx_section_card.dart';
import 'ips_tile.dart';

class InvestXStepProgressCard extends StatelessWidget {
  final String title;
  final String progressLabel;
  final List<InvestXStepItem> steps;

  const InvestXStepProgressCard({
    super.key,
    required this.title,
    required this.progressLabel,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InvestXSectionCard(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
              ),
            ),
            Container(
              width: responsive.dp(44),
              height: responsive.dp(44),
              decoration: BoxDecoration(
                color: InvestXDesignTokens.softSurface,
                shape: BoxShape.circle,
                border: Border.all(color: InvestXDesignTokens.border),
              ),
              alignment: Alignment.center,
              child: Text(
                progressLabel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: InvestXDesignTokens.ink,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing.cardGap),
        ...steps.map(
          (InvestXStepItem step) => Padding(
            padding: EdgeInsets.only(bottom: responsive.spacing.inlineSpacing),
            child: InvestXActionListTile(
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
