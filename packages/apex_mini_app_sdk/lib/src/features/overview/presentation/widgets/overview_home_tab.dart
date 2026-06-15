import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'overview/overview_pack_recommendation_view.dart';

/// Overview home tab that shows either onboarding progress or pack suggestions.
class OverviewHomeTab extends StatefulWidget {
  /// Account/bootstrap data for current user.
  final AcntBootstrapState data;

  /// Current user used for greeting/profile copy.
  final UserEntityDto? user;

  /// Recommended packs to show when account setup is complete.
  final List<IpsPack> packs;

  /// Optional pull-to-refresh callback.
  final RefreshCallback? onRefresh;

  /// Whether the grape questionnaire check-completed API returned completed=true.
  final bool isQuestionnaireCompleted;

  /// Creates the overview home tab.
  const OverviewHomeTab({
    super.key,
    required this.data,
    this.user,
    this.packs = const <IpsPack>[],
    this.onRefresh,
    this.isQuestionnaireCompleted = false,
  });

  @override
  State<OverviewHomeTab> createState() => _OverviewHomeTabState();
}

class _OverviewHomeTabState extends State<OverviewHomeTab> {
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    await QuestionnaireLocalPrefs.init();
    if (mounted) setState(() => _prefsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefsLoaded) {
      return const SizedBox.shrink();
    }

    if (widget.packs.isNotEmpty && widget.data.hasOpenSecAcnt) {
      return OverviewPackRecommendationView(
        data: widget.data,
        user: widget.user,
        packs: widget.packs,
        onRefresh: widget.onRefresh,
      );
    }

    final OverviewVerificationViewModel viewModel =
        buildOverviewVerificationViewModel(
          context,
          widget.data,
          hasPaidSecAcntContract: hasPaidSecAcntOpeningFee(
            widget.data,
            currentUser: widget.user,
          ),
          isQuestionnaireCompleted: widget.isQuestionnaireCompleted,
        );

    final bool showUnpaidReminder =
        widget.data.secAcntStatusCode == AcntBootstrapState.secAcntStatusUnpaid;

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

    if (widget.onRefresh == null) {
      return verificationCard;
    }

    return MiniAppRefreshContainer(
      onRefresh: widget.onRefresh,
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
