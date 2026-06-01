import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/foundation.dart';

/// Local bootstrap scenarios for manual flow testing.
///
/// Change [activeCase] and hot-restart the app. Backend data is still fetched,
/// then patched in [ApiInvestmentBootstrapService.getSecAcntListState].
enum DevBootstrapTestCase {
  /// Use backend response as-is.
  disabled,

  /// hasAcnt=true, hasIpsAcnt=true, flag3 status=0 (paid, pending activation).
  pendingPaid,

  /// hasAcnt=true, hasIpsAcnt=true, flag3 status=2 (opening fee unpaid).
  unpaid,

  /// hasAcnt=true, hasIpsAcnt=true, flag3 status=1 (account open).
  open,

  /// hasAcnt=true, hasIpsAcnt=true, flag3 status=null (unknown).
  unknownStatus,

  /// hasAcnt=true, hasIpsAcnt=false, flag3 status=1 (short flow → overview when done).
  shortFlowOpen,

  /// hasAcnt=true, hasIpsAcnt=false, flag3 status=0 (short flow, pending).
  shortFlowPending,

  /// hasAcnt=true, hasIpsAcnt=false, flag3 status=2 (short flow, unpaid).
  shortFlowUnpaid,

  /// hasAcnt=false, hasIpsAcnt=false, no flag3/11/12 rows (brand-new user).
  noSecAcnt,

  /// detail.hasAcnt=false but flag3 row kept (backend mismatch test).
  detailNoAcntWithRow,

  /// detail.hasAcnt=true, hasIpsAcnt=true, no flag3 row (detail-only account).
  detailHasAcntNoRow,
}

/// Dev-only bootstrap patch configuration.
class DevBootstrapOverrides {
  /// Switch the active manual test scenario here.
  static const DevBootstrapTestCase activeCase = DevBootstrapTestCase.disabled;

  static bool get enabled =>
      kDebugMode && activeCase != DevBootstrapTestCase.disabled;
}

/// Applies the selected [DevBootstrapTestCase] to a parsed account-list response.
extension DevBootstrapOverridesX on GetSecuritiesAcntListResDto {
  GetSecuritiesAcntListResDto applyDevBootstrapOverrides() {
    if (!DevBootstrapOverrides.enabled) {
      return this;
    }

    final _DevBootstrapScenario scenario = _DevBootstrapScenario.fromCase(
      DevBootstrapOverrides.activeCase,
    );

    final GetSecuritiesAcntListDetailDto patchedDetail = detail.copyWith(
      hasAcnt: scenario.detailHasAcnt,
      hasIpsAcnt: scenario.detailHasIpsAcnt,
    );

    List<GetSecAcntListAccountDto> patchedAcnts = List<GetSecAcntListAccountDto>.of(
      acnts,
    );

    if (!scenario.includeIpsRows) {
      patchedAcnts.removeWhere(
        (GetSecAcntListAccountDto row) => row.flag == 11 || row.flag == 12,
      );
    }

    if (scenario.includeSecAcntRow) {
      patchedAcnts.removeWhere((GetSecAcntListAccountDto row) => row.flag == 3);
      patchedAcnts.add(
        GetSecAcntListAccountDto(
          flag: 3,
          status: scenario.secAcntStatus,
          scAcntCode: securitiesAccount?.scAcntCode ?? '007890007729',
          acntCode: securitiesAccount?.acntCode ?? '007890007729',
          brokerId: securitiesAccount?.brokerId ?? '78',
          isMain: true,
        ),
      );
    } else {
      patchedAcnts.removeWhere((GetSecAcntListAccountDto row) => row.flag == 3);
    }

    if (scenario.includeIpsRows) {
      if (!patchedAcnts.any((GetSecAcntListAccountDto row) => row.flag == 11)) {
        patchedAcnts.add(
          const GetSecAcntListAccountDto(
            flag: 11,
            status: 1,
            scAcntCode: '007890007812',
            acntCode: '007890007812',
          ),
        );
      }
      if (!patchedAcnts.any((GetSecAcntListAccountDto row) => row.flag == 12)) {
        patchedAcnts.add(
          const GetSecAcntListAccountDto(
            flag: 12,
            scAcntCode: '007890007812',
            acntCode: '1000759213',
          ),
        );
      }
    }

    return copyWith(detail: patchedDetail, acnts: patchedAcnts);
  }
}

