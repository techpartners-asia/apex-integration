import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/foundation.dart';

/// Coordinates user bootstrap and protected login-session loading.
abstract interface class MiniAppSessionController {
  /// Reactive session store.
  MiniAppSessionStore get store;

  /// Cached current user, if loaded.
  UserEntityDto? get currentUser;

  /// Cached protected login session, if loaded.
  LoginSession? get loginSession;

  /// Current host user token.
  String? get userToken;

  /// Prepares token providers and store state for a launch.
  void prepareLaunch({String? userToken});

  /// Caches a user profile returned by bootstrap/signup APIs.
  void cacheCurrentUser(UserEntityDto user);

  /// Returns a cached current user or loads one.
  Future<UserEntityDto> ensureCurrentUser();

  /// Returns a cached login session or loads one.
  Future<LoginSession> ensureLoginSession();

  /// Clears and reloads the protected login session.
  Future<LoginSession> refreshLoginSession();
}

/// Default session controller with in-flight request de-duplication.
class DefaultMiniAppSessionController implements MiniAppSessionController {
  /// Store that owns the session state.
  final MiniAppSessionStore sessionStore;

  /// Repository used to load the current user.
  final CurrentUserRepository currentUserRepository;

  /// Repository used to load the protected login session.
  final LoginSessionRepository loginSessionRepository;

  /// Token provider for current-user/signup APIs.
  final MutableTokenProvider currentUserTokenProvider;

  /// Token provider for protected APIs.
  final MutableTokenProvider protectedTokenProvider;

  /// Creates the default session controller.
  ///
  /// The controller keeps current-user and login-session requests de-duplicated
  /// so multiple startup widgets can ask for the same session without causing
  /// duplicate backend calls.
  DefaultMiniAppSessionController({
    required MiniAppSessionStore store,
    required this.currentUserRepository,
    required this.loginSessionRepository,
    required this.currentUserTokenProvider,
    required this.protectedTokenProvider,
  }) : sessionStore = store;

  /// In-flight current-user request reused by concurrent callers.
  Future<UserEntityDto>? currentUserInFlight;

  /// In-flight login-session request reused by concurrent callers.
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
    final bool tokenChanged =
        _normalized(userToken) != _normalized(sessionStore.userToken);
    sessionStore.prepareLaunch(
      userToken: userToken,
      resetSession: tokenChanged,
    );
    final String? adminSession = tokenChanged
        ? null
        : _normalizedAdminSession(sessionStore.currentUser);
    currentUserTokenProvider.updateAccessToken(adminSession ?? userToken);
    if (tokenChanged) {
      protectedTokenProvider.updateAccessToken(null);
    }
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

  /// Loads the current user from the backend and updates current-user token.
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

  /// Loads the protected login session and updates protected token provider.
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

  /// Returns the first non-empty admin/current-user token from [user].
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

  /// Returns a trimmed non-empty string or null.
  String? _normalized(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
