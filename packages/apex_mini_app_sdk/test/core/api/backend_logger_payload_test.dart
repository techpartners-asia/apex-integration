import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BackendLoggerPayload', () {
    test('redacts sensitive headers and fields', () {
      final RequestOptions options = RequestOptions(
        path: '/api/v1.0/getSecuritiesAcntList',
        method: 'POST',
        data: <String, Object?>{
          'password': 'secret',
          'id': 184,
        },
        headers: <String, dynamic>{
          ApiHeaderNames.appSecret: 'top-secret',
          ApiHeaderNames.appId: '114',
        },
      );

      final Map<String, Object?> request = BackendLoggerPayload.sanitizeRequest(
        options,
      );
      final Map<String, dynamic> headers =
          request['headers']! as Map<String, dynamic>;
      final Map<String, Object?> body = request['body']! as Map<String, Object?>;

      expect(headers[ApiHeaderNames.appSecret], '[redacted]');
      expect(headers[ApiHeaderNames.appId], '114');
      expect(body['password'], '[redacted]');
      expect(body['id'], 184);
    });

    test('infoForRoundTrip includes request and response bodies', () {
      final RequestOptions options = RequestOptions(
        path: '/api/v1/user/profile/info',
        method: 'GET',
      );

      final Map<String, Object?> info = BackendLoggerPayload.infoForRoundTrip(
        options: options,
        responseData: <String, Object?>{'ok': true},
        statusCode: 200,
      );

      expect(info['request'], isA<Map<String, Object?>>());
      final Map<String, Object?> response =
          info['response']! as Map<String, Object?>;
      expect(response['statusCode'], 200);
      expect(response['body'], <String, Object?>{'ok': true});
    });
  });
}
