import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  final SdkLocalizations l10n = lookupSdkLocalizations(const Locale('en'));

  blocTest<HelpCubit, LoadableState<BranchInfoEntity>>(
    'load emits success state when company info is returned',
    build: () => HelpCubit(appApi: _SuccessApi(), l10n: l10n),
    act: (HelpCubit cubit) => cubit.load(),
    expect: () => <Matcher>[
      isA<LoadableState<BranchInfoEntity>>().having(
        (LoadableState<BranchInfoEntity> s) => s.status,
        'status',
        LoadableStatus.loading,
      ),
      isA<LoadableState<BranchInfoEntity>>()
          .having(
            (LoadableState<BranchInfoEntity> s) => s.status,
            'status',
            LoadableStatus.success,
          )
          .having(
            (LoadableState<BranchInfoEntity> s) => s.data?.email,
            'email',
            'info@investx.mn',
          ),
    ],
  );

  blocTest<HelpCubit, LoadableState<BranchInfoEntity>>(
    'load emits failure state when company info loading fails',
    build: () => HelpCubit(appApi: _FailingApi(), l10n: l10n),
    act: (HelpCubit cubit) => cubit.load(),
    expect: () => <Matcher>[
      isA<LoadableState<BranchInfoEntity>>().having(
        (LoadableState<BranchInfoEntity> s) => s.status,
        'status',
        LoadableStatus.loading,
      ),
      isA<LoadableState<BranchInfoEntity>>().having(
        (LoadableState<BranchInfoEntity> s) => s.status,
        'status',
        LoadableStatus.failure,
      ),
    ],
  );

  test('load(forceRefresh: true) bypasses the cache path explicitly', () async {
    final _SuccessApi api = _SuccessApi();
    final HelpCubit cubit = HelpCubit(appApi: api, l10n: l10n);

    await cubit.load(forceRefresh: true);

    expect(api.lastForceRefresh, isTrue);
  });
}

class _SuccessApi implements MiniAppApiRepository {
  bool? lastForceRefresh;

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) async {
    lastForceRefresh = forceRefresh;
    return const BranchInfoEntity(
      email: 'info@investx.mn',
      phone: '75107500',
      socialLinks: <SocialMediaEntity>[
        SocialMediaEntity(
          name: 'InvestX',
          link: 'https://investx.mn',
          type: SocialMediaType.website,
        ),
      ],
    );
  }

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) {
    throw UnimplementedError();
  }

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) {
    throw UnimplementedError();
  }

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> getPaymentCallback({required String invoiceId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionnaireQuestion>> getAllGoals() {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> getProfileInfo() {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateSignature({
    required bytes,
    String fileName = 'signature.png',
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) {
    throw UnimplementedError();
  }
}

class _FailingApi extends _SuccessApi {
  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) async {
    throw const ApiBusinessException(responseCode: 1, message: 'Failed');
  }
}
