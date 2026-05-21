import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Thin API client for the sign-up/bootstrap endpoint.
class SignUpBackendApi {
  /// HTTP executor supplied by the SDK runtime.
  final ApiExecutor? executor;

  /// Creates the API wrapper.
  const SignUpBackendApi({required this.executor});

  /// Calls sign-up with the host token and returns the parsed user payload.
  Future<UserEntityDto> signUp(SignUpApiReq req) async {
    final ApiExecutor? executor = this.executor;
    if (executor == null) {
      throw const ApiIntegrationException(
        'SDK signup bootstrap is not configured.',
      );
    }

    final Map<String, Object?> json = await executor.postJson(
      ApiEndpoints.signUp,
      body: req.toJson(),
      context: const ReqContext(operName: 'signUp'),
    );

    return UserEntityDto.fromJson(json, failureMessage: 'Sign up failed.');
  }
}
