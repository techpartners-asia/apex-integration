import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class InvestXFlowProgressHeader extends StatelessWidget {
  final int total;
  final int activeIndex;
  final String title;
  final String progressLabel;
  final String? overline;
  final String? subtitle;
  final Widget? child;

  const InvestXFlowProgressHeader({
    super.key,
    required this.total,
    required this.activeIndex,
    required this.title,
    required this.progressLabel,
    this.overline,
    this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InvestXProgressSegments(total: total, activeIndex: activeIndex),
        SizedBox(height: responsive.spacing.sectionSpacing),
        Column(
          children: <Widget>[
            if (overline != null && overline!.trim().isNotEmpty) ...<Widget>[
              Text(
                overline!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: InvestXDesignTokens.rose,
                ),
              ),
              SizedBox(height: responsive.spacing.cardGap),
            ],
            CustomText(title, variant: MiniAppTextVariant.headline),
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...<Widget>[
              SizedBox(height: responsive.spacing.inlineSpacing),
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (child != null) ...<Widget>[
              SizedBox(height: responsive.spacing.sectionSpacing),
              child!,
            ],
          ],
        ),
      ],
    );
  }
}

class InvestXProgressSegments extends StatelessWidget {
  final int total;
  final int activeIndex;

  const InvestXProgressSegments({
    super.key,
    required this.total,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Row(
      children: List<Widget>.generate(total, (int index) {
        final bool active = index <= activeIndex;
        return Expanded(
          child: Container(
            height: responsive.dp(3),
            margin: EdgeInsets.only(
              right: index == total - 1 ? 0 : responsive.dp(6),
            ),
            decoration: BoxDecoration(
              color: active
                  ? (index == activeIndex
                        ? InvestXDesignTokens.rose
                        : InvestXDesignTokens.coral.withValues(alpha: 0.6))
                  : InvestXDesignTokens.border,
              borderRadius: InvestXDesignTokens.pillRadius,
            ),
          ),
        );
      }),
    );
  }
}
