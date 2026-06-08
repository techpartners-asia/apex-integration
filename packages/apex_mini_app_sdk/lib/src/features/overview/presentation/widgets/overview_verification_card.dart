import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Card that shows account setup progress and next recommended action.
class OverviewVerificationCard extends StatelessWidget {
  /// View model describing progress, steps, and promo action.
  final OverviewVerificationViewModel viewModel;

  /// Whether compact spacing should be used.
  final bool compact;

  /// Creates an overview verification card.
  const OverviewVerificationCard({
    super.key,
    required this.viewModel,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double progress =
        (viewModel.progressCurrent / viewModel.progressTotal).clamp(0.0, 1.0);

    return MiniAppGlassCard(
      radius: responsive.radius(16),
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomImage(
                      path: Img.wallet,
                      width: responsive.dp(32),
                      height: responsive.dp(32),
                    ),
                    SizedBox(height: responsive.dp(10)),
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
                  ? _OverviewPromoCard(onTap: viewModel.onPromoTap)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular progress indicator for account setup completion.
class _ProgressRing extends StatelessWidget {
  /// Completed step count.
  final int current;

  /// Total step count.
  final int total;

  /// Normalized progress value from 0 to 1.
  final double progress;

  /// Creates the setup progress ring.
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

/// Timeline row for one verification/onboarding step.
class _OverviewTimelineRow extends StatelessWidget {
  /// Step to render.
  final OverviewVerificationStep step;

  /// Optional footer rendered beside the timeline icon on the last step.
  final Widget? footer;

  /// Creates a verification timeline row.
  const _OverviewTimelineRow({
    required this.step,
    this.footer,
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
    final bool isTappable = step.onTap != null;
    final Color chevronColor = switch (step.status) {
      StepStatus.upcoming => DesignTokens.border,
      _ => DesignTokens.muted,
    };
    final Widget iconColumn = _OverviewTimelineIconColumn(
      imagePath: img,
      accent: accent,
      showConnector: footer == null && !step.isLast,
    );

    if (footer != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          iconColumn,
          SizedBox(width: responsive.dp(12)),
          Expanded(child: footer!),
        ],
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: step.onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            iconColumn,
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
            if (isTappable) ...<Widget>[
              SizedBox(width: responsive.dp(8)),
              Padding(
                padding: EdgeInsets.only(top: responsive.dp(2)),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: chevronColor,
                  size: responsive.dp(20),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Timeline icon and optional connector rendered beside a step or promo card.
class _OverviewTimelineIconColumn extends StatelessWidget {
  const _OverviewTimelineIconColumn({
    required this.imagePath,
    required this.accent,
    required this.showConnector,
  });

  final String imagePath;
  final Color accent;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: responsive.dp(28),
          child: Center(
            child: CustomImage(
              path: imagePath,
              width: responsive.dp(20),
              height: responsive.dp(20),
            ),
          ),
        ),
        if (showConnector)
          Container(
            width: responsive.dp(2),
            height: responsive.dp(50),
            margin: EdgeInsets.symmetric(
              vertical: responsive.dp(4),
            ),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

/// Promo/action card rendered at the end of the verification timeline.
class _OverviewPromoCard extends StatelessWidget {
  /// Creates the promo card.
  const _OverviewPromoCard({this.onTap});

  /// Optional promo action.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return ClipRRect(
      borderRadius: BorderRadius.circular(responsive.radius(16)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(responsive.radius(16)),
          image: DecorationImage(
            image: AssetImage(Img.cardPack, package: packageName),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.dp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomText(
                l10n.ipsOverviewFinalStepLabel,
                variant: MiniAppTextVariant.caption1,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              SizedBox(height: responsive.dp(4)),
              CustomText(
                l10n.ipsOverviewFirstPackTitle,
                variant: MiniAppTextVariant.subtitle2,
                color: Colors.white,
              ),
              SizedBox(height: responsive.dp(14)),
              Align(
                alignment: Alignment.centerLeft,
                child: _OverviewPromoGlassButton(onTap: onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Frosted-glass CTA used on the promo card background.
class _OverviewPromoGlassButton extends StatelessWidget {
  const _OverviewPromoGlassButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;
    final BorderRadius borderRadius = BorderRadius.circular(responsive.radiusSm);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: responsive.dp(10),
              sigmaY: responsive.dp(10),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.55),
                  width: responsive.dp(1),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.12),
                    blurRadius: responsive.dp(10),
                    offset: Offset(0, responsive.dp(2)),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.dp(16),
                  vertical: responsive.dp(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomText(
                      l10n.ipsPackChoosePack,
                      variant: MiniAppTextVariant.buttonSmall,
                      color: Colors.white,
                    ),
                    SizedBox(width: responsive.dp(4)),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: responsive.dp(20),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
