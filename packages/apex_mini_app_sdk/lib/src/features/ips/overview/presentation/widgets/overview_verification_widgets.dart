import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../app/investx_api/dto/user_entity_dto.dart';
import '../../../../../routes/mini_app_routes.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../contract/presentation/models/contract_payload.dart';
import '../../../pack/presentation/screens/pack_selection_screen.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/images/images.dart';
import '../../../shared/presentation/helpers/ips_navigation.dart';
import '../../../shared/presentation/widgets/widgets.dart';

class OverviewHomeTab extends StatelessWidget {
  final AcntBootstrapState data;
  final UserEntityDto? user;
  final List<IpsPack> packs;
  final RefreshCallback? onRefresh;

  const OverviewHomeTab({
    super.key,
    required this.data,
    this.user,
    this.packs = const <IpsPack>[],
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (packs.isNotEmpty && data.hasOpenSecAcnt) {
      return _PackRecommendationView(
        data: data,
        user: user,
        packs: packs,
        onRefresh: onRefresh,
      );
    }

    final OverviewVerificationViewModel viewModel = buildOverviewVerificationViewModel(context, data);

    if (onRefresh == null) {
      return OverviewVerificationCard(viewModel: viewModel);
    }

    return MiniAppRefreshContainer(
      onRefresh: onRefresh,
      fillHeight: false,
      padding: EdgeInsets.fromLTRB(
        context.responsive.spacing.financialCardSpacing,
        context.responsive.dp(10),
        context.responsive.spacing.financialCardSpacing,
        context.responsive.dp(118),
      ),
      child: OverviewVerificationCard(viewModel: viewModel),
    );
  }
}

class _PackRecommendationView extends StatelessWidget {
  const _PackRecommendationView({
    required this.data,
    required this.packs,
    this.user,
    this.onRefresh,
  });

  final AcntBootstrapState data;
  final UserEntityDto? user;
  final List<IpsPack> packs;
  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final String displayName = user?.displayName ?? '';

    final Widget scrollView = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _PackRecommendationGreeting(displayName: displayName),
        SizedBox(height: responsive.dp(18)),
        CustomText(
          l10n.ipsOverviewPackPrompt,
          variant: MiniAppTextVariant.body,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: InvestXDesignTokens.ink,
            fontWeight: MiniAppTypography.bold,
          ),
        ),
        SizedBox(height: responsive.dp(14)),
        ...List<Widget>.generate(
          packs.length,
          (int index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == packs.length - 1 ? 0 : responsive.dp(18),
            ),
            child: _PackRecommendationCard(
              pack: packs[index],
              stackIndex: index,
            ),
          ),
        ),
      ],
    );

    return MiniAppRefreshContainer(
      onRefresh: onRefresh,
      padding: EdgeInsets.fromLTRB(
        responsive.spacing.financialCardSpacing,
        responsive.dp(8),
        responsive.spacing.financialCardSpacing,
        responsive.dp(118),
      ),
      child: scrollView,
    );
  }
}

class _PackRecommendationGreeting extends StatelessWidget {
  const _PackRecommendationGreeting({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return Row(
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
              if (displayName.isNotEmpty)
                CustomText(
                  displayName,
                  variant: MiniAppTextVariant.body,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: InvestXDesignTokens.ink,
                    fontWeight: MiniAppTypography.bold,
                    height: 1.05,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: responsive.dp(12)),
        Container(
          width: responsive.dp(48),
          height: responsive.dp(48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.radius(18)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x120F172A),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(responsive.dp(8)),
          child: CustomImage(path: Img.sun),
        ),
      ],
    );
  }
}

class _PackRecommendationCard extends StatelessWidget {
  const _PackRecommendationCard({
    required this.pack,
    required this.stackIndex,
  });

