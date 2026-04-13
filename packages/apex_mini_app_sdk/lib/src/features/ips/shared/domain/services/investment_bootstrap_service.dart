import '../models/ips_models.dart';

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
