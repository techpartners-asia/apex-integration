import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test(
    'cached FI repository reuses loaded list until refresh is requested',
    () async {
      int calls = 0;
      final repository = CachedFiBomInstRepository(
        fiBomInst: '181',
        loadFiBomInst: (req) async {
          calls += 1;
          expect(req.fiBomInst, '181');
          expect(req.dicVersion, 0);
          return const <FiBomInstDto>[
            FiBomInstDto(fiCode: '181001', name: 'InvestX'),
            FiBomInstDto(fiCode: '181002', name: 'Partner FI'),
          ];
        },
      );

      final first = await repository.getFiBomInstList();
      final second = await repository.getFiBomInstList();
      final refreshed = await repository.getFiBomInstList(forceRefresh: true);
      final defaultFi = await repository.getDefaultFiBomInst();

      expect(calls, 2);
      expect(identical(first, second), isTrue);
      expect(refreshed, hasLength(2));
      expect(refreshed.first.fiCode, '181001');
      expect(defaultFi.fiCode, '181001');
    },
  );
}
