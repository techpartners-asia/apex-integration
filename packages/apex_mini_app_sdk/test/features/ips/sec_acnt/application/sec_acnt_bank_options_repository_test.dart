import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/ips/sec_acnt/application/sec_acnt_bank_options_repository.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/dto/fi_bom_inst_dto.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/services/fi_bom_inst_repository.dart';

class _FakeFiBomInstRepository implements FiBomInstRepository {
  int calls = 0;

  @override
  Future<FiBomInstDto> getDefaultFiBomInst({bool forceRefresh = false}) async {
    return (await getFiBomInstList(forceRefresh: forceRefresh)).first;
  }

  @override
  Future<List<FiBomInstDto>> getFiBomInstList({
    bool forceRefresh = false,
  }) async {
    calls += 1;
    return const <FiBomInstDto>[
      FiBomInstDto(
        fiCode: 'khan',
        name: 'Khan Bank',
        logo: 'https://example.com/logo.png',
        headerColor: '#3B8E3C',
      ),
      FiBomInstDto(
        fiCode: 'tdb',
        name: 'Trade and Development Bank',
        logo: 'https://example.com/tdb.png',
      ),
    ];
  }
}

void main() {
  test(
    'bank options repository maps cached FI list into sec-acnt bank options',
    () async {
      final fakeRepository = _FakeFiBomInstRepository();
      final repository = ApiSecAcntBankOptionsRepository(
        fiBomInstRepository: fakeRepository,
      );

      final options = await repository.getBankOptions();

      expect(fakeRepository.calls, 1);
      expect(options, hasLength(2));
      expect(options.first.id, 'khan');
      expect(options.first.label, 'Khan Bank');
      expect(options.first.shortLabel, 'KB');
      expect(options.first.logoUrl, 'https://example.com/logo.png');
      expect(options.last.id, 'tdb');
    },
  );
}
