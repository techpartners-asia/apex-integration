import '../../investx_api/dto/user_entity_dto.dart';
import '../../../core/backend/sdk_runtime_config.dart';
import '../models/login_session.dart';
import '../req/get_login_session_api_req_factory.dart';
import 'login_session_backend_api.dart';
import '../dto/login_session_response_dto.dart';

class LoginSessionRepository {
  const LoginSessionRepository();

  Future<LoginSession> getLoginSession(UserEntityDto user) {
    throw UnimplementedError();
  }
}

class RemoteLoginSessionRepository implements LoginSessionRepository {
  final LoginSessionBackendApi api;
  final SdkRuntimeConfig runtimeConfig;

  const RemoteLoginSessionRepository({
    required this.api,
    required this.runtimeConfig,
  });

  @override
  Future<LoginSession> getLoginSession(UserEntityDto user) async {
    final LoginSessionResponseDto response = await api.getLoginSession(
      GetLoginSessionApiReqFactory.temporary(
        admSession: runtimeConfig.neSession!,
      ),
    );

    return response.toDomain();
  }
}
