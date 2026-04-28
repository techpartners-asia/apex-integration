import 'package:flutter/foundation.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class MiniAppSessionController {
  MiniAppSessionStore get store;

  UserEntityDto? get currentUser;

  LoginSession? get loginSession;

  String? get userToken;

  void prepareLaunch({String? userToken});

  void cacheCurrentUser(UserEntityDto user);

  Future<UserEntityDto> ensureCurrentUser();

  Future<LoginSession> ensureLoginSession();

  Future<LoginSession> refreshLoginSession();
}

class DefaultMiniAppSessionController implements MiniAppSessionController {
  final MiniAppSessionStore sessionStore;
  final CurrentUserRepository currentUserRepository;
  final LoginSessionRepository loginSessionRepository;
  final MutableTokenProvider currentUserTokenProvider;
  final MutableTokenProvider protectedTokenProvider;

  DefaultMiniAppSessionController({
    required MiniAppSessionStore store,
    required this.currentUserRepository,
    required this.loginSessionRepository,
    required this.currentUserTokenProvider,
    required this.protectedTokenProvider,
  }) : sessionStore = store;

  Future<UserEntityDto>? currentUserInFlight;
  Future<LoginSession>? loginSessionInFlight;

  @override
  MiniAppSessionStore get store => sessionStore;

  @override
  UserEntityDto? get currentUser => sessionStore.currentUser;

  @override
  LoginSession? get loginSession => sessionStore.loginSession;

  @override
  String? get userToken => sessionStore.userToken;

  @override
  void prepareLaunch({String? userToken}) {
    sessionStore.prepareLaunch(userToken: userToken);
    currentUserTokenProvider.updateAccessToken(userToken);
    protectedTokenProvider.updateAccessToken(null);
    currentUserInFlight = null;
    loginSessionInFlight = null;
  }

  @override
  void cacheCurrentUser(UserEntityDto user) {
    final String? adminSession =
        _normalizedAdminSession(user) ??
        _normalizedAdminSession(sessionStore.currentUser);
    if (adminSession != null) {
      user.admSession = adminSession;
      currentUserTokenProvider.updateAccessToken(adminSession);
    }
    sessionStore.setCurrentUser(user);
  }

  @override
  Future<UserEntityDto> ensureCurrentUser() {
    final UserEntityDto? currentUser = sessionStore.currentUser;
    final String? adminSession = _normalizedAdminSession(currentUser);
    if (currentUser != null && adminSession != null) {
      currentUser.admSession = adminSession;
      currentUserTokenProvider.updateAccessToken(adminSession);
      return Future<UserEntityDto>.value(currentUser);
    }

    currentUserTokenProvider.updateAccessToken(null);

    final Future<UserEntityDto>? inFlight = currentUserInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final Future<UserEntityDto> next = fetchCurrentUser();
    currentUserInFlight = next;
    return next.whenComplete(() {
      if (identical(currentUserInFlight, next)) {
        currentUserInFlight = null;
      }
    });
  }

  @override
  Future<LoginSession> ensureLoginSession() {
    final LoginSession? currentSession = sessionStore.loginSession;
    if (currentSession != null && protectedTokenProvider.hasToken) {
      return Future<LoginSession>.value(currentSession);
    }

    if (protectedTokenProvider.hasToken) {
      final LoginSession restored = LoginSession(
        accessToken: protectedTokenProvider.currentAccessToken!,
      );
      sessionStore.setLoginSession(restored);
      return Future<LoginSession>.value(restored);
    }

    final Future<LoginSession>? inFlight = loginSessionInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final Future<LoginSession> next = fetchLoginSession();
    loginSessionInFlight = next;
    return next.whenComplete(() {
      if (identical(loginSessionInFlight, next)) {
        loginSessionInFlight = null;
      }
    });
  }

  @override
  Future<LoginSession> refreshLoginSession() {
    sessionStore.clearLoginSession();
    protectedTokenProvider.updateAccessToken(null);
    loginSessionInFlight = null;
    return ensureLoginSession();
  }

  Future<UserEntityDto> fetchCurrentUser() async {
    final UserEntityDto user = await currentUserRepository.getCurrentUser(
      userToken: userToken ?? '',
    );
    final String? adminSession = _normalizedAdminSession(user);
    if (adminSession == null) {
      throw const ApiIntegrationException(
        'signUp bootstrap did not return an admin auth token.',
      );
    }
    user.admSession = adminSession;
    currentUserTokenProvider.updateAccessToken(adminSession);
    sessionStore.setCurrentUser(user);
    return user;
  }

  Future<LoginSession> fetchLoginSession() async {
    final UserEntityDto user = await ensureCurrentUser();
    final LoginSession session = await loginSessionRepository.getLoginSession(
      user,
    );
    protectedTokenProvider.updateAccessToken(session.accessToken);
    sessionStore.setLoginSession(session);
    if (kDebugMode) {
      debugPrint(
        'mini_app_login_session_ready '
        'hasAccessToken=${session.accessToken.trim().isNotEmpty} '
        'tokenLength=${session.accessToken.trim().length} '
        'providerHasToken=${protectedTokenProvider.hasToken}',
      );
    }
    return session;
  }

  String? _normalizedAdminSession(UserEntityDto? user) {
    final String? session = user?.admSession?.trim();
    if (session != null && session.isNotEmpty) {
      return session;
    }

    final String? token = user?.token?.trim();
    if (token != null && token.isNotEmpty) {
      return token;
    }

    return null;
  }
}
