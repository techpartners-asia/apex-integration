import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

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
