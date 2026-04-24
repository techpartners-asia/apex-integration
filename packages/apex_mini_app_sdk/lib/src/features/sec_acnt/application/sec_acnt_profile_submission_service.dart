import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntProfileSubmissionService {
  const SecAcntProfileSubmissionService({
    required this.appApi,
    required this.bankAccountLookupRepository,
    required this.currentUser,
  });

  final MiniAppApiRepository appApi;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final UserEntityDto? currentUser;

  Future<void> submit(
    String actinType,
    SecAcntPersonalInfoData personalInfo,
  ) async {
    final UpdateProfileApiReq request = await buildRequest(
      actinType,
      personalInfo,
    );
    await appApi.updateProfile(request);
  }

  Future<UpdateProfileApiReq> buildRequest(
    String actionType,
    SecAcntPersonalInfoData personalInfo,
  ) async {
    final String accountName = await _resolveAccountName(personalInfo);
    final String bankName = _trimToEmpty(personalInfo.bankLabel);

    return UpdateProfileApiReq(
      actionType: actionType,
      bank: UpdateProfileBankApiReq(
        accountNumber: _trimToEmpty(personalInfo.iban),
        bankCode: _trimToEmpty(personalInfo.bankCode),
        bankName: bankName,
        accountName: accountName,
      ),
      email: _resolveProfileEmail(personalInfo),
      phone: _resolveProfilePhone(personalInfo),
      phoneAddition: _resolveProfilePhoneAddition(personalInfo),
    );
  }

  Future<String> _resolveAccountName(
    SecAcntPersonalInfoData personalInfo,
  ) async {
    final String bankCode = _trimToEmpty(personalInfo.bankCode);
    final String accountNumber = _trimToEmpty(personalInfo.iban);
    if (bankCode.isNotEmpty && accountNumber.isNotEmpty) {
      final SecAcntBankAccountLookupResult lookupResult = await bankAccountLookupRepository.lookupAccountHolder(
        bankCode: bankCode,
        accountNumber: accountNumber,
      );
      final String? accountHolderName = lookupResult.accountHolderName;
      final String resolvedName = _trimToEmpty(accountHolderName);
      if (resolvedName.isNotEmpty) {
        return resolvedName;
      }
    }

    return _trimToEmpty(currentUser?.bank?.accountName);
  }

  String _resolveProfilePhone(SecAcntPersonalInfoData personalInfo) {
    final String draftValue = _trimToEmpty(personalInfo.mobile);
    return draftValue.isNotEmpty ? draftValue : _trimToEmpty(currentUser?.phone);
  }

  String _resolveProfilePhoneAddition(SecAcntPersonalInfoData personalInfo) {
    final String draftValue = _trimToEmpty(personalInfo.secondaryMobile);
    return draftValue.isNotEmpty ? draftValue : _trimToEmpty(currentUser?.phoneAddition);
  }

  String _resolveProfileEmail(SecAcntPersonalInfoData personalInfo) {
    final String draftValue = _trimToEmpty(personalInfo.email);
    return draftValue.isNotEmpty ? draftValue : _trimToEmpty(currentUser?.email);
  }

  String _trimToEmpty(String? value) => value?.trim() ?? '';
}
