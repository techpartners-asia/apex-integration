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
    final UserEntityDto currentUser = await sessionController.ensureCurrentUser();
    await sessionController.ensureLoginSession();
    final AcntBootstrapState bootstrapState = await BootstrapStateResolver(
      service: bootstrapService,
    ).load();

    return MiniAppBootstrapRes(
      bootstrapState: bootstrapState,
      nextRoute: resolveNextRoute(
        bootstrapState,
        currentUser: currentUser,
      ),
    );
  }

  static String resolveNextRoute(
    AcntBootstrapState bootstrapState, {
    UserEntityDto? currentUser,
  }) {
    if (bootstrapState.hasAcnt && bootstrapState.hasIpsAcnt && bootstrapState.hasOpenSecAcnt) {
      return MiniAppRoutes.overview;
    }

    if (bootstrapState.hasAcnt && !bootstrapState.hasIpsAcnt) {
      return _hasProfileBankAccount(currentUser) ? MiniAppRoutes.questionnaire : MiniAppRoutes.secAcnt;
    }

    return MiniAppRoutes.secAcnt;
  }

  static bool _hasProfileBankAccount(UserEntityDto? user) {
    return user?.bank?.accountNumber?.trim().isNotEmpty ?? false;
  }
}
