import '../req/get_login_session_api_req.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/backend/sdk_runtime_config.dart';
import '../../../core/exception/api_exception.dart';

import '../../../core/api/api_header_names.dart';
import '../../../core/api/api_executor.dart';
import '../../../core/api/req_context.dart';
import '../dto/login_session_response_dto.dart';

class LoginSessionBackendApi {
  final ApiExecutor? executor;
  final SdkRuntimeConfig runtimeConfig;

  const LoginSessionBackendApi({
    required this.executor,
    required this.runtimeConfig,
  });

  Future<Map<String, Object?>> getLoginSessionRaw(
    GetLoginSessionApiReq req,
  ) async {
    final ApiExecutor? executor = this.executor;
    if (executor == null || runtimeConfig.neSession == null) {
      throw const ApiIntegrationException(
        'SDK session bootstrap is not configured.',
      );
    }

    final String baseUrl = runtimeConfig.loginSessionBaseUrl.replaceFirst(
      RegExp(r'/+$'),
      '',
    );
    final String endpoint = '$baseUrl${ApiEndpoints.getLoginSession}';

    return executor.postJson(
      endpoint,
      body: req.toJson(),
      context: ReqContext(
        operName: 'getLoginSession',
        extraHeaders: <String, String>{
          ApiHeaderNames.appId: runtimeConfig.credentials.appId,
          ApiHeaderNames.appSecret: runtimeConfig.credentials.appSecret,
          ApiHeaderNames.neSession: runtimeConfig.neSession!,
        },
      ),
    );
  }

  Future<LoginSessionResponseDto> getLoginSession(
    GetLoginSessionApiReq req,
  ) async {
    final Map<String, Object?> json = await getLoginSessionRaw(req);
    return LoginSessionResponseDto.fromJson(json);
  }
}
