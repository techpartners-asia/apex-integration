import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

Widget buildIpsQuestionnairePage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  final QuestionnaireService? questionnaireService =
      dependencies.questionnaireService;
  if (questionnaireService == null) {
    return missingScreen(context, route, l10n.ipsQuestionnaireMissingService);
  }

  final InvestmentBootstrapService? bootstrapService =
      dependencies.bootstrapService;
  if (bootstrapService == null && arguments is! AcntBootstrapState) {
    return missingScreen(context, route, l10n.ipsAcntMissingService);
  }

  final AcntBootstrapState? initialBootstrapState =
      arguments is AcntBootstrapState ? arguments : null;

  return BlocProvider<IpsQuestionnaireCubit>(
    create: (BuildContext context) => IpsQuestionnaireCubit(
      service: questionnaireService,
      appApi: dependencies.appApi,
      bootstrapService: bootstrapService,
      initialBootstrapState: initialBootstrapState,
      l10n: l10n,
    )..load(),
    child: QuestionnaireScreen(
      signatureUploadService: SignatureUploadService(
        appApi: dependencies.appApi,
      ),
    ),
  );
}

Widget buildIpsPackPage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  final List<IpsPack>? initialPacks = arguments is List<IpsPack>
      ? List<IpsPack>.unmodifiable(arguments)
      : null;

  return buildGuarded(
    context,
    route: route,
    service: dependencies.packService,
    missingMessage: l10n.ipsPackMissingService,
    builder: (service) => BlocProvider<IpsPackSelectionCubit>(
      create: (BuildContext context) {
        final IpsPackSelectionCubit cubit = IpsPackSelectionCubit(
          service: service,
          l10n: l10n,
          initialPacks: initialPacks,
        );
        if (initialPacks == null) {
          cubit.load();
        }
        return cubit;
      },
      child: PackSelectionScreen(
        questionnaireRes: arguments is QuestionnaireRes ? arguments : null,
      ),
    ),
  );
}

Widget buildIpsContractPage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  final ContractPayload? payload = arguments is ContractPayload
      ? arguments
      : null;
  if (payload == null) {
    return missingScreen(context, route, context.l10n.ipsContractMissingPack);
  }

  final ContractService? contractService = dependencies.contractService;
  if (contractService == null) {
    return missingScreen(context, route, l10n.ipsContractMissingService);
  }

  final InvestmentBootstrapService? bootstrapService =
      dependencies.bootstrapService;
  if (bootstrapService == null) {
    return missingScreen(context, route, l10n.ipsAcntMissingService);
  }

  final PortfolioService? portfolioService = dependencies.portfolioService;
  if (portfolioService == null) {
    return missingScreen(context, route, l10n.ipsPortfolioMissingService);
  }

  final OrdersService? ordersService = dependencies.ordersService;
  if (ordersService == null) {
    return missingScreen(context, route, l10n.ipsPaymentMissingService);
  }

  return BlocProvider<IpsContractCubit>(
    create: (BuildContext context) => IpsContractCubit(
      contractService: contractService,
      bootstrapService: bootstrapService,
      portfolioService: portfolioService,
      ordersService: ordersService,
      paymentExecutor: dependencies.paymentExecutor,
      payload: payload,
      l10n: l10n,
      logger: dependencies.logger,
    ),
    child: const ContractScreen(),
  );
}

Widget buildIpsPortfolioPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.portfolioService,
    missingMessage: l10n.ipsPortfolioMissingService,
    builder: (service) => BlocProvider<IpsPortfolioCubit>(
      create: (BuildContext context) => IpsPortfolioCubit(
        service: service,
        l10n: l10n,
        logger: dependencies.logger,
      )..load(),
      child: const PortfolioScreen(),
    ),
  );
}

Widget buildIpsOrdersPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.ordersService,
    missingMessage: l10n.ipsOrdersMissingService,
    builder: (service) => BlocProvider<IpsOrdersCubit>(
      create: (BuildContext context) => IpsOrdersCubit(
        service: service,
        portfolioService: dependencies.portfolioService,
        l10n: l10n,
        logger: dependencies.logger,
      )..load(),
      child: const OrdersScreen(),
    ),
  );
}

Widget buildIpsRechargePage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.ordersService,
    missingMessage: l10n.ipsPaymentMissingService,
    builder: (service) => BlocProvider<IpsRechargeCubit>(
      create: (BuildContext context) => IpsRechargeCubit(
        service: service,
        portfolioService: dependencies.portfolioService,
        paymentExecutor: dependencies.paymentExecutor,
        l10n: l10n,
        logger: dependencies.logger,
      )..loadPricing(),
      child: const RechargeScreen(),
    ),
  );
}

Future<IpsRechargeState?> showIpsRechargeBottomSheet(
  BuildContext context, {
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  final OrdersService? ordersService = dependencies.ordersService;
  if (ordersService == null) return Future<IpsRechargeState?>.value();

  return showRechargeBottomSheet(
    context,
    ordersService: ordersService,
    portfolioService: dependencies.portfolioService,
    paymentExecutor: dependencies.paymentExecutor,
    l10n: l10n,
    logger: dependencies.logger,
  );
}

Widget buildIpsSellPage(
  BuildContext context, {
  required String route,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.ordersService,
    missingMessage: l10n.ipsOrdersMissingService,
    builder: (service) => BlocProvider<IpsSellCubit>(
      create: (BuildContext context) => IpsSellCubit(
        service: service,
        l10n: l10n,
        portfolioService: dependencies.portfolioService,
        packService: dependencies.packService,
      )..loadPricing(),
      child: const SellScreen(),
    ),
  );
}

Widget buildIpsStatementsPage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  return buildGuarded(
    context,
    route: route,
    service: dependencies.portfolioService,
    missingMessage: l10n.ipsPortfolioMissingService,
    builder: (service) => BlocProvider<IpsStatementsCubit>(
      create: (BuildContext context) => IpsStatementsCubit(
        service: service,
        l10n: l10n,
      )..load(context: arguments is SdkPortfolioContext ? arguments : null),
      child: const StatementsScreen(),
    ),
  );
}
