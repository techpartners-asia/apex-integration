import 'dart:typed_data';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_helpers/widget_test_app.dart';

void main() {
  testWidgets(
    'short flow submits cached bank details through compact form',
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
              mobile: '99112233',
              secondaryMobile: '88112233',
              email: 'cached@example.com',
              iban: '99112233445566',
              acntName: 'Resolved Account Holder',
              selectedBank: SecAcntBankOption('FI001', 'Khan Bank', 'Khan', ''),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Phone number'), findsNothing);
      expect(find.text('Email'), findsNothing);

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Khan Bank'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText).last,
        '99112233445566',
      );
      await tester.pump();

      await tester.tap(find.text('Continue'));

      expect(api.lastUpdateProfileReq, isNotNull);
      expect(api.lastUpdateProfileReq!.bank?.bankCode, 'FI001');
      expect(api.lastUpdateProfileReq!.bank?.bankName, 'Khan Bank');
    },
  );

  testWidgets(
    'does not pre-fill iban or bank from profile after bank options load',
    (WidgetTester tester) async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();

      await tester.pumpWidget(
        buildSdkTestApp(
          SecAcntPersonalInfoScreen(
            bootstrapState: _openSecAccountBootstrapState(),
            bankOptionsRepository: const _FakeBankOptionsRepository(
              <SecAcntBankOption>[
                SecAcntBankOption('390000', 'Хаан банк', 'ХБ', ''),
                SecAcntBankOption('040000', 'ХХБанк', 'ХХБ', ''),
              ],
            ),
            bankAccountLookupRepository: const _FakeLookupRepository(),
            appApi: api,
            currentUser: UserEntityDto(
              phone: '99112233',
              phoneAddition: '88112233',
              email: 'cached@example.com',
              bank: const BankDto(
                bankCode: ' 040000 ',
                bankName: 'ХХБанк',
                accountNumber: '67000400045318',
              ),
            ),
            initialDraft: const SecAcntFlowDraft(
              mobile: '99112233',
              secondaryMobile: '88112233',
              email: 'cached@example.com',
              iban: '67000400045318',
              acntName: 'АПЕКС КАПИТАЛ ҮЦК',
              selectedBank: SecAcntBankOption(
                '390000',
                'Хаан банк',
                'ХБ',
                '',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ХХБанк'), findsNothing);

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ХХБанк'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText).last,
        '67000400045318',
      );
      await tester.pump();

      await tester.tap(find.text('Continue'));

      expect(api.lastUpdateProfileReq, isNotNull);
      expect(api.lastUpdateProfileReq!.bank?.bankCode, '040000');
      expect(api.lastUpdateProfileReq!.bank?.bankName, 'ХХБанк');
    },
  );

  testWidgets(
    'does not overwrite a manually selected bank when profile bank changes',
    (WidgetTester tester) async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();
      const List<SecAcntBankOption> bankOptions = <SecAcntBankOption>[
        SecAcntBankOption('390000', 'Хаан банк', 'ХБ', ''),
        SecAcntBankOption('040000', 'ХХБанк', 'ХХБ', ''),
        SecAcntBankOption('050000', 'Голомт банк', 'ГБ', ''),
      ];
      const SecAcntFlowDraft initialDraft = SecAcntFlowDraft(
        mobile: '99112233',
        secondaryMobile: '88112233',
        email: 'cached@example.com',
        iban: '67000400045318',
        acntName: 'АПЕКС КАПИТАЛ ҮЦК',
      );

      Widget buildScreen(UserEntityDto currentUser) {
        return buildSdkTestApp(
          SecAcntPersonalInfoScreen(
            bootstrapState: _openSecAccountBootstrapState(),
            bankOptionsRepository: const _FakeBankOptionsRepository(
              bankOptions,
            ),
            bankAccountLookupRepository: const _FakeLookupRepository(),
            appApi: api,
            currentUser: currentUser,
            initialDraft: initialDraft,
          ),
        );
      }

      await tester.pumpWidget(
        buildScreen(
          UserEntityDto(
            phone: '99112233',
            phoneAddition: '88112233',
            email: 'cached@example.com',
            bank: const BankDto(bankCode: '040000', bankName: 'ХХБанк'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ХХБанк'), findsNothing);

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ХХБанк'));
      await tester.pumpAndSettle();

      expect(find.text('ХХБанк'), findsOneWidget);

      await tester.tap(find.text('ХХБанк'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Хаан банк'));
      await tester.pumpAndSettle();

      expect(find.text('Хаан банк'), findsOneWidget);

      await tester.pumpWidget(
        buildScreen(
          UserEntityDto(
            phone: '99112233',
            phoneAddition: '88112233',
            email: 'cached@example.com',
            bank: const BankDto(bankCode: '050000', bankName: 'Голомт банк'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Хаан банк'), findsOneWidget);
      expect(find.text('Голомт банк'), findsNothing);

      await tester.enterText(
        find.byType(EditableText).last,
        '67000400045318',
      );
      await tester.pump();

      await tester.tap(find.text('Continue'));

      expect(api.lastUpdateProfileReq, isNotNull);
      expect(api.lastUpdateProfileReq!.bank?.bankCode, '390000');
      expect(api.lastUpdateProfileReq!.bank?.bankName, 'Хаан банк');
    },
  );

  testWidgets(
    'typing in one field does not validate untouched empty fields',
    (WidgetTester tester) async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();

      await tester.pumpWidget(
        buildSdkTestApp(
          SecAcntPersonalInfoScreen(
            bootstrapState: _fullOnboardingBootstrapState(),
            bankOptionsRepository: const _FakeBankOptionsRepository(),
            bankAccountLookupRepository: const _FakeLookupRepository(),
            appApi: api,
            currentUser: null,
            initialDraft: const SecAcntFlowDraft(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText).first, '99112233');
      await tester.pump();

      expect(find.text('This field is required.'), findsNothing);
    },
  );
}

class _FakeBankOptionsRepository implements SecAcntBankOptionsRepository {
  const _FakeBankOptionsRepository([
    this.options = const <SecAcntBankOption>[
      SecAcntBankOption('FI001', 'Khan Bank', 'Khan', ''),
    ],
  ]);

  final List<SecAcntBankOption> options;

  @override
  Future<List<SecAcntBankOption>> getBankOptions({
    bool forceRefresh = false,
  }) async {
    return options;
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
  Future<String> getUserContract() {
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
  Future<double> getAccountFeesAmount() async => 0;

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) {
    throw UnimplementedError();
  }

  @override
  Future<String> getPaymentCallback({required String uuid}) {
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
  Future<List<LoyaltyItemDto>> getLoyalty() {
    throw UnimplementedError();
  }

  @override
  Future<LoyaltyInfoDto> getLoyaltyInfo() {
    throw UnimplementedError();
  }

  @override
  Future<GrapeQuestionnaireCompletionStatus>
  checkGrapeQuestionnaireCompleted() {
    throw UnimplementedError();
  }

  @override
  Future<void> completeGrapeQuestionnaire({
    required List<GrapeQuestionAnswerSubmission> questions,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<QuestionnaireRes> setGrapeQuestionnaireScore({
    required int totalScore,
  }) {
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

AcntBootstrapState _fullOnboardingBootstrapState() {
  return AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: const GetSecuritiesAcntListDetailDto(
        hasAcnt: false,
        hasIpsAcnt: false,
      ),
      acnts: const <GetSecAcntListAccountDto>[],
      stlAcnts: const <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
