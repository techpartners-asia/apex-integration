import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_helpers/widget_test_app.dart';

void main() {
  testWidgets(
    'missing account starts at personal info when contract is unpaid',
    (WidgetTester tester) async {
      OverviewVerificationViewModel? model;

      await tester.pumpWidget(
        buildSdkTestApp(
          Builder(
            builder: (BuildContext context) {
              model = buildOverviewVerificationViewModel(
                context,
                _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
                hasPaidSecAcntContract: false,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(model?.progressCurrent, 0);
      expect(model?.steps[0].status, StepStatus.active);
      expect(model?.steps[0].onTap, isNotNull);
      expect(model?.steps[1].status, StepStatus.upcoming);
      expect(model?.steps[1].onTap, isNull);
    },
  );

  testWidgets(
    'missing account advances to account opening when contract is paid',
    (WidgetTester tester) async {
      OverviewVerificationViewModel? model;

      await tester.pumpWidget(
        buildSdkTestApp(
          Builder(
            builder: (BuildContext context) {
              model = buildOverviewVerificationViewModel(
                context,
                _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
                hasPaidSecAcntContract: true,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(model?.progressCurrent, 1);
      expect(model?.steps[0].status, StepStatus.completed);
      expect(model?.steps[0].onTap, isNull);
      expect(model?.steps[1].status, StepStatus.active);
      expect(model?.steps[1].onTap, isNotNull);
      expect(model?.onPromoTap, isNotNull);
    },
  );

  testWidgets(
    'open securities account without IPS routes final step to questionnaire',
    (WidgetTester tester) async {
      OverviewVerificationViewModel? model;

      await tester.pumpWidget(
        buildSdkTestApp(
          Builder(
            builder: (BuildContext context) {
              model = buildOverviewVerificationViewModel(
                context,
                _bootstrapState(
                  hasAcnt: true,
                  hasIpsAcnt: false,
                  secAcntStatusCode: AcntBootstrapState.secAcntStatusOpen,
                ),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(model?.progressCurrent, 2);
      expect(model?.steps[1].status, StepStatus.completed);
      expect(model?.steps[1].onTap, isNull);
      expect(model?.steps[2].status, StepStatus.active);
      expect(model?.steps[2].onTap, isNotNull);
      expect(model?.onPromoTap, isNotNull);
    },
  );

  testWidgets(
    'pending paid securities account without IPS matches open overview flow',
    (WidgetTester tester) async {
      OverviewVerificationViewModel? openModel;
      OverviewVerificationViewModel? pendingModel;

      await tester.pumpWidget(
        buildSdkTestApp(
          Builder(
            builder: (BuildContext context) {
              openModel = buildOverviewVerificationViewModel(
                context,
                _bootstrapState(
                  hasAcnt: true,
                  hasIpsAcnt: false,
                  secAcntStatusCode: AcntBootstrapState.secAcntStatusOpen,
                ),
              );
              pendingModel = buildOverviewVerificationViewModel(
                context,
                _bootstrapState(
                  hasAcnt: true,
                  hasIpsAcnt: false,
                  secAcntStatusCode: AcntBootstrapState.secAcntStatusPending,
                ),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(pendingModel?.progressCurrent, openModel?.progressCurrent);
      expect(pendingModel?.steps[1].status, openModel?.steps[1].status);
      expect(pendingModel?.steps[1].onTap, isNull);
      expect(pendingModel?.steps[2].status, StepStatus.active);
      expect(pendingModel?.steps[2].onTap, isNotNull);
    },
  );

  testWidgets(
    'unpaid securities account without IPS keeps payment step active',
    (WidgetTester tester) async {
      OverviewVerificationViewModel? model;

      await tester.pumpWidget(
        buildSdkTestApp(
          Builder(
            builder: (BuildContext context) {
              model = buildOverviewVerificationViewModel(
                context,
                _bootstrapState(
                  hasAcnt: true,
                  hasIpsAcnt: false,
                  secAcntStatusCode: AcntBootstrapState.secAcntStatusUnpaid,
                ),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(model?.progressCurrent, 1);
      expect(model?.steps[1].status, StepStatus.active);
      expect(model?.steps[1].onTap, isNotNull);
      expect(model?.steps[2].status, StepStatus.upcoming);
      expect(model?.steps[2].onTap, isNull);
    },
  );
}

AcntBootstrapState _bootstrapState({
  required bool hasAcnt,
  required bool hasIpsAcnt,
  int? secAcntStatusCode,
}) {
  return AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: GetSecuritiesAcntListDetailDto(
        hasAcnt: hasAcnt,
        hasIpsAcnt: hasIpsAcnt,
      ),
      acnts: secAcntStatusCode == null
          ? const <GetSecAcntListAccountDto>[]
          : <GetSecAcntListAccountDto>[
              GetSecAcntListAccountDto(
                flag: 3,
                status: secAcntStatusCode,
              ),
            ],
      stlAcnts: const <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
