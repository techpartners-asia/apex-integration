import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

Widget buildIpsSplashPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  final MiniAppBootstrapFlow? bootstrapFlow = dependencies.bootstrapFlow;
  if (bootstrapFlow == null) {
    return missingScreen(context, route, context.l10n.ipsAcntMissingService);
  }

  return BlocProvider<MiniAppBootstrapCubit>(
    create: (BuildContext context) => MiniAppBootstrapCubit(
      bootstrapFlow: bootstrapFlow,
      l10n: l10n,
      logger: dependencies.logger,
    )..load(),
    child: const IpsSplashScreen(),
  );
}

Widget buildIpsOverviewPage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.bootstrapService,
    missingMessage: l10n.ipsAcntMissingService,
    builder: (service) => RepositoryProvider<IpsDependencies>.value(
      value: dependencies,
      child: BlocProvider<IpsOverviewCubit>(
        create: (BuildContext context) => IpsOverviewCubit(
          bootstrapService: service,
          portfolioService: dependencies.portfolioService,
          packService: dependencies.packService,
          l10n: l10n,
          logger: dependencies.logger,
        )..load(initial: arguments is AcntBootstrapState ? arguments : null),
        child: const IpsOverviewScreen(),
      ),
    ),
  );
}

Widget buildIpsSecAcntPage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.bootstrapService,
    missingMessage: context.l10n.ipsAcntMissingService,
    builder: (service) => BlocProvider<IpsSecAcntCubit>(
      create: (BuildContext context) => IpsSecAcntCubit(
        service: service,
        paymentExecutor: dependencies.paymentExecutor,
        l10n: l10n,
      ),
      child: SecAcntScreen(
        initialBootstrapState: arguments is AcntBootstrapState
            ? arguments
            : null,
        bankOptionsRepository: dependencies.bankOptionsRepository,
        bankAccountLookupRepository: dependencies.bankAccountLookupRepository,
        appApi: dependencies.appApi,
        currentUser: dependencies.sessionStore.currentUser,
      ),
    ),
  );
}

Widget buildIpsPersonalInfoPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
}) {
  return PersonalInfoScreen(
    appApi: dependencies.appApi,
    bankOptionsRepository: dependencies.bankOptionsRepository,
    bankAccountLookupRepository: dependencies.bankAccountLookupRepository,
    currentUser: dependencies.sessionStore.currentUser,
  );
}
