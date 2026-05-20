import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Repository for selectable securities-account bank options.
abstract interface class SecAcntBankOptionsRepository {
  /// Loads bank options for the onboarding picker.
  Future<List<SecAcntBankOption>> getBankOptions({bool forceRefresh = false});
}

/// API-backed bank-options repository using FI/BOM institution data.
class ApiSecAcntBankOptionsRepository implements SecAcntBankOptionsRepository {
  /// FI/BOM institution repository.
  final FiBomInstRepository fiBomInstRepository;

  /// Creates an API-backed bank-options repository.
  const ApiSecAcntBankOptionsRepository({required this.fiBomInstRepository});

  @override
  Future<List<SecAcntBankOption>> getBankOptions({
    bool forceRefresh = false,
  }) async {
    final fiBomInsts = await fiBomInstRepository.getFiBomInstList(
      forceRefresh: forceRefresh,
    );

    return List<SecAcntBankOption>.unmodifiable(
      fiBomInsts.map(mapSecAcntBankOptionFromFiBomInst),
    );
  }
}

/// Failing implementation used when bank options are not configured.
class UnavailableSecAcntBankOptionsRepository
    implements SecAcntBankOptionsRepository {
  /// Creates a bank-options repository that reports missing configuration.
  const UnavailableSecAcntBankOptionsRepository();

  @override
  Future<List<SecAcntBankOption>> getBankOptions({bool forceRefresh = false}) {
    throw const ApiIntegrationException(
      'Securities account bank options are not configured inside the SDK.',
    );
  }
}
