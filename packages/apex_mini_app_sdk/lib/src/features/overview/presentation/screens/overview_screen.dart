import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsOverviewScreen extends StatefulWidget {
  const IpsOverviewScreen({super.key});

  @override
  State<IpsOverviewScreen> createState() => _IpsOverviewScreenState();
}

class _IpsOverviewScreenState extends State<IpsOverviewScreen> {
  static const int _homeTabIndex = OverviewBottomNavigation.homeIndex;

  int _selectedTabIndex = _homeTabIndex;

  @override
  Widget build(BuildContext context) {
    final MiniAppSessionState sessionState = context
        .watch<MiniAppSessionStore>()
        .state;

    return BlocBuilder<IpsOverviewCubit, LoadableState<IpsOverviewViewData>>(
      builder:
          (BuildContext context, LoadableState<IpsOverviewViewData> state) {
            final IpsOverviewViewData? data = state.data;
            final bool isTradingEnabled = _hasTradingAccess(
              viewData: data,
              sessionState: sessionState,
            );

            return CustomScaffold(
              showBackButton: false,
              showCloseButton: true,
              appBarCenterTitle: false,
              appBarBackgroundColor: DesignTokens.softSurface,
              backgroundColor: DesignTokens.softSurface,
              appBarShowBottomBorder: false,
              appBarReserveLeadingSpace: false,
              body: _buildBody(context, state, sessionState),
              adaptiveBottomNavigationBar: data == null || !state.isSuccess
                  ? null
                  : buildOverviewBottomNavigationBar(
                      context,
                      selectedIndex: _selectedTabIndex,
                      onSelected: _handleTabSelected,
                      onActionPressed: isTradingEnabled
                          ? () => _showActionSheet(context, data)
                          : null,
                      isActionEnabled: isTradingEnabled,
                    ),
            );
          },
    );
  }

  void _handleTabSelected(int index) {
    if (_selectedTabIndex == index) {
      return;
    }
    setState(() => _selectedTabIndex = index);
  }

  Future<void> _handleRefresh() {
    return context.read<IpsOverviewCubit>().load(forceRefresh: true);
  }

  Widget _buildBody(
    BuildContext context,
    LoadableState<IpsOverviewViewData> state,
    MiniAppSessionState sessionState,
  ) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final IpsOverviewViewData? viewData = state.data;
    final AcntBootstrapState? data = viewData?.bootstrapState;
    final bool shouldHoldDashboard =
        data?.hasIpsAcnt == true && !(viewData?.isDashboardDataReady ?? false);

    if ((state.isInitial || state.isLoading) && data == null) {
      return Center(
        child: MiniAppLoadingState(
          title: l10n.commonLoading,
          message: l10n.ipsBootstrapLoading,
        ),
      );
    }

    if (state.isFailure || data == null) {
      return Center(
        child: Padding(
          padding: responsive.insetsSymmetric(horizontal: 20),
          child: MiniAppErrorState(
            title: l10n.errorsGenericTitle,
            message: state.errorMessage ?? l10n.errorsActionFailed,
            retryLabel: l10n.commonRetry,
            onRetry: context.read<IpsOverviewCubit>().load,
          ),
        ),
      );
    }

    final Widget content = KeyedSubtree(
      key: ValueKey<int>(_selectedTabIndex),
      child: Padding(
        padding: EdgeInsets.zero,
        child: _selectedTabIndex == _homeTabIndex
            ? shouldHoldDashboard
                  ? OverviewDashboardHomeShimmer(onRefresh: _handleRefresh)
                  : data.hasIpsAcnt
                  ? OverviewDashboardHomeTab(
                      bootstrapState: data,
                      portfolioOverview: viewData?.portfolioOverview,
                      yieldProfitHoldings:
                          viewData?.yieldProfitHoldings ??
                          const <PortfolioHolding>[],
                      stockYieldDetails:
                          viewData?.stockYieldDetails ??
                          const <PortfolioHolding>[],
                      user: sessionState.currentUser,
                      onRecharge: () => launchIpsRoute(
                        context,
                        route: MiniAppRoutes.recharge,
                      ),
                      onStatements: () => launchIpsRoute(
                        context,
                        route: MiniAppRoutes.statements,
                        arguments: viewData?.portfolioContext,
                      ),
                      onWithdraw: () =>
                          launchIpsRoute(context, route: MiniAppRoutes.sell),
                      onViewDetails: () => launchIpsRoute(
                        context,
                        route: MiniAppRoutes.portfolio,
                      ),
                      onRefresh: _handleRefresh,
                    )
                  : OverviewHomeTab(
                      data: data,
                      user: sessionState.currentUser,
                      packs: viewData?.packs ?? const <IpsPack>[],
                      onRefresh: _handleRefresh,
                    )
            : OverviewProfileTab(
                data: data,
                user: sessionState.currentUser,
                portfolioContext: viewData?.portfolioContext,
              ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (state.isLoading) ...<Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.dp(20),
              responsive.dp(20),
              responsive.dp(20),
              0,
            ),
            child: MiniAppLoadingState(
              title: l10n.commonLoading,
              message: data.hasIpsAcnt
                  ? l10n.ipsPortfolioLoading
                  : l10n.ipsBootstrapLoading,
            ),
          ),
        ],
        _selectedTabIndex == _homeTabIndex ? Expanded(child: content) : content,
      ],
    );
  }

  bool _hasTradingAccess({
    required IpsOverviewViewData? viewData,
    required MiniAppSessionState sessionState,
  }) {
    final PortfolioOverview? overview = viewData?.portfolioOverview;
    if ((overview?.packQty ?? 0) > 0) {
      return true;
    }

    final account = sessionState.currentUser?.account;
    final String packageCode = account?.packageCode?.trim() ?? '';
    return account?.isInvestContract == true && packageCode.isNotEmpty;
  }

  Future<void> _showActionSheet(
    BuildContext context,
    IpsOverviewViewData data,
  ) async {
    final AcntBootstrapState bootstrapState = data.bootstrapState;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: MiniAppStateColors.bottomSheetBackground,
      builder: (BuildContext sheetContext) {
        if (bootstrapState.hasIpsAcnt) {
          return ActionSheet(
            title: sheetContext.l10n.ipsOverviewActionTitle,
            showDivider: false,
            child: OverviewDashboardActionSheetContent(
              onRecharge: () async {
                Navigator.maybePop(context);
                await showIpsRechargeBottomSheet(
                  context,
                  dependencies: context.read<IpsDependencies>(),
                  l10n: context.l10n,
                );
              },
              onClosePack: () {
                Navigator.maybePop(context);
                launchIpsRoute(context, route: MiniAppRoutes.sell);
              },
            ),
          );
        }

        return ActionSheet(
          title: sheetContext.l10n.ipsOverviewActionTitle,
          child: SingleChildScrollView(
            child: OverviewVerificationCard(
              viewModel: buildOverviewVerificationViewModel(
                sheetContext,
                bootstrapState,
              ),
              compact: true,
            ),
          ),
        );
      },
    );
  }
}
