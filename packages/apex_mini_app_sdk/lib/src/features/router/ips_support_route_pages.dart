import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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

Widget buildIpsRewardPage(BuildContext context, {required String route}) {
  return const RewardScreen();
}
