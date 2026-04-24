import 'package:mini_app_sdk/mini_app_sdk.dart';

class InvestmentBootstrapService {
  const InvestmentBootstrapService();

  Future<AcntBootstrapState> getSecAcntListState({
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) {
    throw UnimplementedError();
  }

  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) {
    throw UnimplementedError();
  }
}
