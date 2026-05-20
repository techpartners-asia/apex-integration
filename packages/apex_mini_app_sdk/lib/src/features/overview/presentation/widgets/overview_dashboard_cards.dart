import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Top overview card with greeting, investment total, and quick actions.
class OverviewDashboardSummaryCard extends StatelessWidget {
  /// Presentation-ready dashboard metrics.
  final OverviewDashboardMetrics metrics;

  /// Recharge action.
  final VoidCallback? onRecharge;

  /// Statements action.
  final VoidCallback? onStatements;

  /// Withdraw action, currently disabled in the UI.
  final VoidCallback? onWithdraw;

  /// Creates the dashboard summary card.
  const OverviewDashboardSummaryCard({
    super.key,
    required this.metrics,
    this.onRecharge,
    this.onStatements,
    this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return _DashboardSurfaceCard(
      padding: EdgeInsets.all(responsive.dp(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      l10n.ipsOverviewDashboardGreetingLabel,
                      variant: MiniAppTextVariant.caption1,
                      color: DesignTokens.muted,
                    ),
                    SizedBox(height: responsive.dp(4)),
                    CustomText(
                      metrics.shortDisplayName,
                      variant: MiniAppTextVariant.h8,
                      color: DesignTokens.ink,
                    ),
                    SizedBox(height: responsive.dp(10)),
                    CustomText(
                      metrics.totalInvestmentLabel,
                      variant: MiniAppTextVariant.h7,
                      color: DesignTokens.rose,
                    ),
                    SizedBox(height: responsive.dp(8)),
                    CustomText(
                      l10n.ipsOverviewDashboardProfitMessage(
                        metrics.profitLabel,
                      ),
                      variant: MiniAppTextVariant.body2,
                      color: metrics.profitTone,
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.dp(14)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomImage(
                    path: Img.sun,
                    width: responsive.dp(50),
                    height: responsive.dp(50),
                  ),
                  SizedBox(height: responsive.dp(10)),
                  CustomText(
                    metrics.profitPercentLabel,
                    variant: MiniAppTextVariant.body2,
                    color: metrics.profitTone,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: responsive.dp(18)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _DashboardQuickAction(
                label: l10n.ipsOverviewDashboardQuickRecharge,
                path: Img.add,
                // icon: const Icon(
                //   Icons.add_circle_outline_rounded,
                //   color: DesignTokens.ink,
                // ),
                onTap: onRecharge,
              ),
              _DashboardQuickAction(
                label: l10n.ipsPortfolioStatements,
                path: Img.stmt,
                onTap: onStatements,
              ),
              _DashboardQuickAction(
                label: l10n.ipsOverviewDashboardQuickWithdraw,
                path: Img.receive,
                onTap: onWithdraw,
                disabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Goal progress card on the overview dashboard.
class OverviewDashboardGoalCard extends StatelessWidget {
  /// Creates the goal card.
  const OverviewDashboardGoalCard({super.key, required this.metrics});

  /// Metrics used to calculate and label goal progress.
  final OverviewDashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;
    final double progress = (metrics.goalCurrent / metrics.goalTarget).clamp(
      0.0,
      1.0,
    );

    return _DashboardSurfaceCard(
      padding: EdgeInsets.all(responsive.dp(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              CustomImage(
                path: Img.money,
                width: responsive.dp(32),
                height: responsive.dp(32),
              ),
              SizedBox(width: responsive.dp(10)),
              Expanded(
                child: CustomText(
                  l10n.ipsOverviewDashboardGoalTitle,
                  variant: MiniAppTextVariant.h8,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.dp(16)),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomText(
                  l10n.ipsOverviewDashboardGoalProgress,
                  variant: MiniAppTextVariant.caption2,
                  color: DesignTokens.muted,
                ),
              ),
              CustomText(
                '${metrics.totalInvestmentLabel} / ${metrics.goalTargetLabel}',
                variant: MiniAppTextVariant.caption1,
                color: DesignTokens.ink,
              ),
            ],
          ),
          SizedBox(height: responsive.dp(8)),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: responsive.dp(8),
              backgroundColor: const Color(0xFFF7D6D0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                DesignTokens.rose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reward/streak card displayed on the overview dashboard.
class OverviewDashboardRewardCard extends StatelessWidget {
  /// Number of completed streak months.
  final int streakMonths;

  /// Creates the reward card.
  const OverviewDashboardRewardCard({super.key, required this.streakMonths});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;
    final int clampedStreakMonths = streakMonths.clamp(0, 12).toInt();
    final BorderRadius cardRadius = BorderRadius.circular(
      responsive.radius(16),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            DesignTokens.rose,
            DesignTokens.coral,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: cardRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.dp(1.6)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              DesignTokens.rose.withValues(alpha: 0.08),
              Colors.white,
            ),
            borderRadius: cardRadius,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.dp(16),
              responsive.dp(10),
              responsive.dp(16),
              responsive.dp(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomImage(
                  path: Img.fireFull,
                  width: responsive.dp(38),
                  height: responsive.dp(48),
                ),
                SizedBox(height: responsive.dp(18)),
                CustomText(
                  l10n.ipsOverviewDashboardRewardTitle(clampedStreakMonths),
                  variant: MiniAppTextVariant.body1,
                  textAlign: TextAlign.center,
                  color: Colors.black,
                ),
                SizedBox(height: responsive.dp(18)),
                _RewardBodyText(text: l10n.ipsOverviewDashboardRewardBody),
                SizedBox(height: responsive.dp(28)),
                _RewardProgressBar(months: clampedStreakMonths),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reward card body text with optional highlighted coupon wording.
class _RewardBodyText extends StatelessWidget {
  /// Creates reward body text.
  const _RewardBodyText({required this.text});

  /// Text fragments that should be highlighted if present in localized copy.
  static const List<String> _highlightCandidates = <String>[
    '5000 Tino Coupon',
    '5000 Tino Coin',
  ];

  /// Full body text.
  final String text;

  @override
  Widget build(BuildContext context) {
    String? highlight;
    for (final String candidate in _highlightCandidates) {
      if (text.contains(candidate)) {
        highlight = candidate;
        break;
      }
    }

    if (highlight == null) {
      return CustomText(
        text,
        variant: MiniAppTextVariant.subtitle3,
        textAlign: TextAlign.center,
        color: Colors.black,
        softWrap: true,
        overflow: TextOverflow.visible,
      );
    }

    final int start = text.indexOf(highlight);
    final String before = text.substring(0, start);
    final String after = text.substring(start + highlight.length);
    final TextStyle bodyStyle = MiniAppTypography.subtitle3.copyWith(
      color: Colors.black,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: bodyStyle,
        children: <InlineSpan>[
          TextSpan(text: before),
          TextSpan(
            text: highlight,
            style: bodyStyle.copyWith(color: DesignTokens.softPeach),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}

/// Segmented 12-month reward progress bar.
class _RewardProgressBar extends StatelessWidget {
  /// Completed month count.
  final int months;

  /// Creates the reward progress bar.
  const _RewardProgressBar({required this.months});

  /// Number of months represented by the bar.
  static const int _monthCount = 12;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double barHeight = responsive.dp(16);
    final double markerSize = responsive.dp(25);
    final double progress = months / _monthCount;

    return SizedBox(
      height: markerSize,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double markerLeft = (maxWidth * progress - markerSize / 2)
              .clamp(0.0, maxWidth - markerSize)
              .toDouble();

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: barHeight,
                  child: Row(
                    children: List<Widget>.generate(
                      _monthCount * 2 - 1,
                      (int index) {
                        if (index.isOdd) {
                          return Container(
                            width: responsive.dp(2),
                            color: Colors.white,
                          );
                        }

                        final int segmentIndex = index ~/ 2;
                        final bool completed = segmentIndex < months;

                        return Expanded(
                          child: ColoredBox(
                            color: completed
                                ? DesignTokens.rose
                                : DesignTokens.softPeach.withValues(
                                    alpha: 0.55,
                                  ),
                            child: SizedBox(height: barHeight),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                left: markerLeft,
                child: CustomImage(
                  path: Img.fireFull,
                  height: markerSize,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Dashboard quick action icon and label.
class _DashboardQuickAction extends StatelessWidget {
  /// Action label.
  final String label;

  /// Image asset path for the icon.
  final String path;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Whether the action should render disabled.
  final bool disabled;

  /// Creates a dashboard quick action.
  const _DashboardQuickAction({
    required this.label,
    required this.path,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.responsive.dp(50),
          height: context.responsive.dp(50),
          child: MiniAppAdaptivePressable(
            onPressed: onTap,
            enabled: !disabled,
            borderRadius: BorderRadius.circular(responsive.radius(14)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: responsive.dp(4)),
              child: Center(
                child: CustomImage(
                  path: path,
                  width: responsive.dp(18),
                  height: responsive.dp(18),
                  color: disabled ? DesignTokens.muted : null,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: responsive.dp(8)),
        CustomText(
          label,
          variant: MiniAppTextVariant.overline1,
          textAlign: TextAlign.center,
          color: disabled ? DesignTokens.muted : DesignTokens.ink,
        ),
      ],
    );
  }
}

/// Shared white surface card used by dashboard sections.
class _DashboardSurfaceCard extends StatelessWidget {
  /// Creates a dashboard surface card.
  const _DashboardSurfaceCard({required this.child, this.padding});

  /// Card content.
  final Widget child;

  /// Optional card padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: child,
    );
  }
}
