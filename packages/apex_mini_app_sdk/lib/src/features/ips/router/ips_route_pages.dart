import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';

import '../../../core/backend/sdk_portfolio_context.dart';
import '../../../app/bootstrap/mini_app_bootstrap_cubit.dart';
import '../../../app/bootstrap/mini_app_bootstrap_flow.dart';
import '../../../shared/l10n/sdk_localizations_x.dart';
import '../contract/application/ips_contract_cubit.dart';
import '../contract/presentation/models/contract_payload.dart';
import '../contract/presentation/screens/contract_screen.dart';
import '../demo/presentation/screens/liquid_glass_demo_screen.dart';
import '../di/ips_dependencies.dart';
import '../orders/application/ips_orders_cubit.dart';
import '../orders/presentation/screens/orders_screen.dart';
import '../overview/application/ips_overview_cubit.dart';
import '../overview/presentation/screens/overview_screen.dart';
import '../pack/application/ips_pack_selection_cubit.dart';
import '../pack/presentation/screens/pack_selection_screen.dart';
import '../portfolio/application/ips_portfolio_cubit.dart';
import '../portfolio/presentation/screens/portfolio_screen.dart';
import '../questionnaire/application/ips_questionnaire_cubit.dart';
import '../questionnaire/presentation/screens/questionnaire_screen.dart';
import '../recharge/application/ips_recharge_cubit.dart';
import '../recharge/application/ips_recharge_state.dart';
import '../recharge/presentation/screens/recharge_screen.dart';
import '../recharge/presentation/widgets/recharge_bottom_sheet.dart';
import '../sec_acnt/application/ips_sec_acnt_cubit.dart';
import '../sec_acnt/presentation/screens/sec_acnt_screen.dart';
import '../shared/application/investx_signature_upload_service.dart';
import '../shared/domain/services/investment_services.dart';
import '../sell/application/ips_sell_cubit.dart';
import '../sell/presentation/screens/sell_screen.dart';
import '../feedback/application/feedback_cubit.dart';
import '../feedback/presentation/screens/feedback_screen.dart';
import '../help/application/help_cubit.dart';
import '../help/presentation/screens/help_screen.dart';
import '../profile/presentation/screens/personal_info_screen.dart';
import '../reward/presentation/screens/reward_screen.dart';
import '../startup/presentation/screens/splash_screen.dart';
import '../statements/application/ips_statements_cubit.dart';
import '../statements/presentation/screens/statements_screen.dart';
import 'ips_route_support.dart';

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
    service: dependencies.services.bootstrapService,
    missingMessage: l10n.ipsAcntMissingService,
    builder: (service) => RepositoryProvider<IpsDependencies>.value(
      value: dependencies,
      child: BlocProvider<IpsOverviewCubit>(
        create: (BuildContext context) => IpsOverviewCubit(
          bootstrapService: service,
          portfolioService: dependencies.services.portfolioService,
          packService: dependencies.services.packService,
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
    service: dependencies.services.bootstrapService,
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

Widget buildIpsQuestionnairePage(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
  required SdkLocalizations l10n,
}) {
  final QuestionnaireService? questionnaireService =
      dependencies.services.questionnaireService;
  if (questionnaireService == null) {
    return missingScreen(context, route, l10n.ipsQuestionnaireMissingService);
  }

  final InvestmentBootstrapService? bootstrapService =
      dependencies.services.bootstrapService;
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
      signatureUploadService: InvestXSignatureUploadService(
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
  return buildGuarded(
    context,
    route: route,
    service: dependencies.services.packService,
    missingMessage: l10n.ipsPackMissingService,
    builder: (service) => BlocProvider<IpsPackSelectionCubit>(
      create: (BuildContext context) =>
          IpsPackSelectionCubit(service: service, l10n: l10n)..load(),
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

  final ContractService? contractService =
      dependencies.services.contractService;
  if (contractService == null) {
    return missingScreen(context, route, l10n.ipsContractMissingService);
  }

  final InvestmentBootstrapService? bootstrapService =
      dependencies.services.bootstrapService;
  if (bootstrapService == null) {
    return missingScreen(context, route, l10n.ipsAcntMissingService);
  }

  final PortfolioService? portfolioService =
      dependencies.services.portfolioService;
  if (portfolioService == null) {
    return missingScreen(context, route, l10n.ipsPortfolioMissingService);
  }

  final OrdersService? ordersService = dependencies.services.ordersService;
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
    service: dependencies.services.portfolioService,
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
    service: dependencies.services.ordersService,
    missingMessage: l10n.ipsOrdersMissingService,
    builder: (service) => BlocProvider<IpsOrdersCubit>(
      create: (BuildContext context) => IpsOrdersCubit(
        service: service,
        portfolioService: dependencies.services.portfolioService,
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
    service: dependencies.services.ordersService,
    missingMessage: l10n.ipsPaymentMissingService,
    builder: (service) => BlocProvider<IpsRechargeCubit>(
      create: (BuildContext context) => IpsRechargeCubit(
        service: service,
        portfolioService: dependencies.services.portfolioService,
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
  final OrdersService? ordersService = dependencies.services.ordersService;
  if (ordersService == null) return Future<IpsRechargeState?>.value();

  return showRechargeBottomSheet(
    context,
    ordersService: ordersService,
    portfolioService: dependencies.services.portfolioService,
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
    service: dependencies.services.ordersService,
    missingMessage: l10n.ipsOrdersMissingService,
    builder: (service) => BlocProvider<IpsSellCubit>(
      create: (BuildContext context) => IpsSellCubit(
        service: service,
        l10n: l10n,
        portfolioService: dependencies.services.portfolioService,
        packService: dependencies.services.packService,
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
    service: dependencies.services.portfolioService,
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

Widget buildIpsLiquidGlassDemoPage(
  BuildContext context, {
  required String route,
}) {
  return const LiquidGlassDemoScreen();
}
