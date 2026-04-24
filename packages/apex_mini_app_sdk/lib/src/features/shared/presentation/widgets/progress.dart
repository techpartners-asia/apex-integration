import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class FlowProgressHeader extends StatelessWidget {
  final int total;
  final int activeIndex;
  final String title;
  final String progressLabel;
  final String? overline;
  final String? subtitle;
  final Widget? child;

  const FlowProgressHeader({
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
        ProgressSegments(total: total, activeIndex: activeIndex),
        SizedBox(height: responsive.spacing.sectionSpacing),
        Column(
          children: <Widget>[
            if (overline != null && overline!.trim().isNotEmpty) ...<Widget>[
              Text(
                overline!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: DesignTokens.rose,
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

class ProgressSegments extends StatelessWidget {
  final int total;
  final int activeIndex;

  const ProgressSegments({
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
                        ? DesignTokens.rose
                        : DesignTokens.coral.withValues(alpha: 0.6))
                  : DesignTokens.border,
              borderRadius: DesignTokens.pillRadius,
            ),
          ),
        );
      }),
    );
  }
}