class _DevBootstrapScenario {
  const _DevBootstrapScenario({
    required this.detailHasAcnt,
    required this.detailHasIpsAcnt,
    required this.includeSecAcntRow,
    required this.includeIpsRows,
    this.secAcntStatus,
  });

  final bool detailHasAcnt;
  final bool detailHasIpsAcnt;
  final bool includeSecAcntRow;
  final bool includeIpsRows;
  final int? secAcntStatus;

  factory _DevBootstrapScenario.fromCase(DevBootstrapTestCase testCase) {
    return switch (testCase) {
      DevBootstrapTestCase.disabled ||
      DevBootstrapTestCase.pendingPaid => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: true,
        includeSecAcntRow: true,
        includeIpsRows: true,
        secAcntStatus: AcntBootstrapState.secAcntStatusPending,
      ),
      DevBootstrapTestCase.unpaid => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: true,
        includeSecAcntRow: true,
        includeIpsRows: true,
        secAcntStatus: AcntBootstrapState.secAcntStatusUnpaid,
      ),
      DevBootstrapTestCase.open => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: true,
        includeSecAcntRow: true,
        includeIpsRows: true,
        secAcntStatus: AcntBootstrapState.secAcntStatusOpen,
      ),
      DevBootstrapTestCase.unknownStatus => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: true,
        includeSecAcntRow: true,
        includeIpsRows: true,
        secAcntStatus: null,
      ),
      DevBootstrapTestCase.shortFlowOpen => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: false,
        includeSecAcntRow: true,
        includeIpsRows: false,
        secAcntStatus: AcntBootstrapState.secAcntStatusOpen,
      ),
      DevBootstrapTestCase.shortFlowPending => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: false,
        includeSecAcntRow: true,
        includeIpsRows: false,
        secAcntStatus: AcntBootstrapState.secAcntStatusPending,
      ),
      DevBootstrapTestCase.shortFlowUnpaid => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: false,
        includeSecAcntRow: true,
        includeIpsRows: false,
        secAcntStatus: AcntBootstrapState.secAcntStatusUnpaid,
      ),
      DevBootstrapTestCase.noSecAcnt => const _DevBootstrapScenario(
        detailHasAcnt: false,
        detailHasIpsAcnt: false,
        includeSecAcntRow: false,
        includeIpsRows: false,
      ),
      DevBootstrapTestCase.detailNoAcntWithRow => const _DevBootstrapScenario(
        detailHasAcnt: false,
        detailHasIpsAcnt: false,
        includeSecAcntRow: true,
        includeIpsRows: false,
        secAcntStatus: AcntBootstrapState.secAcntStatusPending,
      ),
      DevBootstrapTestCase.detailHasAcntNoRow => const _DevBootstrapScenario(
        detailHasAcnt: true,
        detailHasIpsAcnt: true,
        includeSecAcntRow: false,
        includeIpsRows: true,
      ),
    };
  }
}

/// Logs derived bootstrap flags after dev overrides are applied.
void logDevBootstrapSnapshot(GetSecuritiesAcntListResDto response) {
  if (!DevBootstrapOverrides.enabled) {
    return;
  }

  final AcntBootstrapState state = AcntBootstrapState(response: response);
  debugPrint(
    '[DevBootstrapOverrides:${DevBootstrapOverrides.activeCase.name}] '
    'detail.hasAcnt=${response.detail.hasAcnt} '
    'detail.hasIpsAcnt=${response.detail.hasIpsAcnt} '
    'flag3=${response.securitiesAccount != null} '
    'flag3.status=${response.securitiesAccount?.status} '
    'flag11=${response.ipsMasterAccount != null} '
    'flag12=${response.ipsCasaAccount != null} '
    '=> hasAcnt=${state.hasAcnt} '
    'hasIpsAcnt=${state.hasIpsAcnt} '
    'hasOpenSecAcnt=${state.hasOpenSecAcnt} '
    'hasPaidOpeningFee=${state.hasPaidSecAcntOpeningFeeFromApi} '
    'pendingActivation=${state.hasPendingSecAcntActivation}',
  );
}
