import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Resolves the most complete account bootstrap state available.
class BootstrapStateResolver {
  /// Backend bootstrap service.
  final InvestmentBootstrapService service;

  /// Creates a bootstrap state resolver.
  const BootstrapStateResolver({required this.service});

  /// Loads account list state and enriches it with balance state when possible.
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
