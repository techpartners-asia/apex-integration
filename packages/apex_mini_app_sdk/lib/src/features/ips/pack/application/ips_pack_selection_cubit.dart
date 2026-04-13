import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';

import '../../shared/application/loadable_state.dart';
import '../../shared/domain/services/investment_services.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';

class IpsPackSelectionCubit extends Cubit<LoadableState<List<IpsPack>>> {
  IpsPackSelectionCubit({required this.service, required this.l10n})
    : super(const LoadableState<List<IpsPack>>());

  final PackService service;
  final SdkLocalizations l10n;

  Future<void> load() async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final List<IpsPack> packs = await service.getPacks();

      emit(
        LoadableState<List<IpsPack>>(
          status: LoadableStatus.success,
          data: packs,
        ),
      );
    } catch (error) {
      emit(
        LoadableState<List<IpsPack>>(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }
}
