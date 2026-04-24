import 'package:mini_app_sdk/mini_app_sdk.dart';

class MiniAppBootstrapRes {
  final AcntBootstrapState bootstrapState;
  final String nextRoute;

  const MiniAppBootstrapRes({
    required this.bootstrapState,
    required this.nextRoute,
  });
}

class MiniAppBootstrapFlow {
  final MiniAppSessionController sessionController;
  final InvestmentBootstrapService bootstrapService;

  const MiniAppBootstrapFlow({
    required this.sessionController,
    required this.bootstrapService,
  });

  Future<MiniAppBootstrapRes> resolve() async {
    await sessionController.ensureCurrentUser();
    await sessionController.ensureLoginSession();
    final AcntBootstrapState bootstrapState = await BootstrapStateResolver(
      service: bootstrapService,
    ).load();

    return MiniAppBootstrapRes(
      bootstrapState: bootstrapState,
      nextRoute: resolveNextRoute(bootstrapState),
    );
  }

  static String resolveNextRoute(AcntBootstrapState bootstrapState) {
    if (!bootstrapState.hasAcnt || bootstrapState.requiresSecAcntPayment) {
      return MiniAppRoutes.secAcnt;
    }

    if (!bootstrapState.hasIpsAcnt) {
      return MiniAppRoutes.questionnaire;
    }

    return MiniAppRoutes.overview;
  }
}
