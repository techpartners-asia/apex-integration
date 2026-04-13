import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/app/investx_api/backend/mini_app_api_repository.dart';
import 'package:mini_app_sdk/src/app/investx_api/dto/user_entity_dto.dart';
import 'package:mini_app_sdk/src/app/investx_api/models/mini_app_payment.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/create_feedback_api_req.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/create_invoice_api_req.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/update_profile_api_req.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/update_target_goal_api_req.dart';
import 'package:mini_app_sdk/src/features/ips/feedback/domain/feedback_entity.dart';
import 'package:mini_app_sdk/src/features/ips/feedback/domain/feedback_list_response.dart';
import 'package:mini_app_sdk/src/features/ips/help/domain/company_info_entities.dart';
import 'package:mini_app_sdk/src/features/ips/profile/presentation/screens/personal_info_screen.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/application/sec_acnt_bank_account_lookup_repository.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/application/sec_acnt_bank_options_repository.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/presentation/flow/sec_acnt_flow.dart';
import 'package:mini_app_sdk/src/features/ips/shared/presentation/widgets/investx_text_field.dart';

import '../../../../../test_helpers/widget_test_app.dart';

void main() {
  testWidgets(
    'screen pre-fills residence and employment values from profile info',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildSdkTestApp(
          PersonalInfoScreen(
            appApi: _FakeMiniAppApiRepository(),
            bankOptionsRepository: const _FakeBankOptionsRepository(),
            bankAccountLookupRepository: _FakeLookupRepository(),
            currentUser: UserEntityDto(
              currentDepartment: 'Technology',
              currentPosition: 'Engineer',
              residenceAddress: 'Ulaanbaatar',
              residenceCountry: 'Mongolia',
              region: const RegionDto(name: 'Монгол'),
              bank: const BankDto(bankName: 'ХААН БАНК'),
            ),
          ),
        ),
      );

      expect(find.text('Mongolia'), findsOneWidget);
      expect(find.text('Монгол'), findsOneWidget);
      expect(find.text('ХААН БАНК'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
      expect(find.text('Ulaanbaatar'), findsOneWidget);
    },
  );

  testWidgets(
    'save calls updateProfile with updateInformation action type',
    (WidgetTester tester) async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();
      final _FakeLookupRepository lookup = _FakeLookupRepository(
        result: SecAcntBankAccountLookupResult(
          responseCode: 0,
          accountHolderName: 'Resolved Holder',
        ),
      );

      await tester.pumpWidget(
        buildSdkTestApp(
          PersonalInfoScreen(
            appApi: api,
            bankOptionsRepository: const _FakeBankOptionsRepository(),
            bankAccountLookupRepository: lookup,
            currentUser: UserEntityDto(
              lastName: 'User',
              firstName: 'Test',
              email: 'old@example.com',
              phone: '99112233',
              bank: BankDto(
                bankCode: '390000',
                bankName: 'Khan Bank',
                accountNumber: '991122334455667788',
                accountName: 'Old Holder',
              ),
            ),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(InvestXTextField, 'Цахим шуудан'),
        'updated@example.com',
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(api.lastUpdateProfileReq, isNotNull);
      expect(
        api.lastUpdateProfileReq!.actionType,
        UpdateProfileActionType.updateInformation,
      );
      expect(api.lastUpdateProfileReq!.email, 'updated@example.com');
      expect(api.lastUpdateProfileReq!.bank?.accountName, 'Resolved Holder');
      expect(lookup.lastBankCode, '390000');
      expect(lookup.lastAccountNumber, '991122334455667788');
    },
  );

  testWidgets(
    'lookup failure prevents sending profile update with incorrect account name',
    (WidgetTester tester) async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();
      final _FakeLookupRepository lookup = _FakeLookupRepository(
        result: const SecAcntBankAccountLookupResult(
          responseCode: 1,
          responseDesc: 'Account holder not found',
          accountHolderName: null,
        ),
      );

      await tester.pumpWidget(
        buildSdkTestApp(
          PersonalInfoScreen(
            appApi: api,
            bankOptionsRepository: const _FakeBankOptionsRepository(),
            bankAccountLookupRepository: lookup,
            currentUser: UserEntityDto(
              bank: const BankDto(
                bankCode: '390000',
                bankName: 'Khan Bank',
                accountNumber: '991122334455667788',
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(api.lastUpdateProfileReq, isNull);
      expect(find.text('Account holder not found'), findsOneWidget);
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
      SecAcntBankOption('390000', 'Khan Bank', 'Khan', ''),
    ];
  }
}

class _FakeLookupRepository implements SecAcntBankAccountLookupRepository {
  _FakeLookupRepository({
    this.result = const SecAcntBankAccountLookupResult(),
  });

  final SecAcntBankAccountLookupResult result;
  String? _lastBankCode;
  String? _lastAccountNumber;

  String? get lastBankCode => _lastBankCode;
  String? get lastAccountNumber => _lastAccountNumber;

  @override
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) async {
    _lastBankCode = bankCode;
    _lastAccountNumber = accountNumber;
    return result;
  }
}

class _FakeMiniAppApiRepository implements MiniAppApiRepository {
  UpdateProfileApiReq? lastUpdateProfileReq;

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
  Future<CompaniesEntity> getCompanyInfo({bool forceRefresh = false}) {
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
