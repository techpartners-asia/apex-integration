import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Account-holder lookup result for a bank/account pair.
class SecAcntBankAccountLookupResult {
  /// Backend response code.
  final int? responseCode;

  /// Backend response description.
  final String? responseDesc;

  /// Full account holder name when available.
  final String? accountHolderName;

  /// Masked account holder name when backend returns only masked data.
  final String? maskedAccountHolderName;

  /// Creates an account-holder lookup result.
  const SecAcntBankAccountLookupResult({
    this.responseCode,
    this.responseDesc,
    this.accountHolderName,
    this.maskedAccountHolderName,
  });

  /// Whether backend reported success.
  bool get isSuccess => responseCode == 0;
}

/// Repository for resolving account holder name from bank/account details.
abstract interface class SecAcntBankAccountLookupRepository {
  /// Looks up account-holder information.
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  });
}

/// Placeholder lookup implementation retained until backend integration exists.
class PlaceholderSecAcntBankAccountLookupRepository
    implements SecAcntBankAccountLookupRepository {
  /// Creates the placeholder account lookup repository.
  const PlaceholderSecAcntBankAccountLookupRepository();

  @override
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) async {
    // TODO(o.battogtokh): Replace placeholder with getAcntListCam integration
    // when backend is ready.
    return const SecAcntBankAccountLookupResult();
  }
}

/// API-backed account-holder lookup repository.
class ApiSecAcntBankAccountLookupRepository
    implements SecAcntBankAccountLookupRepository {
  /// Creates an API-backed account lookup repository.
  const ApiSecAcntBankAccountLookupRepository({required this.api});

  /// IPS backend API client.
  final IpsBackendApi api;

  @override
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) async {
    final String normalizedBankCode = bankCode.trim();
    final String normalizedAccountNumber = accountNumber.trim();
    if (normalizedBankCode.isEmpty || normalizedAccountNumber.isEmpty) {
      return const SecAcntBankAccountLookupResult();
    }

    final AcntNameLookupDto response = await api.checkAcntNameByAcntCode(
      CheckAcntNameByAcntCodeApiReq(
        srcAcntId: 0,
        dstFiCode: normalizedBankCode,
        dstAcntCode: normalizedAccountNumber,
      ),
    );

    return SecAcntBankAccountLookupResult(
      responseCode: response.responseCode,
      responseDesc: response.responseDesc,
      accountHolderName: response.acntName,
      maskedAccountHolderName: response.maskedAcntName,
    );
  }
}

/// Failing implementation used when account lookup is not configured.
class UnavailableSecAcntBankAccountLookupRepository
    implements SecAcntBankAccountLookupRepository {
  /// Creates an account lookup repository that reports missing configuration.
  const UnavailableSecAcntBankAccountLookupRepository();

  @override
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) {
    throw const ApiIntegrationException(
      'Securities account holder lookup is not configured inside the SDK.',
    );
  }
}
