import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Immutable session state held by [MiniAppSessionStore].
class MiniAppSessionState {
  /// Sentinel that lets [copyWith] distinguish omitted values from `null`.
  static const Object _sentinel = Object();

  /// Host token for the active launch.
  final String? userToken;

  /// Current Apex user profile.
  final UserEntityDto? currentUser;

  /// Protected login session.
  final LoginSession? loginSession;

  /// Creates immutable session state for the current launch.
  const MiniAppSessionState({
    this.userToken,
    this.currentUser,
    this.loginSession,
  });

  /// Whether [currentUser] is loaded.
  bool get hasCurrentUser => currentUser != null;

  /// Whether [loginSession] is loaded.
  bool get hasLoginSession => loginSession != null;

  /// Copies state while allowing explicit null assignment.
  MiniAppSessionState copyWith({
    Object? userToken = _sentinel,
    Object? currentUser = _sentinel,
    Object? loginSession = _sentinel,
  }) {
    return MiniAppSessionState(
      userToken: userToken == _sentinel ? this.userToken : userToken as String?,
      currentUser: currentUser == _sentinel
          ? this.currentUser
          : currentUser as UserEntityDto?,
      loginSession: loginSession == _sentinel
          ? this.loginSession
          : loginSession as LoginSession?,
    );
  }
}
