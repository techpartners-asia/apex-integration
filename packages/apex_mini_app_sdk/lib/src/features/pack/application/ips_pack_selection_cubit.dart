import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsPackSelectionCubit extends Cubit<LoadableState<List<IpsPack>>> {
  IpsPackSelectionCubit({
    required this.service,
    required this.l10n,
    List<IpsPack>? initialPacks,
  }) : super(
         initialPacks == null
             ? const LoadableState<List<IpsPack>>()
             : LoadableState<List<IpsPack>>(
                 status: LoadableStatus.success,
                 data: List<IpsPack>.unmodifiable(initialPacks),
               ),
       );

  final PackService service;
  final SdkLocalizations l10n;

  Future<void> load({bool forceRefresh = false}) async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final List<IpsPack> packs = await service.getPacks(
        forceRefresh: forceRefresh,
      );

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
