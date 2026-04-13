import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../app/investx_api/backend/mini_app_api_repository.dart';
import '../../shared/application/loadable_state.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';
import '../domain/company_info_entities.dart';

class HelpCubit extends Cubit<LoadableState<CompaniesEntity>> {
  HelpCubit({
    required this.appApi,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<CompaniesEntity>());

  final MiniAppApiRepository appApi;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  Future<void> load({bool forceRefresh = false}) async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final CompaniesEntity company = await appApi.getCompanyInfo(
        forceRefresh: forceRefresh,
      );
      emit(
        LoadableState<CompaniesEntity>(
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
        LoadableState<CompaniesEntity>(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }
}
