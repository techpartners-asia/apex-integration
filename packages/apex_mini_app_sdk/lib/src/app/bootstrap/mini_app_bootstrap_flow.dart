import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Result of startup/bootstrap route resolution.
class MiniAppBootstrapRes {
  /// Account/bootstrap state returned from backend checks.
  final AcntBootstrapState bootstrapState;

  /// Route the startup flow should open next.
  final String nextRoute;

  /// Creates the startup routing result.
  const MiniAppBootstrapRes({
    required this.bootstrapState,
    required this.nextRoute,
  });
}

/// Orchestrates startup session loading and securities-account state checks.
class MiniAppBootstrapFlow {
  /// Session controller used to load current user and login session.
  final MiniAppSessionController sessionController;

  /// Backend service used to resolve account/bootstrap state.
  final InvestmentBootstrapService bootstrapService;

  /// Creates the mini-app bootstrap flow.
  const MiniAppBootstrapFlow({
    required this.sessionController,
    required this.bootstrapService,
  });

  /// Loads required startup data and returns the next route.
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

  /// Converts backend bootstrap state into the next route in the onboarding flow.
  static String resolveNextRoute(
    AcntBootstrapState bootstrapState, {
    UserEntityDto? currentUser,
  }) {
    if (_shouldRouteToOverview(bootstrapState, currentUser: currentUser)) {
      return MiniAppRoutes.overview;
    }

    return MiniAppRoutes.secAcnt;
  }

  /// Whether startup should land on overview instead of sec-account onboarding.
  static bool _shouldRouteToOverview(
    AcntBootstrapState bootstrapState, {
    UserEntityDto? currentUser,
  }) {
    if (bootstrapState.hasOpenSecAcnt && bootstrapState.hasIpsAcnt) {
      return true;
    }

    if (bootstrapState.secAcntStatusCode ==
        AcntBootstrapState.secAcntStatusUnpaid) {
      return false;
    }

    if (bootstrapState.hasAcnt && !bootstrapState.hasIpsAcnt) {
      if (hasCompleteSecAcntPersonalInfo(bootstrapState, user: currentUser) &&
          (bootstrapState.hasOpenSecAcnt ||
              bootstrapState.hasPendingSecAcntActivation)) {
        return true;
      }
    }

    final SecAcntFlowStep? initialStep = resolveInitialSecAcntFlowStep(
      bootstrapState,
      currentUser: currentUser,
    );

    return initialStep == null || initialStep == SecAcntFlowStep.calculation;
  }
}
