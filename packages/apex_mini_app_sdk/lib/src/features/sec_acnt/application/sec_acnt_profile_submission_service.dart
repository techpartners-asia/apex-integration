import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Builds and submits profile/bank data during securities-account onboarding.
class SecAcntProfileSubmissionService {
  /// Creates a securities-account profile submission service.
  const SecAcntProfileSubmissionService({
    required this.appApi,
    required this.bankAccountLookupRepository,
    required this.currentUser,
  });

  /// Profile repository used to update backend profile.
  final MiniAppProfileRepository appApi;

  /// Repository used to resolve account holder name from bank/account number.
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

  /// Current user used as fallback for unchanged fields.
  final UserEntityDto? currentUser;

  /// Builds and submits the profile update request.
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

  /// Builds the update request without submitting it.
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
      final SecAcntBankAccountLookupResult lookupResult =
          await bankAccountLookupRepository.lookupAccountHolder(
            bankCode: bankCode,
            accountNumber: accountNumber,
          );
      final String? accountHolderName = lookupResult.accountHolderName;
      final String resolvedName = _trimToEmpty(accountHolderName);
      if (resolvedName.isNotEmpty) {
        return resolvedName;
      }
    }

    final String enteredAccountName = _trimToEmpty(personalInfo.acntName);
    if (enteredAccountName.isNotEmpty) {
      return enteredAccountName;
    }

    return _trimToEmpty(currentUser?.bank?.accountName);
  }

  String _resolveProfilePhone(SecAcntPersonalInfoData personalInfo) {
    final String draftValue = _trimToEmpty(personalInfo.mobile);
    return draftValue.isNotEmpty
        ? draftValue
        : _trimToEmpty(currentUser?.phone);
  }

  String _resolveProfilePhoneAddition(SecAcntPersonalInfoData personalInfo) {
    final String draftValue = _trimToEmpty(personalInfo.secondaryMobile);
    return draftValue.isNotEmpty
        ? draftValue
        : _trimToEmpty(currentUser?.phoneAddition);
  }

  String _resolveProfileEmail(SecAcntPersonalInfoData personalInfo) {
    final String draftValue = _trimToEmpty(personalInfo.email);
    return draftValue.isNotEmpty
        ? draftValue
        : _trimToEmpty(currentUser?.email);
  }

  String _trimToEmpty(String? value) => value?.trim() ?? '';
}
