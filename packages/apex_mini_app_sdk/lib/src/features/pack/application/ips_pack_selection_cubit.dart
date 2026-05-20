import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that loads/selects available investment packs.
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

  /// Pack API service.
  final PackService service;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  /// Loads pack list.
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
