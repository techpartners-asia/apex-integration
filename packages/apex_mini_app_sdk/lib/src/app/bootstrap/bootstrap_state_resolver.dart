import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class BootstrapStateResolver {
  final InvestmentBootstrapService service;

  const BootstrapStateResolver({required this.service});

  Future<AcntBootstrapState> load({bool forceRefresh = false}) async {
    final AcntBootstrapState state = await service.getSecAcntListState(
      forceRefresh: forceRefresh,
    );

    try {
      if (state.hasAcnt && state.commission.isNullEmptyFalseOrZero) {
        return await service.getSecAcntBalanceState(currentState: state);
      } else {
        return state;
      }
    } on ApiException {
      return state;
    }
  }
}
