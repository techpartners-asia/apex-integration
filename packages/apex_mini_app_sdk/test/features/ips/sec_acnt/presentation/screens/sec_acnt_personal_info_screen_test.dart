import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

import '../../../../../test_helpers/widget_test_app.dart';

void main() {
  testWidgets(
    'short flow submits cached bank details and opens success screen',
    (WidgetTester tester) async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();

      await tester.pumpWidget(
        buildSdkTestApp(
          SecAcntPersonalInfoScreen(
            bootstrapState: _openSecAccountBootstrapState(),
            bankOptionsRepository: const _FakeBankOptionsRepository(),
            bankAccountLookupRepository: const _FakeLookupRepository(),
            appApi: api,
            currentUser: UserEntityDto(
              phone: '99112233',
              phoneAddition: '88112233',
              email: 'cached@example.com',
            ),
            initialDraft: const SecAcntFlowDraft(
              iban: '991122334455667788',
              selectedBank: SecAcntBankOption('FI001', 'Khan Bank', 'Khan', ''),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Phone number'), findsNothing);
      expect(find.text('Email'), findsNothing);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(api.lastUpdateProfileReq, isNotNull);
      expect(api.lastUpdateProfileReq!.bank?.bankCode, 'FI001');
      expect(api.lastUpdateProfileReq!.bank?.bankName, 'Khan Bank');
      expect(find.byType(SecAcntSuccessScreen), findsOneWidget);
    },
  );
}

class _FakeBankOptionsRepository implements SecAcntBankOptionsRepository {
  const _FakeBankOptionsRepository();

  @override
  Future<List<SecAcntBankOption>> getBankOptions({
    bool forceRefresh = false,
  }) async {
    return const <SecAcntBankOption>[
      SecAcntBankOption('FI001', 'Khan Bank', 'Khan', ''),
    ];
  }
}

class _FakeLookupRepository implements SecAcntBankAccountLookupRepository {
  const _FakeLookupRepository();

  @override
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) async {
    return const SecAcntBankAccountLookupResult(
      responseCode: 0,
      accountHolderName: 'Resolved Account Holder',
    );
  }
}

class _FakeMiniAppApiRepository implements MiniAppApiRepository {
  UpdateProfileApiReq? lastUpdateProfileReq;

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) {
    throw UnimplementedError();
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
  }) {
    throw UnimplementedError();
  }

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) {
    throw UnimplementedError();
  }

  @override
  Future<String> getPaymentCallback({required String invoiceId}) {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> getProfileInfo() {
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionnaireQuestion>> getAllGoals() {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) async {
    lastUpdateProfileReq = req;
    return UserEntityDto();
  }

  @override
  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) {
    throw UnimplementedError();
  }
}

AcntBootstrapState _openSecAccountBootstrapState() {
  return AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: const GetSecuritiesAcntListDetailDto(
        hasAcnt: true,
        hasIpsAcnt: false,
      ),
      acnts: const <GetSecAcntListAccountDto>[
        GetSecAcntListAccountDto(flag: 3, status: 1),
      ],
      stlAcnts: const <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