  final IpsPack pack;
  final int stackIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(24)),
        border: Border.all(color: const Color(0xFFF0F2F7)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          responsive.dp(12),
          responsive.dp(12),
          responsive.dp(12),
          responsive.dp(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _PackRecommendationHero(pack: pack, stackIndex: stackIndex),
            SizedBox(height: responsive.dp(18)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.dp(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CustomImage(
                        path: Img.trophyBlue,
                        width: responsive.dp(18),
                        height: responsive.dp(18),
                      ),
                      SizedBox(width: responsive.dp(8)),
                      Expanded(
                        child: CustomText(
                          l10n.ipsPackPerfectFit,
                          variant: MiniAppTextVariant.body,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: InvestXDesignTokens.ink,
                            fontWeight: MiniAppTypography.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.dp(14)),
                  ...buildPackBenefits(context, pack),
                  SizedBox(height: responsive.dp(14)),
                  Center(
                    child: SizedBox(
                      width: responsive.dp(138),
                      child: InvestXPrimaryButton(
                        label: l10n.ipsPackChoosePack,
                        height: responsive.dp(38),
                        borderRadius: BorderRadius.circular(
                          responsive.radius(999),
                        ),
                        onPressed: () {
                          launchIpsRoute(
                            context,
                            route: MiniAppRoutes.contract,
                            arguments: ContractPayload(pack: pack),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackRecommendationHero extends StatelessWidget {
  const _PackRecommendationHero({
    required this.pack,
    required this.stackIndex,
  });

  final IpsPack pack;
  final int stackIndex;

  bool get _isWarmVariant => pack.isRecommended == 1 || stackIndex == 0;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final BorderRadius borderRadius = BorderRadius.circular(
      responsive.radius(22),
    );

    return SizedBox(
      height: responsive.dp(176),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: responsive.dp(18),
            right: responsive.dp(18),
            top: responsive.dp(12),
            child: _PackRecommendationStackPlate(
              color: _isWarmVariant ? const Color(0x1EE96E96) : const Color(0x143F7E9F),
            ),
          ),
          Positioned(
            left: responsive.dp(10),
            right: responsive.dp(10),
            top: responsive.dp(6),
            child: _PackRecommendationStackPlate(
              color: _isWarmVariant ? const Color(0x24F59CB5) : const Color(0x1E5A93AD),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: _isWarmVariant
                    ? const LinearGradient(
                        colors: <Color>[
                          InvestXDesignTokens.rose,
                          InvestXDesignTokens.softPeach,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : const LinearGradient(
                        colors: <Color>[
                          Color(0xFF9C7A9F),
                          Color(0xFF3AA3A6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x140F172A),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      _isWarmVariant ? Img.pack1 : Img.pack2,
                      package: 'mini_app_sdk',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white.withValues(alpha: 0.02),
                            Colors.black.withValues(alpha: 0.10),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        responsive.dp(20),
                        responsive.dp(16),
                        responsive.dp(20),
                        responsive.dp(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CustomText(
                            pack.name,
                            variant: MiniAppTextVariant.caption,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontWeight: MiniAppTypography.regular,
                            ),
                          ),
                          SizedBox(height: responsive.dp(4)),
                          CustomText(
                            pack.packDesc ?? pack.name2 ?? pack.name,
                            textAlign: TextAlign.center,
                            variant: MiniAppTextVariant.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: MiniAppTypography.bold,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: responsive.dp(12)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.dp(16),
                              vertical: responsive.dp(6),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(
                                responsive.radius(999),
                              ),
                            ),
                            child: CustomText(
                              context.l10n.ipsPackAllocationValue(
                                pack.bondPercent.toStringAsFixed(0),
                                pack.stockPercent.toStringAsFixed(0),
                              ),
                              variant: MiniAppTextVariant.caption,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: MiniAppTypography.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackRecommendationStackPlate extends StatelessWidget {
  const _PackRecommendationStackPlate({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      height: responsive.dp(156),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(responsive.radius(22)),
      ),
    );
  }
}

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
                      variant: MiniAppTextVariant.title,
                    ),
                    SizedBox(height: responsive.dp(6)),
                    CustomText(
                      viewModel.subtitle,
                      variant: MiniAppTextVariant.bodySmall,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: InvestXDesignTokens.muted,
                      ),
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
              backgroundColor: InvestXDesignTokens.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                InvestXDesignTokens.coral,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          CustomText(
            '$current/$total',
            variant: MiniAppTextVariant.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
              color: InvestXDesignTokens.ink,
            ),
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
      InvestXStepStatus.completed => InvestXDesignTokens.success,
      InvestXStepStatus.active => InvestXDesignTokens.rose,
      InvestXStepStatus.upcoming => InvestXDesignTokens.border,
    };
    final Color textColor = switch (step.status) {
      InvestXStepStatus.upcoming => InvestXDesignTokens.muted,
      _ => InvestXDesignTokens.ink,
    };
    final String img = switch (step.status) {
      InvestXStepStatus.completed => Img.checkCircle,
      InvestXStepStatus.active => Img.singleLock,
      InvestXStepStatus.upcoming => Img.singleLock,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InkWell(
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
                        variant: MiniAppTextVariant.body,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: textColor,
                          fontWeight: step.status == InvestXStepStatus.upcoming ? MiniAppTypography.semiBold : MiniAppTypography.bold,
                        ),
                      ),
                      SizedBox(height: responsive.dp(4)),
                      CustomText(
                        step.subtitle,
                        variant: MiniAppTextVariant.bodySmall,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: InvestXDesignTokens.muted,
                          height: 1.45,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
        color: InvestXDesignTokens.softSurface,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(color: InvestXDesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomText(
            eyebrow,
            variant: MiniAppTextVariant.caption,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: InvestXDesignTokens.rose,
              fontWeight: MiniAppTypography.semiBold,
            ),
          ),
          SizedBox(height: responsive.dp(4)),
          CustomText(
            title,
            variant: MiniAppTextVariant.body,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: InvestXDesignTokens.ink,
              fontWeight: MiniAppTypography.bold,
              height: 1.35,
            ),
          ),
          SizedBox(height: responsive.dp(14)),
          InvestXPrimaryButton(
            label: buttonLabel,
            onPressed: onTap,
            height: responsive.dp(42),
          ),
        ],
      ),
    );
  }
}

class OverviewVerificationStep {
  const OverviewVerificationStep({
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final InvestXStepStatus status;
  final VoidCallback? onTap;
  final bool isLast;
}

class OverviewVerificationViewModel {
  final String title;
  final String subtitle;
  final int progressCurrent;
  final int progressTotal;
  final List<OverviewVerificationStep> steps;
  final String promoEyebrow;
  final String promoTitle;
  final String promoButtonLabel;
  final VoidCallback? onPromoTap;

  const OverviewVerificationViewModel({
    required this.title,
    required this.subtitle,
    required this.progressCurrent,
    required this.progressTotal,
    required this.steps,
    required this.promoEyebrow,
    required this.promoTitle,
    required this.promoButtonLabel,
    this.onPromoTap,
  });
}

OverviewVerificationViewModel buildOverviewVerificationViewModel(BuildContext context, AcntBootstrapState state) {
  final l10n = context.l10n;

  if (!state.hasAcnt) {
    return OverviewVerificationViewModel(
      title: l10n.ipsOverviewVerificationTitle,
      subtitle: l10n.ipsOverviewVerificationSubtitle,
      progressCurrent: 0,
      progressTotal: 3,
      steps: <OverviewVerificationStep>[
        OverviewVerificationStep(
          title: l10n.ipsOverviewProfileMenuPersonalInfo,
          subtitle: l10n.ipsOverviewProfilePersonalInfoMissing,
          status: InvestXStepStatus.active,
          onTap: () => launchIpsRoute(context, route: MiniAppRoutes.personalInfo),
        ),
        OverviewVerificationStep(
          title: l10n.ipsAcntOpenAcnt,
          subtitle: l10n.ipsAcntFlowBody,
          status: InvestXStepStatus.upcoming,
        ),
        OverviewVerificationStep(
          title: l10n.ipsOverviewFinalStepLabel,
          subtitle: l10n.ipsQuestionnaireViewPacks,
          status: InvestXStepStatus.upcoming,
          isLast: true,
        ),
      ],
      promoEyebrow: l10n.ipsOverviewProfileMenuPackInfo,
      promoTitle: l10n.ipsOverviewFirstPackTitle,
      promoButtonLabel: l10n.commonContinue,
      onPromoTap: () => launchIpsRoute(context, route: MiniAppRoutes.personalInfo),
    );
  }

  if (!state.hasOpenSecAcnt) {
    return OverviewVerificationViewModel(
      title: l10n.ipsOverviewVerificationTitle,
      subtitle: l10n.ipsOverviewVerificationSubtitle,
      progressCurrent: 1,
      progressTotal: 3,
      steps: <OverviewVerificationStep>[
        OverviewVerificationStep(
          title: l10n.ipsOverviewProfileMenuPersonalInfo,
          subtitle: l10n.ipsOverviewProfileVerified,
          status: InvestXStepStatus.completed,
        ),
        OverviewVerificationStep(
          title: l10n.ipsAcntVerifyAcnt,
          subtitle: l10n.ipsAcntFlowBody,
          status: InvestXStepStatus.active,
          onTap: () => launchIpsRoute(context, route: MiniAppRoutes.secAcnt),
        ),
        OverviewVerificationStep(
          title: l10n.ipsOverviewFinalStepLabel,
          subtitle: l10n.ipsQuestionnaireViewPacks,
          status: InvestXStepStatus.upcoming,
          isLast: true,
        ),
      ],
      promoEyebrow: l10n.ipsOverviewActionTitle,
      promoTitle: l10n.ipsAcntOpenAcnt,
      promoButtonLabel: l10n.commonContinue,
      onPromoTap: () => launchIpsRoute(context, route: MiniAppRoutes.secAcnt),
    );
  }

  return OverviewVerificationViewModel(
    title: l10n.ipsOverviewVerificationTitle,
    subtitle: l10n.ipsOverviewVerificationSubtitle,
    progressCurrent: 2,
    progressTotal: 3,
    steps: <OverviewVerificationStep>[
      OverviewVerificationStep(
        title: l10n.ipsOverviewProfileMenuPersonalInfo,
        subtitle: l10n.ipsOverviewProfileVerified,
        status: InvestXStepStatus.completed,
      ),
      OverviewVerificationStep(
        title: l10n.ipsAcntVerifyAcnt,
        subtitle: l10n.ipsAcntHasAcnt,
        status: InvestXStepStatus.completed,
      ),
      OverviewVerificationStep(
        title: l10n.ipsQuestionnaireTitle,
        subtitle: l10n.ipsQuestionnaireSubtitle,
        status: InvestXStepStatus.active,
        onTap: () => launchIpsRoute(context, route: MiniAppRoutes.questionnaire),
        isLast: true,
      ),
    ],
    promoEyebrow: l10n.ipsOverviewProfileMenuPackInfo,
    promoTitle: l10n.ipsHomeRecommendedPackCta,
    promoButtonLabel: l10n.commonContinue,
    onPromoTap: () => launchIpsRoute(context, route: MiniAppRoutes.questionnaire),
  );
}
