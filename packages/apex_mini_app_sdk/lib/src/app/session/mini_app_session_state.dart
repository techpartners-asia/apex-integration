import 'package:mini_app_sdk/mini_app_sdk.dart';

class MiniAppSessionState {
  static const Object _sentinel = Object();

  final String? userToken;
  final UserEntityDto? currentUser;
  final LoginSession? loginSession;

  const MiniAppSessionState({
    this.userToken,
    this.currentUser,
    this.loginSession,
  });

  bool get hasCurrentUser => currentUser != null;

  bool get hasLoginSession => loginSession != null;

  MiniAppSessionState copyWith({
    Object? userToken = _sentinel,
    Object? currentUser = _sentinel,
    Object? loginSession = _sentinel,
  }) {
    return MiniAppSessionState(
      userToken: userToken == _sentinel ? this.userToken : userToken as String?,
      currentUser: currentUser == _sentinel ? this.currentUser : currentUser as UserEntityDto?,
      loginSession: loginSession == _sentinel ? this.loginSession : loginSession as LoginSession?,
    );
  }
}
