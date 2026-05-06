import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class OverviewVerificationCard extends StatelessWidget {
  final OverviewVerificationViewModel viewModel;
  final bool compact;

  const OverviewVerificationCard({
    super.key,
    required this.viewModel,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double progress = (viewModel.progressCurrent / viewModel.progressTotal).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomImage(
            path: Img.wallet,
            width: responsive.dp(32),
            height: responsive.dp(32),
          ),
          SizedBox(height: responsive.dp(10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      viewModel.title,
                      variant: MiniAppTextVariant.subtitle2,
                    ),
                    SizedBox(height: responsive.dp(6)),
                    CustomText(
                      viewModel.subtitle,
                      variant: MiniAppTextVariant.caption1,
                      color: DesignTokens.muted,
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.dp(10)),
              _ProgressRing(
                current: viewModel.progressCurrent,
                total: viewModel.progressTotal,
                progress: progress,
              ),
            ],
          ),
          SizedBox(height: responsive.dp(18)),
          ...viewModel.steps.map(
            (OverviewVerificationStep step) => _OverviewTimelineRow(
              step: step,
              footer: step.isLast
                  ? _OverviewPromoCard(
                      eyebrow: viewModel.promoEyebrow,
                      title: viewModel.promoTitle,
                      buttonLabel: viewModel.promoButtonLabel,
                      onTap: viewModel.onPromoTap,
                    )
                  : null,
              footerSpacing: compact ? responsive.dp(6) : responsive.dp(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final int current;
  final int total;
  final double progress;

  const _ProgressRing({
    required this.current,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      width: responsive.dp(64),
      height: responsive.dp(64),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: responsive.dp(8),
              backgroundColor: DesignTokens.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                DesignTokens.coral,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          CustomText(
            '$current/$total',
            variant: MiniAppTextVariant.subtitle2,
            color: DesignTokens.ink,
          ),
        ],
      ),
    );
  }
}

class _OverviewTimelineRow extends StatelessWidget {
  final OverviewVerificationStep step;
  final Widget? footer;
  final double footerSpacing;

  const _OverviewTimelineRow({
    required this.step,
    this.footer,
    this.footerSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color accent = switch (step.status) {
      StepStatus.completed => DesignTokens.success,
      StepStatus.active => DesignTokens.rose,
      StepStatus.upcoming => DesignTokens.border,
    };
    final Color textColor = switch (step.status) {
      StepStatus.upcoming => DesignTokens.muted,
      _ => DesignTokens.ink,
    };
    final String img = switch (step.status) {
      StepStatus.completed => Img.checkCircle,
      StepStatus.active => Img.singleLock,
      StepStatus.upcoming => Img.singleLock,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Material(
          color: DesignTokens.white,
          child: InkWell(
            onTap: step.onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: responsive.dp(28),
                      child: Center(
                        child: CustomImage(
                          path: img,
                          width: responsive.dp(20),
                          height: responsive.dp(20),
                        ),
                      ),
                    ),
                    if (!step.isLast)
                      Container(
                        width: responsive.dp(2),
                        height: responsive.dp(50),
                        margin: EdgeInsets.symmetric(vertical: responsive.dp(4)),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: responsive.dp(12)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: responsive.dp(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          step.title,
                          variant: MiniAppTextVariant.subtitle3,
                          color: textColor,
                        ),
                        SizedBox(height: responsive.dp(4)),
                        CustomText(
                          step.subtitle,
                          variant: MiniAppTextVariant.caption1,
                          color: DesignTokens.muted,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (footer != null) ...<Widget>[
          SizedBox(height: footerSpacing),
          footer!,
        ],
      ],
    );
  }
}

class _OverviewPromoCard extends StatelessWidget {
  const _OverviewPromoCard({
    required this.eyebrow,
    required this.title,
    required this.buttonLabel,
    this.onTap,
  });

  final String eyebrow;
  final String title;
  final String buttonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.all(responsive.dp(16)),
      decoration: BoxDecoration(
        color: DesignTokens.softSurface,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomText(
            eyebrow,
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.rose,
          ),
          SizedBox(height: responsive.dp(4)),
          CustomText(
            title,
            variant: MiniAppTextVariant.subtitle3,
            color: DesignTokens.ink,
          ),
          SizedBox(height: responsive.dp(14)),
          PrimaryButton(
            label: buttonLabel,
            onPressed: onTap,
            height: responsive.dp(42),
          ),
        ],
      ),
    );
  }
}
