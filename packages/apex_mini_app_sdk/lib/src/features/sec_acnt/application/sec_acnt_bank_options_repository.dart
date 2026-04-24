import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntBankOptionsRepository {
  const SecAcntBankOptionsRepository();

  Future<List<SecAcntBankOption>> getBankOptions({bool forceRefresh = false}) {
    throw UnimplementedError();
  }
}

class ApiSecAcntBankOptionsRepository implements SecAcntBankOptionsRepository {
  final FiBomInstRepository fiBomInstRepository;

  const ApiSecAcntBankOptionsRepository({required this.fiBomInstRepository});

  @override
  Future<List<SecAcntBankOption>> getBankOptions({bool forceRefresh = false}) async {
    final fiBomInsts = await fiBomInstRepository.getFiBomInstList(forceRefresh: forceRefresh);

    return List<SecAcntBankOption>.unmodifiable(
      fiBomInsts.map(mapSecAcntBankOptionFromFiBomInst),
    );
  }
}

class UnavailableSecAcntBankOptionsRepository implements SecAcntBankOptionsRepository {
  const UnavailableSecAcntBankOptionsRepository();

  @override
  Future<List<SecAcntBankOption>> getBankOptions({bool forceRefresh = false}) {
    throw const ApiIntegrationException(
      'Securities account bank options are not configured inside the SDK.',
    );
  }
}
