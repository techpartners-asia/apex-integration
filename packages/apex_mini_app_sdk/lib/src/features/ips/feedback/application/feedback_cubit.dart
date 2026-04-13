import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../app/investx_api/backend/mini_app_api_repository.dart';
import '../../../../app/investx_api/req/create_feedback_api_req.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';
import '../domain/feedback_entity.dart';
import '../domain/feedback_list_response.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit({
    required this.appApi,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const FeedbackState());

  final MiniAppApiRepository appApi;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  Future<void> load({
    int page = 1,
    int? limit,
    bool forceRefresh = false,
  }) async {
    if (state.isLoading || state.isLoadingMore) return;

    final int resolvedLimit = limit ?? state.pageSize;
    final bool isInitialPage = page <= 1;

    emit(
      state.copyWith(
        isLoading: isInitialPage,
        isLoadingMore: !isInitialPage,
        errorMessage: null,
        pageSize: resolvedLimit,
      ),
    );

    try {
      final FeedbackListResponse response = await appApi.getFeedbackList(
        limit: resolvedLimit,
        page: page,
        forceRefresh: forceRefresh,
      );
      final List<FeedbackEntity> nextItems = isInitialPage
          ? response.items
          : <FeedbackEntity>[...state.items, ...response.items];

      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          items: nextItems,
          currentPage: page,
          total: response.total,
          errorMessage: null,
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'get_feedback_list_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    await load(page: state.currentPage + 1, limit: state.pageSize);
  }

  Future<void> refresh() async {
    await load(page: 1, limit: state.pageSize, forceRefresh: true);
  }

  Future<void> createFeedback({
    required String title,
    required String description,
  }) async {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        lastCreated: null,
      ),
    );

    try {
      final FeedbackEntity entity = await appApi.createFeedback(
        CreateFeedbackApiReq(title: title, description: description),
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          items: <FeedbackEntity>[entity, ...state.items],
          lastCreated: entity,
          total: state.total + 1,
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'create_feedback_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  void clearFeedback() {
    emit(state.copyWith(lastCreated: null, errorMessage: null));
  }
}
