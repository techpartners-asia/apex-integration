import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'overview/overview_pack_recommendation_view.dart';

/// Overview home tab that shows either onboarding progress or pack suggestions.
class OverviewHomeTab extends StatelessWidget {
  /// Account/bootstrap data for current user.
  final AcntBootstrapState data;

  /// Current user used for greeting/profile copy.
  final UserEntityDto? user;

  /// Recommended packs to show when account setup is complete.
  final List<IpsPack> packs;

  /// Optional pull-to-refresh callback.
  final RefreshCallback? onRefresh;

  /// Creates the overview home tab.
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
      return OverviewPackRecommendationView(
        data: data,
        user: user,
        packs: packs,
        onRefresh: onRefresh,
      );
    }

    final OverviewVerificationViewModel viewModel =
        buildOverviewVerificationViewModel(
          context,
          data,
          hasPaidSecAcntContract: hasPaidSecAcntOpeningFee(
            data,
            currentUser: user,
          ),
        );

    final bool showUnpaidReminder =
        data.secAcntStatusCode == AcntBootstrapState.secAcntStatusUnpaid;

    final Widget verificationCard = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        OverviewVerificationCard(viewModel: viewModel),
        if (showUnpaidReminder) ...<Widget>[
          SizedBox(height: context.responsive.dp(14)),
          ReminderCard(
            title: context.l10n.ipsOverviewDashboardReminderTitle,
            message: context.l10n.secAcntCalculationPendingMessage,
          ),
        ],
      ],
    );

    if (onRefresh == null) {
      return verificationCard;
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
      child: verificationCard,
    );
  }
}
