import '../investx_api/backend/mini_app_api_backend.dart';
import '../investx_api/backend/mini_app_api_repository.dart';
import '../../core/token/token_provider.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../core/api/api_executor.dart';
import '../../core/backend/sdk_backend_config.dart';
import 'mini_app_session_controller.dart';
import 'mini_app_session_store.dart';
import 'data/current_user_repository.dart';
import 'data/login_session_backend_api.dart';
import 'data/login_session_repository.dart';
import 'data/sign_up_backend_api.dart';
import 'models/login_session.dart';

class MiniAppSessionRuntime {
  final SdkBackendConfig backendConfig;
  final MiniAppSessionStore store;
  final MiniAppSessionController controller;
  final ApiExecutor? protectedExecutor;
  final MiniAppApiRepository appApi;

  const MiniAppSessionRuntime({
    required this.backendConfig,
    required this.store,
    required this.controller,
    required this.protectedExecutor,
    required this.appApi,
  });
}

MiniAppSessionRuntime buildMiniAppSessionRuntime({
  String? initialUserToken,
  MiniAppLogger logger = const DebugMiniAppLogger(),
}) {
  final SdkBackendConfig backendConfig = SdkBackendConfig.fromConfig();
  final MiniAppSessionStore store = MiniAppSessionStore(
    initialUserToken: initialUserToken,
  );
  final MutableTokenProvider currentUserTokenProvider = MutableTokenProvider(
    initialUserToken,
  );
  final MutableTokenProvider protectedTokenProvider = MutableTokenProvider(
    backendConfig.runtime.accessToken,
  );
  final signUpRuntime = backendConfig.runtime.createCurrentUserRuntime(
    tokenProvider: currentUserTokenProvider,
  );
  final currentUserProtectedRuntime = backendConfig.runtime.createTechInvestXProtectedRuntime(tokenProvider: currentUserTokenProvider);
  final sessionRuntime = backendConfig.runtime.createSessionRuntime();

  late final MiniAppSessionController controller;
  final MiniAppApiBackend miniAppApiBackend = MiniAppApiBackend(
    publicExecutor: signUpRuntime?.executor,
    authorizedExecutor: currentUserProtectedRuntime?.executor,
  );

  final protectedRuntime = backendConfig.runtime.createProtectedRuntime(
    tokenProvider: protectedTokenProvider,
    onRefreshSession: () async {
      final LoginSession refreshed = await controller.refreshLoginSession();
      return refreshed.accessToken;
    },
  );

  controller = DefaultMiniAppSessionController(
    store: store,
    currentUserRepository: RemoteSignupBootstrapRepository(
      api: SignUpBackendApi(executor: signUpRuntime?.executor),
      profileApi: miniAppApiBackend,
      adminTokenProvider: currentUserTokenProvider,
      logger: logger,
    ),
    loginSessionRepository: RemoteLoginSessionRepository(
      api: LoginSessionBackendApi(
        executor: sessionRuntime?.executor,
        runtimeConfig: backendConfig.runtime,
      ),
      runtimeConfig: backendConfig.runtime,
    ),
    currentUserTokenProvider: currentUserTokenProvider,
    protectedTokenProvider: protectedTokenProvider,
  );

  final MiniAppApiRepository appApi = RemoteMiniAppApiRepository(
    api: miniAppApiBackend,
    session: controller,
    logger: logger,
  );

  return MiniAppSessionRuntime(
    backendConfig: backendConfig,
    store: store,
    controller: controller,
    protectedExecutor: protectedRuntime?.executor,
    appApi: appApi,
  );
}
