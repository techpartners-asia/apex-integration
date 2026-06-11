import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Main IPS overview shell with dashboard/profile tabs and action navigation.
class IpsOverviewScreen extends StatefulWidget {
  /// Creates the overview screen.
  const IpsOverviewScreen({super.key});

  @override
  State<IpsOverviewScreen> createState() => _IpsOverviewScreenState();
}

/// Tracks active overview tab and coordinates overview dashboard actions.
class _IpsOverviewScreenState extends State<IpsOverviewScreen> {
  /// Default tab shown when the user lands on the overview screen.
  static const int _homeTabIndex = OverviewBottomNavigation.homeIndex;

  /// Currently selected bottom-navigation tab.
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
                ) &&
                !(data?.hasPendingOrder ?? false);

            return CustomScaffold(
              showBackButton: false,
              showCloseButton: true,
              onDismiss: () => unawaited(closeMiniAppSafely(context)),
              appBarCenterTitle: false,
              appBarBackgroundColor: DesignTokens.softSurface,
              backgroundColor: DesignTokens.softSurface,
              appBarShowBottomBorder: false,
              appBarReserveLeadingSpace: false,
              body: _buildBody(context, state, sessionState, isTradingEnabled),
              isTradingEnabled: isTradingEnabled,
              bottomNavigationBar: data == null || !state.isSuccess
                  ? null
                  : buildOverviewBottomNavigationBar(
                      context,
                      selectedIndex: _selectedTabIndex,
                      onSelected: _handleTabSelected,
                      onActionPressed: () => _showActionSheet(
                        context,
                        data,
                        sessionState.currentUser,
                      ),
                      isActionEnabled: isTradingEnabled,
                      isButtonDisabled: !data.bootstrapState.hasIpsAcnt,
                    ),
            );
          },
    );
  }

  /// Updates the selected bottom-navigation tab.
  void _handleTabSelected(int index) {
    if (_selectedTabIndex == index) {
      return;
    }
    setState(() => _selectedTabIndex = index);
  }

  /// Reloads overview/bootstrap data when the active tab is refreshed.
  Future<void> _handleRefresh() {
    return context.read<IpsOverviewCubit>().load(forceRefresh: true);
  }

  /// Builds loading, error, dashboard, or profile content for the shell.
  Widget _buildBody(
    BuildContext context,
    LoadableState<IpsOverviewViewData> state,
    MiniAppSessionState sessionState,
    bool isTradingEnabled,
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
                      hasValidIpsBalance: viewData?.hasValidIpsBalance ?? false,
                      portfolioOverview: viewData?.portfolioOverview,
                      yieldProfitHoldings:
                          viewData?.yieldProfitHoldings ??
                          const <PortfolioHolding>[],
                      stockYieldDetails:
                          viewData?.stockYieldDetails ??
                          const <PortfolioHolding>[],
                      user: sessionState.currentUser,
                      onRecharge: () {
                        if (!isTradingEnabled) {
                          MiniAppToast.showWarning(
                            context,
                            message: context
                                .l10n
                                .ipsOverviewActionPendingOrderMessage,
                          );
                          return;
                        }
                        launchIpsRoute(context, route: MiniAppRoutes.recharge);
                      },
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

  /// Determines whether trade actions should be exposed to the current user.
  bool _hasTradingAccess({
    required IpsOverviewViewData? viewData,
    required MiniAppSessionState sessionState,
  }) {
    final PortfolioOverview? overview = viewData?.portfolioOverview;

    final account = sessionState.currentUser?.account;
    final String packageCode = account?.packageCode?.trim() ?? '';
    return account?.isInvestContract == true;
  }

  /// Shows the floating action sheet for recharge/sell or verification.
  Future<void> _showActionSheet(
    BuildContext context,
    IpsOverviewViewData data,
    UserEntityDto? currentUser,
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
                await Navigator.of(sheetContext).maybePop();

                if (!context.mounted) return;

                await Future<void>.delayed(const Duration(milliseconds: 120));

                if (!context.mounted) return;

                await showIpsRechargeBottomSheet(
                  context,
                  dependencies: context.read<IpsDependencies>(),
                  l10n: context.l10n,
                );

                if (!context.mounted) return;
                unawaited(
                  context.read<IpsOverviewCubit>().refreshPendingOrderStatus(),
                );
              },

              onSellPack: () async {
                await Navigator.of(sheetContext).maybePop();

                if (!context.mounted) return;

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
                hasPaidSecAcntContract: hasPaidSecAcntOpeningFee(
                  bootstrapState,
                  currentUser: currentUser,
                ),
              ),
              compact: true,
            ),
          ),
        );
      },
    );
  }
}
