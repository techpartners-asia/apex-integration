import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/core/api/api_client.dart';
import 'package:mini_app_sdk/src/core/api/api_config.dart';
import 'package:mini_app_sdk/src/core/api/api_executor.dart';
import 'package:mini_app_sdk/src/core/api/api_headers_builder.dart';
import 'package:mini_app_sdk/src/core/api/app_credentials.dart';
import 'package:mini_app_sdk/src/core/api/req_context.dart';
import 'package:mini_app_sdk/src/core/exception/api_exception.dart';
import 'package:mini_app_sdk/src/core/token/static_token_provider.dart';

void main() {
  group('ApiExecutor.mapDioException', () {
    test('returns backend validation message from a bad response payload', () {
      final ApiExecutor executor = _buildExecutor();
      final RequestOptions requestOptions = RequestOptions(
        path: '/api/v1/user/profile/update',
        method: 'PUT',
      );
      final DioException error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 400,
          data: <String, Object?>{
            'message': 'Дансны нэр хоосон байна.',
            'body': null,
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final ApiException mapped = executor.mapDioException(
        requestOptions.path,
        const ReqContext(operName: 'updateProfile'),
        error,
        StackTrace.current,
      );

      expect(mapped, isA<ApiBusinessException>());
      expect(mapped.message, 'Дансны нэр хоосон байна.');
    });

    test('extracts nested backend message from body payloads', () {
      final ApiExecutor executor = _buildExecutor();
      final RequestOptions requestOptions = RequestOptions(
        path: '/api/v1/user/profile/update',
        method: 'PUT',
      );
      final DioException error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 400,
          data: <String, Object?>{
            'message': '',
            'body': <String, Object?>{
              'message': 'IBAN дугаар буруу байна.',
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final ApiException mapped = executor.mapDioException(
        requestOptions.path,
        const ReqContext(operName: 'updateProfile'),
        error,
        StackTrace.current,
      );

      expect(mapped, isA<ApiBusinessException>());
      expect(mapped.message, 'IBAN дугаар буруу байна.');
    });
  });
}

ApiExecutor _buildExecutor() {
  const AppCredentials credentials = AppCredentials(
    appId: 'app-id',
    appSecret: 'app-secret',
  );

  return ApiExecutor(
    client: ApiClient(
      config: const ApiConfig(
        baseUrl: 'https://example.com',
        credentials: credentials,
      ),
    ),
    headersBuilder: const ApiHeadersBuilder(
      credentials: credentials,
      tokenProvider: StaticTokenProvider(null),
    ),
  );
}
