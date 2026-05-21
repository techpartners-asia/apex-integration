import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// API wrapper for resolving the Apex login session used by downstream calls.
class LoginSessionBackendApi {
  /// HTTP executor supplied by the SDK runtime.
  final ApiExecutor? executor;

  /// Runtime config containing credentials, base URL, and NE session values.
  final SdkRuntimeConfig runtimeConfig;

  /// Creates the API wrapper.
  const LoginSessionBackendApi({
    required this.executor,
    required this.runtimeConfig,
  });

  /// Calls the login-session endpoint and returns the raw JSON envelope.
  Future<Map<String, Object?>> getLoginSessionRaw(GetLoginSessionApiReq req) async {
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

  /// Calls the login-session endpoint and parses it into a DTO.
  Future<LoginSessionResponseDto> getLoginSession(GetLoginSessionApiReq req) async {
    final Map<String, Object?> json = await getLoginSessionRaw(req);
    return LoginSessionResponseDto.fromJson(json);
  }
}
