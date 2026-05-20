import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Builds the Help/support route.
Widget buildIpsHelpPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return BlocProvider<HelpCubit>(
    create: (BuildContext context) => HelpCubit(
      appApi: dependencies.appApi,
      l10n: l10n,
      logger: dependencies.logger,
    )..load(),
    child: const HelpScreen(),
  );
}

/// Builds the feedback route.
Widget buildIpsFeedbackPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return BlocProvider<FeedbackCubit>(
    create: (BuildContext context) => FeedbackCubit(
      appApi: dependencies.appApi,
      l10n: l10n,
      logger: dependencies.logger,
    )..load(),
    child: const FeedbackScreen(),
  );
}

/// Builds the reward route.
Widget buildIpsRewardPage(BuildContext context, {required String route}) {
  return const RewardScreen();
}
