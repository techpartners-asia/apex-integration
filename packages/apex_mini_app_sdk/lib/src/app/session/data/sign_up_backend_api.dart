import 'package:mini_app_sdk/mini_app_sdk.dart';

class SignUpBackendApi {
  final ApiExecutor? executor;

  const SignUpBackendApi({required this.executor});

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

    return UserEntityDto.fromJson(json);
  }
}
