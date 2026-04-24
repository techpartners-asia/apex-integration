import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/core/exception/api_exception.dart';
import 'package:mini_app_sdk/src/features/shared/data/dto/bootstrap_dto.dart';

void main() {
  group('ActionResDto.fromJson', () {
    test('does not invent a success message when the backend omits one', () {
      final ActionResDto dto = ActionResDto.fromJson(<String, Object?>{
        'message': '',
        'body': <String, Object?>{'ok': true},
      });

      expect(dto.message, isNull);
    });

    test('uses legacy responseDesc failures when responseCode is non-zero', () {
      expect(
        () => ActionResDto.fromJson(
          <String, Object?>{
            'responseCode': 12,
            'responseDesc': 'Pack selection failed.',
          },
          failureMessage: 'Request failed.',
        ),
        throwsA(
          isA<ApiBusinessException>().having(
            (ApiBusinessException error) => error.message,
            'message',
            'Pack selection failed.',
          ),
        ),
      );
    });
  });
}
