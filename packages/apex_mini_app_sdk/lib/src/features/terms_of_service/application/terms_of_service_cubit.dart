import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Loads the service terms HTML for the TermsOfService screen.
class TermsOfServiceCubit extends Cubit<LoadableState<String>> {
  /// Repository used to fetch the contract HTML.
  final MiniAppSupportRepository appApi;

  /// Localization source for error formatting.
  final SdkLocalizations l10n;

  /// Logger for backend failures.
  final MiniAppLogger logger;

  /// Creates a cubit with an initial idle state.
  TermsOfServiceCubit({
    required this.appApi,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<String>());

  /// Fetches the service terms HTML from the backend.
  Future<void> load() async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final String html = await appApi.getUserContract();
      emit(LoadableState<String>(status: LoadableStatus.success, data: html));
    } catch (error, stackTrace) {
      logger.onError(
        'get_terms_of_service_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        LoadableState<String>(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }
}
