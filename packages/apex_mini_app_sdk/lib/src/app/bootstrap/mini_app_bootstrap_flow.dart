import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:apex_mini_app_sdk/src/app/bootstrap/profile_incomplete_signup_exception.dart';
import 'package:apex_mini_app_sdk/src/app/bootstrap/signup_bootstrap_exception.dart';

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
    final UserEntityDto currentUser = await _ensureCurrentUser();
    await sessionController.ensureLoginSession();
    final AcntBootstrapState bootstrapState = await BootstrapStateResolver(
      service: bootstrapService,
    ).load();

    await _autoRequestSecAcntIfNeeded(
      bootstrapState,
      currentUser: currentUser,
    );

    return MiniAppBootstrapRes(
      bootstrapState: bootstrapState,
      nextRoute: resolveNextRoute(
        bootstrapState,
        currentUser: currentUser,
      ),
    );
  }

  /// Silently sends the securities-account opening request when the
  /// contract fee is already paid but the backend hasn't registered a
  /// request yet, so the user isn't forced through onboarding just to
  /// trigger it.
  Future<void> _autoRequestSecAcntIfNeeded(
    AcntBootstrapState bootstrapState, {
    required UserEntityDto currentUser,
  }) async {
    final bool shouldAutoRequest =
      bootstrapState.hasAcnt == false &&
      hasPaidSecAcntContract(currentUser) &&
      hasNotRequestedSecAcnt(currentUser);

    if (!shouldAutoRequest) {
      return;
    }

    final SecAcntPersonalInfoData personalInfo = SecAcntFlowDraft.fromBootstrap(
      bootstrapState,
      user: currentUser,
    ).toPersonalInfoData();

    try {
      await bootstrapService.addSecuritiesAcntReq(personalInfo: personalInfo);
    } catch (_) {
      // Best-effort: startup routing must still proceed if this fails.
    }
  }

  Future<UserEntityDto> _ensureCurrentUser() async {
    try {
      final UserEntityDto user = await sessionController.ensureCurrentUser();
      if (!hasCompleteSignupProfile(user)) {
        throw const SignupBootstrapException(
          ProfileIncompleteSignupException(),
        );
      }
      return user;
    } on SignupBootstrapException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignupBootstrapException(error), stackTrace);
    }
  }

  /// Converts backend bootstrap state into the next route in the onboarding flow.
  static String resolveNextRoute(
    AcntBootstrapState bootstrapState, {
    UserEntityDto? currentUser,
  }) {
    return MiniAppRoutes.secAcnt;
  }
}
