import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class HelpCubit extends Cubit<LoadableState<BranchInfoEntity>> {
  final MiniAppSupportRepository appApi;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  HelpCubit({
    required this.appApi,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<BranchInfoEntity>());

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
