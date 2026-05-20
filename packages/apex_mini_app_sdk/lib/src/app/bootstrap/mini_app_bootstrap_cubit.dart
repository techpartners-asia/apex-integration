import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:apex_mini_app_sdk/src/host/apex_mini_app_host_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit backing the startup/splash bootstrap screen.
class MiniAppBootstrapCubit extends Cubit<LoadableState<MiniAppBootstrapRes>> {
  /// Flow that resolves session and next route.
  final MiniAppBootstrapFlow bootstrapFlow;

  /// Localizations used to format user-facing errors.
  final SdkLocalizations l10n;

  /// Diagnostic logger.
  final MiniAppLogger logger;

  MiniAppBootstrapCubit({
    required this.bootstrapFlow,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<MiniAppBootstrapRes>());

  /// Starts the bootstrap request flow.
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

  /// Avoids duplicate host error callbacks for errors already emitted by API layer.
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
