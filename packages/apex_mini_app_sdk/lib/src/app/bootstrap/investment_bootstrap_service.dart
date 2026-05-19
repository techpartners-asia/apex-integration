import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

abstract interface class InvestmentBootstrapService {
  Future<AcntBootstrapState> getSecAcntListState({bool forceRefresh = false});

  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  });

  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  });
}
