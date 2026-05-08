import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class MiniAppSessionStore extends Cubit<MiniAppSessionState> {
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

  String? get userToken => state.userToken;

  UserEntityDto? get currentUser => state.currentUser;

  LoginSession? get loginSession => state.loginSession;

  void prepareLaunch({String? userToken, bool resetSession = true}) {
    if (resetSession) {
      emit(MiniAppSessionState(userToken: userToken));
      return;
    }

    emit(state.copyWith(userToken: userToken));
  }

  void setCurrentUser(UserEntityDto user) {
    emit(state.copyWith(currentUser: user));
  }

  void setLoginSession(LoginSession session) {
    emit(state.copyWith(loginSession: session));
  }

  void clearLoginSession() {
    emit(state.copyWith(loginSession: null));
  }
}
