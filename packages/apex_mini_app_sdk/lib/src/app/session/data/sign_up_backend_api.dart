import '../../investx_api/dto/user_entity_dto.dart';
import '../../../core/exception/api_exception.dart';

import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_executor.dart';
import '../../../core/api/req_context.dart';
import '../req/sign_up_api_req.dart';

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
