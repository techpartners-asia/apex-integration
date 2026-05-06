import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

part 'overview/overview_pack_recommendation_view.dart';

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
      return OverviewPackRecommendationView(
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
