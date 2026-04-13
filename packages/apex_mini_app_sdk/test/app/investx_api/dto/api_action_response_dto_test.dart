import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/app/investx_api/dto/api_action_response_dto.dart';
import 'package:mini_app_sdk/src/core/exception/api_exception.dart';

void main() {
  group('ApiActionResponseDto.fromJson', () {
    test('treats 200-style message/body payloads as success', () {
      final ApiActionResponseDto dto = ApiActionResponseDto.fromJson(
        <String, Object?>{
          'message': '',
          'body': <String, Object?>{
            'id': 1,
            'email': 'test@example.com',
          },
        },
      );

      expect(dto.message, isNull);
      expect(dto.body['id'], 1);
      expect(dto.body['email'], 'test@example.com');
    });

    test('preserves optional informational success messages', () {
      final ApiActionResponseDto dto = ApiActionResponseDto.fromJson(
        <String, Object?>{
          'message': 'Signature received.',
          'body': <String, Object?>{'id': 1},
        },
      );

      expect(dto.message, 'Signature received.');
    });

    test('throws only for explicit business failures', () {
      expect(
        () => ApiActionResponseDto.fromJson(
          <String, Object?>{
            'responseCode': 4001,
            'responseDesc': 'Invalid profile data.',
          },
          failureMessage: 'Request failed.',
        ),
        throwsA(
          isA<ApiBusinessException>().having(
            (ApiBusinessException error) => error.message,
            'message',
            'Invalid profile data.',
          ),
        ),
      );
    });
  });
}
