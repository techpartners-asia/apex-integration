import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  final SdkLocalizations l10n = lookupSdkLocalizations(const Locale('en'));

  group('FeedbackCubit', () {
    blocTest<FeedbackCubit, FeedbackState>(
      'initial state has no items and is not submitting',
      build: () => FeedbackCubit(appApi: _SuccessApi(), l10n: l10n),
      verify: (FeedbackCubit cubit) {
        expect(cubit.state.items, isEmpty);
        expect(cubit.state.isSubmitting, isFalse);
        expect(cubit.state.lastCreated, isNull);
        expect(cubit.state.errorMessage, isNull);
      },
    );

    blocTest<FeedbackCubit, FeedbackState>(
      'createFeedback emits submitting then success with entity',
      build: () => FeedbackCubit(appApi: _SuccessApi(), l10n: l10n),
      act: (FeedbackCubit cubit) => cubit.createFeedback(
        title: 'Test',
        description: 'Body',
      ),
      expect: () => <TypeMatcher<FeedbackState>>[
        isA<FeedbackState>().having(
          (FeedbackState s) => s.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        isA<FeedbackState>()
            .having(
              (FeedbackState s) => s.isSubmitting,
              'isSubmitting',
              isFalse,
            )
            .having(
              (FeedbackState s) => s.items.length,
              'items.length',
              1,
            )
            .having(
              (FeedbackState s) => s.lastCreated?.title,
              'lastCreated.title',
              'Test',
            ),
      ],
    );

    blocTest<FeedbackCubit, FeedbackState>(
      'createFeedback emits error when API throws',
      build: () => FeedbackCubit(appApi: _FailingApi(), l10n: l10n),
      act: (FeedbackCubit cubit) => cubit.createFeedback(
        title: 'Test',
        description: 'Body',
      ),
      expect: () => <TypeMatcher<FeedbackState>>[
        isA<FeedbackState>().having(
          (FeedbackState s) => s.isSubmitting,
          'isSubmitting',
          isTrue,
        ),
        isA<FeedbackState>()
            .having(
              (FeedbackState s) => s.isSubmitting,
              'isSubmitting',
              isFalse,
            )
            .having(
              (FeedbackState s) => s.errorMessage,
              'errorMessage',
              isNotNull,
            )
            .having(
              (FeedbackState s) => s.items,
              'items',
              isEmpty,
            ),
      ],
    );

    blocTest<FeedbackCubit, FeedbackState>(
      'clearFeedback resets lastCreated and errorMessage',
      build: () => FeedbackCubit(appApi: _SuccessApi(), l10n: l10n),
      seed: () => FeedbackState(
        lastCreated: _fakeFeedbackEntity(),
        errorMessage: 'some error',
      ),
      act: (FeedbackCubit cubit) => cubit.clearFeedback(),
      expect: () => <TypeMatcher<FeedbackState>>[
        isA<FeedbackState>()
            .having(
              (FeedbackState s) => s.lastCreated,
              'lastCreated',
              isNull,
            )
            .having(
              (FeedbackState s) => s.errorMessage,
              'errorMessage',
              isNull,
            ),
      ],
    );

    blocTest<FeedbackCubit, FeedbackState>(
      'multiple createFeedback calls accumulate items',
      build: () => FeedbackCubit(appApi: _SuccessApi(), l10n: l10n),
      act: (FeedbackCubit cubit) async {
        await cubit.createFeedback(title: 'First', description: 'A');
        await cubit.createFeedback(title: 'Second', description: 'B');
      },
      verify: (FeedbackCubit cubit) {
        expect(cubit.state.items.length, 2);
        expect(cubit.state.items.first.title, 'Second');
        expect(cubit.state.items.last.title, 'First');
      },
    );

    blocTest<FeedbackCubit, FeedbackState>(
      'load emits feedback list and pagination metadata',
      build: () => FeedbackCubit(appApi: _SuccessApi(), l10n: l10n),
      act: (FeedbackCubit cubit) => cubit.load(limit: 2),
      expect: () => <TypeMatcher<FeedbackState>>[
        isA<FeedbackState>().having(
          (FeedbackState s) => s.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<FeedbackState>()
            .having((FeedbackState s) => s.isLoading, 'isLoading', isFalse)
            .having((FeedbackState s) => s.items.length, 'items.length', 2)
            .having((FeedbackState s) => s.currentPage, 'currentPage', 1)
            .having((FeedbackState s) => s.total, 'total', 3),
      ],
    );

    blocTest<FeedbackCubit, FeedbackState>(
      'loadNextPage appends items',
      build: () => FeedbackCubit(appApi: _SuccessApi(), l10n: l10n),
      act: (FeedbackCubit cubit) async {
        await cubit.load(limit: 2);
        await cubit.loadNextPage();
      },
      verify: (FeedbackCubit cubit) {
        expect(cubit.state.items.length, 3);
        expect(cubit.state.currentPage, 2);
      },
    );

    test('refresh forces a fresh list fetch', () async {
      final _SuccessApi api = _SuccessApi();
      final FeedbackCubit cubit = FeedbackCubit(appApi: api, l10n: l10n);

      await cubit.refresh();

      expect(api.lastForceRefresh, isTrue);
    });
  });
}

FeedbackEntity _fakeFeedbackEntity({String title = 'Test'}) {
  return FeedbackEntity(
    id: 1,
    title: title,
    description: 'Body',
    status: FeedbackStatus.pending,
    createdAt: '2026-01-01',
    updatedAt: '2026-01-01',
    userId: 42,
  );
}

class _SuccessApi extends MiniAppApiRepository {
  int _counter = 0;
  bool? lastForceRefresh;

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) async {
    _counter++;
    return FeedbackEntity(
      id: _counter,
      title: req.title,
      description: req.description,
      status: FeedbackStatus.pending,
      createdAt: '2026-01-01',
      updatedAt: '2026-01-01',
      userId: 42,
    );
  }

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) {
    throw UnimplementedError();
  }

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) async {
    lastForceRefresh = forceRefresh;
    final List<FeedbackEntity> allItems = <FeedbackEntity>[
      _fakeFeedbackEntity(title: 'First'),
      _fakeFeedbackEntity(title: 'Second'),
      _fakeFeedbackEntity(title: 'Third'),
    ];
    final int start = (page - 1) * limit;
    final int end = (start + limit).clamp(0, allItems.length);
    final List<FeedbackEntity> pageItems = start >= allItems.length
        ? const <FeedbackEntity>[]
        : allItems.sublist(start, end);
    return FeedbackListResponse(
      items: pageItems,
      total: allItems.length,
    );
  }
}

class _FailingApi extends MiniAppApiRepository {
  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) async {
    throw const ApiBusinessException(
      responseCode: 1,
      message: 'Server error',
    );
  }

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) {
    throw UnimplementedError();
  }

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) async {
    throw const ApiBusinessException(
      responseCode: 1,
      message: 'Server error',
    );
  }
}
