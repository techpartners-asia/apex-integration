import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/images/images.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../models/overview_dashboard_metrics.dart';

class OverviewDashboardSummaryCard extends StatelessWidget {
  final OverviewDashboardMetrics metrics;
  final VoidCallback? onRecharge;
  final VoidCallback? onStatements;
  final VoidCallback? onWithdraw;

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
                      variant: MiniAppTextVariant.caption,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: InvestXDesignTokens.muted,
                        fontWeight: MiniAppTypography.regular,
                      ),
                    ),
                    SizedBox(height: responsive.dp(4)),
                    CustomText(
                      metrics.shortDisplayName,
                      variant: MiniAppTextVariant.body,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: InvestXDesignTokens.ink,
                            fontWeight: MiniAppTypography.semiBold,
                          ),
                    ),
                    SizedBox(height: responsive.dp(10)),
                    CustomText(
                      metrics.totalInvestmentLabel,
                      variant: MiniAppTextVariant.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: InvestXDesignTokens.rose,
                            fontWeight: MiniAppTypography.semiBold,
                            fontSize: 24,
                            height: 1,
                          ),
                    ),
                    SizedBox(height: responsive.dp(8)),
                    CustomText(
                      l10n.ipsOverviewDashboardProfitMessage(
                        metrics.profitLabel,
                      ),
                      variant: MiniAppTextVariant.bodySmall,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: metrics.profitTone,
                        fontWeight: MiniAppTypography.regular,
                      ),
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
                    variant: MiniAppTextVariant.caption,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: metrics.profitTone,
                      fontWeight: MiniAppTypography.regular,
                    ),
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
                //   color: InvestXDesignTokens.ink,
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

class OverviewDashboardGoalCard extends StatelessWidget {
  const OverviewDashboardGoalCard({super.key, required this.metrics});

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
                  variant: MiniAppTextVariant.headline,
                  fontWeight: MiniAppTypography.semiBold,
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
                  variant: MiniAppTextVariant.caption,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: InvestXDesignTokens.muted,
                  ),
                ),
              ),
              CustomText(
                '${metrics.goalCurrentLabel} / ${metrics.goalTargetLabel}',
                variant: MiniAppTextVariant.caption,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: InvestXDesignTokens.ink,
                  fontWeight: MiniAppTypography.semiBold,
                ),
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
                InvestXDesignTokens.rose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewDashboardRewardCard extends StatelessWidget {
  final int streakMonths;

  const OverviewDashboardRewardCard({super.key, required this.streakMonths});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(responsive.dp(18)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(color: const Color(0xFFF5BBC8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomImage(
            path: Img.fire,
            width: responsive.dp(28),
            height: responsive.dp(28),
          ),
          SizedBox(height: responsive.dp(10)),
          CustomText(
            l10n.ipsOverviewDashboardRewardTitle(streakMonths),
            variant: MiniAppTextVariant.body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: InvestXDesignTokens.ink,
              fontWeight: MiniAppTypography.bold,
            ),
          ),
          SizedBox(height: responsive.dp(8)),
          CustomText(
            l10n.ipsOverviewDashboardRewardBody,
            variant: MiniAppTextVariant.bodySmall,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.ink,
              height: 1.55,
              fontWeight: MiniAppTypography.semiBold,
            ),
          ),
          SizedBox(height: responsive.dp(12)),
          CustomImage(
            path: Img.fire,
            width: responsive.dp(16),
            height: responsive.dp(16),
          ),
          SizedBox(height: responsive.dp(10)),
          Row(
            children: List<Widget>.generate(
              12,
              (int index) => Expanded(
                child: Container(
                  height: responsive.dp(8),
                  margin: EdgeInsets.symmetric(horizontal: responsive.dp(2)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: index < streakMonths
                        ? const LinearGradient(
                            colors: <Color>[
                              InvestXDesignTokens.rose,
                              InvestXDesignTokens.coral,
                            ],
                          )
                        : null,
                    color: index < streakMonths
                        ? null
                        : const Color(0xFFF8E5DE),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardQuickAction extends StatelessWidget {
  final String label;
  final String path;
  final VoidCallback? onTap;
  final bool disabled;

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
                  color: disabled ? InvestXDesignTokens.muted : null,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: responsive.dp(8)),
        CustomText(
          label,
          variant: MiniAppTextVariant.caption,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: disabled
                ? InvestXDesignTokens.muted
                : InvestXDesignTokens.ink,
            fontWeight: MiniAppTypography.semiBold,
          ),
        ),
      ],
    );
  }
}

class _DashboardSurfaceCard extends StatelessWidget {
  const _DashboardSurfaceCard({required this.child, this.padding});

  final Widget child;
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
