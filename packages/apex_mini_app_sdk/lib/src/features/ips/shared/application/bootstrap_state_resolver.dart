import '../../../../core/exception/api_exception.dart';
import '../domain/services/investment_services.dart';

class BootstrapStateResolver {
  final InvestmentBootstrapService service;

  const BootstrapStateResolver({required this.service});

  Future<AcntBootstrapState> load({bool forceRefresh = false}) async {
    final AcntBootstrapState state = await service.getSecAcntListState(
      forceRefresh: forceRefresh,
    );

    try {
      return await service.getSecAcntBalanceState(currentState: state);
    } on ApiException {
      return state;
    }
  }
}
