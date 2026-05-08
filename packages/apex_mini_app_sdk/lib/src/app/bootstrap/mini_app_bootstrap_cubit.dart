import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../host/apex_mini_app_host_context.dart';

class MiniAppBootstrapCubit extends Cubit<LoadableState<MiniAppBootstrapRes>> {
  final MiniAppBootstrapFlow bootstrapFlow;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  MiniAppBootstrapCubit({
    required this.bootstrapFlow,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<MiniAppBootstrapRes>());

  Future<void> load() async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final MiniAppBootstrapRes resolution = await bootstrapFlow.resolve();

      emit(
        LoadableState<MiniAppBootstrapRes>(
          status: LoadableStatus.success,
          data: resolution,
        ),
      );
    } catch (error, stackTrace) {
      if (error is ApiUnauthorizedException) {
        ApexMiniAppHostContext.emitTokenExpired();
      }
      if (!_wasHostNotifiedByApiExecutor(error)) {
        ApexMiniAppHostContext.emitError(error, stackTrace);
      }
      logger.onError(
        'mini_app_bootstrap_failed',
        error: error,
        stackTrace: stackTrace,
      );

      final String errorMessage = formatIpsError(error, l10n);

      emit(
        LoadableState<MiniAppBootstrapRes>(
          status: LoadableStatus.failure,
          errorMessage: errorMessage,
        ),
      );
    }
  }

  bool _wasHostNotifiedByApiExecutor(Object error) {
    if (error is ApiUnauthorizedException || error is ApiNetworkException) {
      return true;
    }
    if (error is ApiParsingException || error is ApiUnknownException) {
      return true;
    }
    if (error is ApiBusinessException) {
      return error.responseCode >= 500 && error.responseCode != 504;
    }
    return false;
  }
}
