import 'package:flutter_bloc/flutter_bloc.dart';
import '../investx_api/dto/user_entity_dto.dart';

import 'mini_app_session_state.dart';
import 'models/login_session.dart';

class MiniAppSessionStore extends Cubit<MiniAppSessionState> {
  MiniAppSessionStore({String? initialUserToken}) : super(MiniAppSessionState(userToken: initialUserToken));

  String? get userToken => state.userToken;

  UserEntityDto? get currentUser => state.currentUser;

  LoginSession? get loginSession => state.loginSession;

  void prepareLaunch({String? userToken}) {
    emit(MiniAppSessionState(userToken: userToken));
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
