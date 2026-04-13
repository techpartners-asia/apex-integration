import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_sdk/src/app/bootstrap/mini_app_bootstrap_cubit.dart';
import 'package:mini_app_sdk/src/app/bootstrap/mini_app_bootstrap_flow.dart';
import 'package:mini_app_sdk/src/core/exception/api_exception.dart';
import 'package:mini_app_sdk/src/features/ips/shared/application/loadable_state.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/dto/get_sec_acnt_list_res_dto.dart';
import 'package:mini_app_sdk/src/app/session/mini_app_session_controller.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/ips_models.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/services/investment_bootstrap_service.dart';

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
        isA<LoadableState<MiniAppBootstrapRes>>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<LoadableState<MiniAppBootstrapRes>>()
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.data, 'data', isNotNull),
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
        isA<LoadableState<MiniAppBootstrapRes>>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<LoadableState<MiniAppBootstrapRes>>()
            .having((s) => s.isFailure, 'isFailure', true)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
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
        response: GetSecuritiesAccountListResDto(
          detail: GetSecAcntListDetailDto(hasAcnt: false, hasIpsAcnt: false),
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

class _NoopSessionController extends MiniAppSessionController {}

class _NoopBootstrapService extends InvestmentBootstrapService {}
