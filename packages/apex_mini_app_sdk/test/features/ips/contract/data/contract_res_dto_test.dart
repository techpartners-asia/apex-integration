import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractResDto.fromJson', () {
    test('accepts HTTP-success payloads without responseCode', () {
      final ContractResDto dto = ContractResDto.fromJson(
        const <String, Object?>{
          'success': true,
          'refNo': 'CONTRACT-1',
          'message': 'Created.',
        },
      );

      expect(dto.contractId, 'CONTRACT-1');
      expect(dto.message, 'Created.');
    });

    test('throws server message for success false', () {
      expect(
        () => ContractResDto.fromJson(
          const <String, Object?>{
            'success': false,
            'message': 'Contract already exists.',
          },
        ),
        throwsA(
          isA<ApiBusinessException>().having(
            (ApiBusinessException error) => error.message,
            'message',
            'Contract already exists.',
          ),
        ),
      );
    });
  });
}
