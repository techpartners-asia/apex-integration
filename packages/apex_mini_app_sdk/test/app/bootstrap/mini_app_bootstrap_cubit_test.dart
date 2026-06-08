import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:apex_mini_app_sdk/src/app/bootstrap/profile_incomplete_signup_exception.dart';
import 'package:apex_mini_app_sdk/src/app/bootstrap/signup_bootstrap_exception.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final SdkLocalizations l10n = lookupSdkLocalizations(const Locale('en'));

  group('MiniAppBootstrapCubit', () {
    blocTest<MiniAppBootstrapCubit, LoadableState<MiniAppBootstrapRes>>(
      'emits [loading, success] when resolve succeeds',
      build: () => MiniAppBootstrapCubit(
        bootstrapFlow: _SuccessBootstrapFlow(),
        l10n: l10n,
      ),
      act: (cubit) => cubit.load(),
      expect: () => <dynamic>[
        isA<LoadableState<MiniAppBootstrapRes>>().having(
          (s) => s.isLoading,
          'isLoading',
          true,
        ),
        isA<LoadableState<MiniAppBootstrapRes>>().having((s) => s.isSuccess, 'isSuccess', true).having((s) => s.data, 'data', isNotNull),
      ],
    );

    blocTest<MiniAppBootstrapCubit, LoadableState<MiniAppBootstrapRes>>(
      'emits [loading, failure] when resolve throws',
      build: () => MiniAppBootstrapCubit(
        bootstrapFlow: _FailingBootstrapFlow(),
        l10n: l10n,
      ),
      act: (cubit) => cubit.load(),
      expect: () => <dynamic>[
        isA<LoadableState<MiniAppBootstrapRes>>().having(
          (s) => s.isLoading,
          'isLoading',
          true,
        ),
        isA<LoadableState<MiniAppBootstrapRes>>().having((s) => s.isFailure, 'isFailure', true).having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<MiniAppBootstrapCubit, LoadableState<MiniAppBootstrapRes>>(
      'stores signup business response code on bootstrap failure',
      build: () => MiniAppBootstrapCubit(
        bootstrapFlow: _ProfileNotVerifiedBootstrapFlow(),
        l10n: l10n,
      ),
      act: (cubit) async {
        await cubit.load();
      },
      verify: (MiniAppBootstrapCubit cubit) {
        expect(
          cubit.failureResponseCode,
          SignupBusinessCodes.profileNotVerified,
        );
        expect(cubit.failureFromSignup, isTrue);
      },
    );

    blocTest<MiniAppBootstrapCubit, LoadableState<MiniAppBootstrapRes>>(
      'marks profile incomplete signup failures',
      build: () => MiniAppBootstrapCubit(
        bootstrapFlow: _ProfileIncompleteBootstrapFlow(),
        l10n: l10n,
      ),
      act: (cubit) async {
        await cubit.load();
      },
      verify: (MiniAppBootstrapCubit cubit) {
        expect(cubit.failureFromSignup, isTrue);
        expect(cubit.failureIsProfileIncomplete, isTrue);
        expect(cubit.failureResponseCode, isNull);
      },
    );
  });
}

class _SuccessBootstrapFlow extends MiniAppBootstrapFlow {
  _SuccessBootstrapFlow()
    : super(
        sessionController: _NoopSessionController(),
        bootstrapService: _NoopBootstrapService(),
      );

  @override
  Future<MiniAppBootstrapRes> resolve() async {
    return MiniAppBootstrapRes(
      bootstrapState: const AcntBootstrapState(
        response: GetSecuritiesAcntListResDto(
          detail: GetSecuritiesAcntListDetailDto(
            hasAcnt: false,
            hasIpsAcnt: false,
          ),
          acnts: <GetSecAcntListAccountDto>[],
          stlAcnts: <GetSecAcntSettlementAccountDto>[],
          responseCode: 0,
        ),
      ),
      nextRoute: '/overview',
    );
  }
}

class _FailingBootstrapFlow extends MiniAppBootstrapFlow {
  _FailingBootstrapFlow()
    : super(
        sessionController: _NoopSessionController(),
        bootstrapService: _NoopBootstrapService(),
      );

  @override
  Future<MiniAppBootstrapRes> resolve() async {
    throw const ApiNetworkException('Server unreachable');
  }
}

class _ProfileNotVerifiedBootstrapFlow extends MiniAppBootstrapFlow {
  _ProfileNotVerifiedBootstrapFlow()
    : super(
        sessionController: _NoopSessionController(),
        bootstrapService: _NoopBootstrapService(),
      );

  @override
  Future<MiniAppBootstrapRes> resolve() async {
    throw SignupBootstrapException(
      const ApiBusinessException(
        responseCode: SignupBusinessCodes.profileNotVerified,
        message: 'Profile not verified.',
      ),
    );
  }
}

class _ProfileIncompleteBootstrapFlow extends MiniAppBootstrapFlow {
  _ProfileIncompleteBootstrapFlow()
    : super(
        sessionController: _NoopSessionController(),
        bootstrapService: _NoopBootstrapService(),
      );

  @override
  Future<MiniAppBootstrapRes> resolve() async {
    throw const SignupBootstrapException(
      ProfileIncompleteSignupException(),
    );
  }
}

class _NoopSessionController implements MiniAppSessionController {
  @override
  void cacheCurrentUser(UserEntityDto user) {
    // TODO: implement cacheCurrentUser
  }

  @override
  // TODO: implement currentUser
  UserEntityDto? get currentUser => throw UnimplementedError();

  @override
  Future<UserEntityDto> ensureCurrentUser() {
    // TODO: implement ensureCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<LoginSession> ensureLoginSession() {
    // TODO: implement ensureLoginSession
    throw UnimplementedError();
  }

  @override
  // TODO: implement loginSession
  LoginSession? get loginSession => throw UnimplementedError();

  @override
  void prepareLaunch({String? userToken}) {
    // TODO: implement prepareLaunch
  }

  @override
  Future<LoginSession> refreshLoginSession() {
    // TODO: implement refreshLoginSession
    throw UnimplementedError();
  }

  @override
  // TODO: implement store
  MiniAppSessionStore get store => throw UnimplementedError();

  @override
  // TODO: implement userToken
  String? get userToken => throw UnimplementedError();
}

class _NoopBootstrapService implements InvestmentBootstrapService {
  @override
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) {
    // TODO: implement addSecuritiesAcntReq
    throw UnimplementedError();
  }

  @override
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) {
    // TODO: implement getSecAcntBalanceState
    throw UnimplementedError();
  }

  @override
  Future<AcntBootstrapState> getSecAcntListState({bool forceRefresh = false}) {
    // TODO: implement getSecAcntListState
    throw UnimplementedError();
  }
}
