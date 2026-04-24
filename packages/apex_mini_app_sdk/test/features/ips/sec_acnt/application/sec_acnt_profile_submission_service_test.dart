import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test(
    'buildRequest prefers looked up account holder over cached profile data',
    () async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();
      final SecAcntProfileSubmissionService service =
          SecAcntProfileSubmissionService(
            appApi: api,
            bankAccountLookupRepository: const _FakeLookupRepository(
              accountHolderName: 'Resolved Account Holder',
            ),
            currentUser: UserEntityDto(
              phone: '99112233',
              phoneAddition: '88112233',
              email: 'fallback@example.com',
              bank: const BankDto(accountName: 'Fallback Name'),
            ),
          );

      final UpdateProfileApiReq request = await service.buildRequest(
        UpdateProfileActionType.updateProfile,
        const SecAcntPersonalInfoData(
          mobile: '77112233',
          secondaryMobile: '66112233',
          email: 'hello@example.com',
          iban: 'MN9900112233',
          bankCode: 'FI001',
          bankLabel: 'Test Bank',
        ),
      );

      expect(request.phone, '77112233');
      expect(request.phoneAddition, '66112233');
      expect(request.email, 'hello@example.com');
      expect(request.bank?.bankCode, 'FI001');
      expect(request.bank?.bankName, 'Test Bank');
      expect(request.bank?.accountNumber, 'MN9900112233');
      expect(request.bank?.accountName, 'Resolved Account Holder');
    },
  );

  test(
    'submit falls back to cached profile values when optional inputs are blank',
    () async {
      final _FakeMiniAppApiRepository api = _FakeMiniAppApiRepository();
      final SecAcntProfileSubmissionService service =
          SecAcntProfileSubmissionService(
            appApi: api,
            bankAccountLookupRepository: const _FakeLookupRepository(),
            currentUser: UserEntityDto(
              phone: '99112233',
              phoneAddition: '88112233',
              email: 'fallback@example.com',
              bank: const BankDto(accountName: 'Fallback Name'),
            ),
          );

      await service.submit(
        UpdateProfileActionType.updateProfile,
        const SecAcntPersonalInfoData(
          iban: '12345678',
          bankCode: 'FI002',
          bankLabel: 'Fallback Bank',
        ),
      );

      expect(api.lastUpdateProfileReq, isNotNull);
      expect(api.lastUpdateProfileReq!.phone, '99112233');
      expect(api.lastUpdateProfileReq!.phoneAddition, '88112233');
      expect(api.lastUpdateProfileReq!.email, 'fallback@example.com');
      expect(api.lastUpdateProfileReq!.bank?.accountName, 'Fallback Name');
    },
  );
}

class _FakeLookupRepository implements SecAcntBankAccountLookupRepository {
  const _FakeLookupRepository({this.accountHolderName});

  final String? accountHolderName;

  @override
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) async {
    return SecAcntBankAccountLookupResult(
      responseCode: accountHolderName == null ? 1 : 0,
      accountHolderName: accountHolderName,
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
