import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Loads company support information for the Help screen.
class HelpCubit extends Cubit<LoadableState<BranchInfoEntity>> {
  /// Repository facade for support/company-info endpoints.
  final MiniAppSupportRepository appApi;

  /// Localization source used to format fallback errors.
  final SdkLocalizations l10n;

  /// Logger used for backend failures.
  final MiniAppLogger logger;

  /// Creates a cubit with an initial idle state.
  HelpCubit({
    required this.appApi,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<BranchInfoEntity>());

  /// Fetches company info and optionally bypasses the in-memory cache.
  Future<void> load({bool forceRefresh = false}) async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final BranchInfoEntity company = await appApi.getCompanyInfo(
        forceRefresh: forceRefresh,
      );
      emit(
        LoadableState<BranchInfoEntity>(
          status: LoadableStatus.success,
          data: company,
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'get_company_info_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        LoadableState<BranchInfoEntity>(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }
}
