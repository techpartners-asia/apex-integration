import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Loads and exposes the user's loyalty milestone list.
class LoyaltyCubit extends Cubit<LoadableState<List<LoyaltyItemDto>>> {
  /// Creates the loyalty cubit.
  LoyaltyCubit({required this.api})
      : super(const LoadableState<List<LoyaltyItemDto>>());

  /// Profile repository used to load loyalty data.
  final MiniAppProfileRepository api;

  /// Fetches the loyalty milestone list from the backend.
  Future<void> load() async {
    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));
    try {
      final List<LoyaltyItemDto> items = await api.getLoyalty();
      emit(
        LoadableState<List<LoyaltyItemDto>>(
          status: LoadableStatus.success,
          data: items,
        ),
      );
    } catch (error) {
      emit(
        LoadableState<List<LoyaltyItemDto>>(
          status: LoadableStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
