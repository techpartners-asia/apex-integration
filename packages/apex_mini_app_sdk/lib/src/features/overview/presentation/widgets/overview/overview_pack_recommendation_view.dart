part of '../overview_home_tab.dart';

class OverviewPackRecommendationView extends StatelessWidget {
  final AcntBootstrapState data;
  final UserEntityDto? user;
  final List<IpsPack> packs;
  final RefreshCallback? onRefresh;

  const OverviewPackRecommendationView({
    super.key,
    required this.data,
    required this.packs,
    this.user,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final String displayName = user?.displayName ?? '';
    // final IpsPack recommendedPack = packs.firstWhere((el) => el.isRecommended == 1, orElse: () => packs.first);

    final Widget scrollView = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _PackRecommendationGreeting(displayName: displayName),
        SizedBox(height: responsive.dp(18)),
        CustomText(
          l10n.ipsOverviewPackPrompt,
          variant: MiniAppTextVariant.subtitle2,
          color: DesignTokens.ink,
        ),
        SizedBox(height: responsive.dp(14)),
        ...List<Widget>.generate(
          packs.length,
          (int index) => Padding(
            padding: EdgeInsets.only(
              bottom: responsive.dp(18),
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
                variant: MiniAppTextVariant.caption1,
                color: DesignTokens.muted,
              ),
              SizedBox(height: responsive.dp(4)),
              if (displayName.isNotEmpty)
                CustomText(
                  displayName,
                  variant: MiniAppTextVariant.h8,
                  color: DesignTokens.ink,
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
  final IpsPack pack;
  final int stackIndex;

  const _PackRecommendationCard({
    required this.pack,
    required this.stackIndex,
  });

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
                          variant: MiniAppTextVariant.subtitle3,
                          color: DesignTokens.ink,
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
                      child: PrimaryButton(
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
              color: _isWarmVariant
                  ? const Color(0x1EE96E96)
                  : const Color(0x143F7E9F),
            ),
          ),
          Positioned(
            left: responsive.dp(10),
            right: responsive.dp(10),
            top: responsive.dp(6),
            child: _PackRecommendationStackPlate(
              color: _isWarmVariant
                  ? const Color(0x24F59CB5)
                  : const Color(0x1E5A93AD),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: _isWarmVariant
                    ? const LinearGradient(
                        colors: <Color>[
                          DesignTokens.rose,
                          DesignTokens.softPeach,
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
                            variant: MiniAppTextVariant.caption1,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                          SizedBox(height: responsive.dp(4)),
                          CustomText(
                            pack.packDesc ?? pack.name2 ?? pack.name,
                            textAlign: TextAlign.center,
                            variant: MiniAppTextVariant.title1,
                            color: Colors.white,
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
                              variant: MiniAppTextVariant.caption1,
                              textAlign: TextAlign.center,
                              color: Colors.white,
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
