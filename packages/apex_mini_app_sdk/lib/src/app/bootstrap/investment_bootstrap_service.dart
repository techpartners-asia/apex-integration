import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Service contract for securities-account startup/onboarding checks.
abstract interface class InvestmentBootstrapService {
  /// Loads securities account list state.
  Future<AcntBootstrapState> getSecAcntListState({bool forceRefresh = false});

  /// Loads balance details and merges them into [currentState].
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  });

  /// Submits a securities-account opening request.
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  });
}
