import '../../../../core/exception/api_exception.dart';
import '../../shared/data/api/ips_backend_api.dart';
import '../../shared/data/dto/acnt_name_lookup_dto.dart';
import '../../shared/data/req/get_acnt_name_by_acnt_code_api_req.dart';

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

class SecAcntBankAccountLookupRepository {
  const SecAcntBankAccountLookupRepository();

  Future<SecAcntBankAccountLookupResult> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) {
    throw UnimplementedError();
  }
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
