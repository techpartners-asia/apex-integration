import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/app/investx_api/backend/mini_app_api_repository.dart';
import 'package:mini_app_sdk/src/app/investx_api/dto/user_entity_dto.dart';
import 'package:mini_app_sdk/src/app/investx_api/models/mini_app_payment.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/create_feedback_api_req.dart';
import 'package:mini_app_sdk/src/features/ips/feedback/domain/feedback_entity.dart';
import 'package:mini_app_sdk/src/features/ips/feedback/domain/feedback_list_response.dart';
import 'package:mini_app_sdk/src/features/ips/help/domain/company_info_entities.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/create_invoice_api_req.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/update_profile_api_req.dart';
import 'package:mini_app_sdk/src/app/investx_api/req/update_target_goal_api_req.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/application/sec_acnt_bank_account_lookup_repository.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/application/sec_acnt_bank_options_repository.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/presentation/screens/sec_acnt_personal_info_screen.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/presentation/screens/sec_acnt_success_screen.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/presentation/flow/sec_acnt_flow.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/dto/get_sec_acnt_list_res_dto.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/acnt_bootstrap_state.dart';

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
  Future<CompaniesEntity> getCompanyInfo({bool forceRefresh = false}) {
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
    response: GetSecuritiesAccountListResDto(
      detail: const GetSecAcntListDetailDto(hasAcnt: true, hasIpsAcnt: false),
      acnts: const <GetSecAcntListAccountDto>[
        GetSecAcntListAccountDto(flag: 3, status: 1),
      ],
      stlAcnts: const <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
