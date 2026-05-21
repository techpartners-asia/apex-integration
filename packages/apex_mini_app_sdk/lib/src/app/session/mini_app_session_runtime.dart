import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Session/API runtime bundle created during SDK dependency wiring.
class MiniAppSessionRuntime {
  /// Resolved backend configuration.
  final SdkBackendConfig backendConfig;

  /// Reactive session state.
  final MiniAppSessionStore store;

  /// Session loader/refresher.
  final MiniAppSessionController controller;

  /// Protected API executor, null when protected APIs cannot be configured.
  final ApiExecutor? protectedExecutor;

  /// General mini-app repository backed by Apex APIs.
  final MiniAppApiRepository appApi;

  /// Creates the assembled session/API runtime bundle.
  const MiniAppSessionRuntime({
    required this.backendConfig,
    required this.store,
    required this.controller,
    required this.protectedExecutor,
    required this.appApi,
  });
}

/// Builds session stores, token providers, API runtimes, and repositories.
MiniAppSessionRuntime buildMiniAppSessionRuntime({
  String? initialUserToken,
  MiniAppLogger logger = const DebugMiniAppLogger(),
  MiniAppUserDataSourceMode userDataSourceMode =
      MiniAppUserDataSourceMode.realUser,
  bool devMode = false,
  String? baseUrl,
  String? techInvestXBaseUrl,
  String? loginSessionBaseUrl,
  String? ipsApiBaseUrl,
  String? appId,
  String? appSecret,
  String? accessToken,
  String? neSession,
  String? defaultSrcFiCode,
  String? defaultFiCode,
  String? language,
  bool? enableDebugLogs,
  ApexMiniAppHostUser? hostUser,
  ApexMiniAppHostSession? hostSession,
}) {
  StaticApiConfig.configure(devMode: devMode);
  final UserEntityDto? initialCurrentUser = _hostUserToDto(hostUser);
  final LoginSession? initialLoginSession = _hostSessionToLoginSession(
    hostSession,
  );
  final SdkBackendConfig backendConfig = SdkBackendConfig.fromConfig(
    runtime: SdkRuntimeConfig.fromConfig(
      baseUrl: baseUrl,
      techInvestXUrl: techInvestXBaseUrl,
      loginSessionBaseUrl: loginSessionBaseUrl,
      ipsApiBaseUrl: ipsApiBaseUrl,
      appId: appId,
      appSecret: appSecret,
      accessToken: initialLoginSession?.accessToken ?? accessToken,
      neSession: hostSession?.neSession ?? neSession,
      defaultSrcFiCode: defaultSrcFiCode,
      defaultFiCode: defaultFiCode,
      language: language,
      enableDebugLogs: enableDebugLogs,
      devMode: devMode,
    ),
  );
  final MiniAppSessionStore store = MiniAppSessionStore(
    initialUserToken: initialUserToken,
    initialCurrentUser: initialCurrentUser,
    initialLoginSession: initialLoginSession,
  );
  final MutableTokenProvider currentUserTokenProvider = MutableTokenProvider(
    initialCurrentUser?.admSession ?? initialUserToken,
  );
  final MutableTokenProvider protectedTokenProvider = MutableTokenProvider(
    initialLoginSession?.accessToken ?? backendConfig.runtime.accessToken,
  );
  final signUpRuntime = backendConfig.runtime.createCurrentUserRuntime(
    tokenProvider: currentUserTokenProvider,
  );
  final currentUserProtectedRuntime = backendConfig.runtime
      .createTechInvestXProtectedRuntime(
        tokenProvider: currentUserTokenProvider,
      );
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
      userDataSourceMode: userDataSourceMode,
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

/// Converts optional host user data into the internal user DTO.
UserEntityDto? _hostUserToDto(ApexMiniAppHostUser? user) {
  if (user == null) {
    return null;
  }

  return UserEntityDto(
    id: user.id,
    registerNo: user.registerNo,
    firstName: user.firstName,
    lastName: user.lastName,
    phone: user.phone,
    email: user.email,
    gender: user.gender,
    token: user.adminSession ?? user.accessToken,
    accessToken: user.accessToken,
    admSession: user.adminSession ?? user.accessToken,
    bank: _hostBankToDto(user.bank),
  );
}

/// Converts optional host bank data into the internal bank DTO.
BankDto? _hostBankToDto(ApexMiniAppHostBank? bank) {
  if (bank == null) {
    return null;
  }

  return BankDto(
    accountNumber: bank.accountNumber,
    accountName: bank.accountName,
    bankId: bank.bankId,
    bankCode: bank.bankCode,
    bankName: bank.bankName,
  );
}

/// Converts optional host session data into the internal login session model.
LoginSession? _hostSessionToLoginSession(ApexMiniAppHostSession? session) {
  final String accessToken = session?.accessToken?.trim() ?? '';
  if (accessToken.isEmpty) {
    return null;
  }

  return LoginSession(
    accessToken: accessToken,
    customerToken: session?.customerToken,
  );
}
