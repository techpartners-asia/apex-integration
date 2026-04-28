import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntBankAccountLookupResult {
  final int? responseCode;
  final String? responseDesc;
  final String? accountHolderName;
  final String? maskedAccountHolderName;

  const SecAcntBankAccountLookupResult({
    this.responseCode,
    this.responseDesc,
    this.accountHolderName,
    this.maskedAccountHolderName,
  });

  bool get isSuccess => responseCode == 0;
}

abstract interface class SecAcntBankAccountLookupRepository {
  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  });
}

class PlaceholderSecAcntBankAccountLookupRepository
    implements SecAcntBankAccountLookupRepository {
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

class ApiSecAcntBankAccountLookupRepository
    implements SecAcntBankAccountLookupRepository {
  const ApiSecAcntBankAccountLookupRepository({required this.api});

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

    final AcntNameLookupDto response = await api.getAcntNameByAcntCode(
      GetAcntNameByAcntCodeApiReq(
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

class UnavailableSecAcntBankAccountLookupRepository
    implements SecAcntBankAccountLookupRepository {
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
