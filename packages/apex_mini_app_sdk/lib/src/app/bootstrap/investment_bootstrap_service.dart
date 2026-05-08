import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class InvestmentBootstrapService {
  Future<AcntBootstrapState> getSecAcntListState({bool forceRefresh = false});

  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  });

  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  });
}
