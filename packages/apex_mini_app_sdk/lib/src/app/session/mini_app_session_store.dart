import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that stores the current host token, current user, and login session.
class MiniAppSessionStore extends Cubit<MiniAppSessionState> {
  /// Creates the reactive session store with optional host-provided state.
  MiniAppSessionStore({
    String? initialUserToken,
    UserEntityDto? initialCurrentUser,
    LoginSession? initialLoginSession,
  }) : super(
         MiniAppSessionState(
           userToken: initialUserToken,
           currentUser: initialCurrentUser,
           loginSession: initialLoginSession,
         ),
       );

  /// Current host token.
  String? get userToken => state.userToken;

  /// Current Apex user profile.
  UserEntityDto? get currentUser => state.currentUser;

  /// Current login session used by protected APIs.
  LoginSession? get loginSession => state.loginSession;

  /// Prepares session state for a new launch.
  void prepareLaunch({String? userToken, bool resetSession = true}) {
    if (resetSession) {
      emit(MiniAppSessionState(userToken: userToken));
      return;
    }

    emit(state.copyWith(userToken: userToken));
  }

  /// Stores the loaded current user.
  void setCurrentUser(UserEntityDto user) {
    emit(state.copyWith(currentUser: user));
  }

  /// Stores the loaded login session.
  void setLoginSession(LoginSession session) {
    emit(state.copyWith(loginSession: session));
  }

  /// Clears only the protected login session.
  void clearLoginSession() {
    emit(state.copyWith(loginSession: null));
  }
}
