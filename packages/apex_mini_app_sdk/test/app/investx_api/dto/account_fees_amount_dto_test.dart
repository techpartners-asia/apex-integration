import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountFeesAmountDto', () {
    test('parses amount from wrapped body payload', () {
      final AccountFeesAmountDto dto = AccountFeesAmountDto.fromJson(
        <String, Object?>{
          'message': 'ok',
          'body': <String, Object?>{
            'amount': 1500,
            'id': 7,
            'created_at': '2026-05-29T10:00:00Z',
            'updated_at': '2026-05-29T10:00:00Z',
          },
        },
      );

      expect(dto.amount, 1500);
      expect(dto.id, 7);
      expect(dto.createdAt, isNotNull);
      expect(dto.updatedAt, isNotNull);
    });
  });
}
