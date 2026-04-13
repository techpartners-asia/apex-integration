import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/core/api/api_action_result_parser.dart';
import 'package:mini_app_sdk/src/core/exception/api_exception.dart';

void main() {
  group('ApiActionResultParser.ensureSuccess (strictResponseCode: true)', () {
    void ensureStrict(Map<String, Object?> json, {String fallback = 'fail'}) {
      ApiActionResultParser.ensureSuccess(
        json,
        fallbackErrorMessage: fallback,
        strictResponseCode: true,
      );
    }

    test('does not throw for responseCode 0', () {
      expect(
        () => ensureStrict(
          const <String, Object?>{'responseCode': 0, 'responseDesc': 'OK'},
        ),
        returnsNormally,
      );
    });

    test('throws ApiBusinessException for non-zero responseCode', () {
      expect(
        () => ensureStrict(
          const <String, Object?>{
            'responseCode': 42,
            'responseDesc': 'Validation error',
          },
        ),
        throwsA(
          isA<ApiBusinessException>()
              .having((e) => e.responseCode, 'responseCode', 42)
              .having((e) => e.message, 'message', 'Validation error'),
        ),
      );
    });

    test('uses fallbackErrorMessage when responseDesc is null', () {
      expect(
        () => ensureStrict(
          const <String, Object?>{'responseCode': 1},
          fallback: 'Custom fallback',
        ),
        throwsA(
          isA<ApiBusinessException>()
              .having((e) => e.message, 'message', 'Custom fallback'),
        ),
      );
    });

    test('treats missing responseCode as 1 (failure)', () {
      expect(
        () => ensureStrict(
          const <String, Object?>{'responseDesc': 'Something went wrong'},
        ),
        throwsA(isA<ApiBusinessException>()),
      );
    });

    test('treats null responseCode as 1 (failure)', () {
      expect(
        () => ensureStrict(const <String, Object?>{'responseCode': null}),
        throwsA(isA<ApiBusinessException>()),
      );
    });
  });

  group('ApiActionResultParser.ensureSuccess (default mode)', () {
    void ensureDefault(Map<String, Object?> json) {
      ApiActionResultParser.ensureSuccess(
        json,
        fallbackErrorMessage: 'Request failed.',
      );
    }

    test('does not throw when responseCode is absent', () {
      expect(
        () => ensureDefault(const <String, Object?>{'data': 'ok'}),
        returnsNormally,
      );
    });

    test('throws for explicit success: false', () {
      expect(
        () => ensureDefault(const <String, Object?>{'success': false}),
        throwsA(isA<ApiBusinessException>()),
      );
    });

    test('does not throw for success: true', () {
      expect(
        () => ensureDefault(const <String, Object?>{'success': true}),
        returnsNormally,
      );
    });

    test('throws for non-zero responseCode', () {
      expect(
        () => ensureDefault(const <String, Object?>{'responseCode': 5}),
        throwsA(
          isA<ApiBusinessException>()
              .having((e) => e.responseCode, 'responseCode', 5),
        ),
      );
    });

    test('prefers message field over fallback', () {
      expect(
        () => ensureDefault(
          const <String, Object?>{'responseCode': 1, 'message': 'Server err'},
        ),
        throwsA(
          isA<ApiBusinessException>()
              .having((e) => e.message, 'message', 'Server err'),
        ),
      );
    });
  });

  group('ApiActionResultParser helpers', () {
    test('messageOf prefers responseDesc over message', () {
      expect(
        ApiActionResultParser.messageOf(
          const <String, Object?>{
            'responseDesc': 'desc',
            'message': 'msg',
          },
        ),
        'desc',
      );
    });

    test('messageOf falls back to message', () {
      expect(
        ApiActionResultParser.messageOf(
          const <String, Object?>{'message': 'msg'},
        ),
        'msg',
      );
    });

    test('bodyOf returns body map', () {
      final Map<String, Object?> result = ApiActionResultParser.bodyOf(
        const <String, Object?>{
          'body': <String, Object?>{'id': 1},
        },
      );
      expect(result['id'], 1);
    });

    test('bodyOf returns empty map when body is absent', () {
      expect(
        ApiActionResultParser.bodyOf(const <String, Object?>{}),
        isEmpty,
      );
    });
  });
}
