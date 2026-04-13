import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/app/investx_api/dto/user_entity_dto.dart';
import 'package:mini_app_sdk/src/app/session/data/current_user_repository.dart';
import 'package:mini_app_sdk/src/app/session/data/login_session_repository.dart';
import 'package:mini_app_sdk/src/app/session/mini_app_session_controller.dart';
import 'package:mini_app_sdk/src/app/session/mini_app_session_store.dart';
import 'package:mini_app_sdk/src/app/session/models/login_session.dart';
import 'package:mini_app_sdk/src/core/token/token_provider.dart';

class _FakeCurrentUserRepository implements CurrentUserRepository {
  int callCount = 0;

  @override
  Future<UserEntityDto> getCurrentUser({required String userToken}) async {
    callCount += 1;
    return UserEntityDto(
      registerNo: '',
      firstName: '',
      lastName: '',
      phone: '88993076',
      admSession: 'signup-jwt-token',
    );
  }
}

class _FakeLoginSessionRepository implements LoginSessionRepository {
  @override
  Future<LoginSession> getLoginSession(UserEntityDto user) {
    throw UnimplementedError();
  }
}

void main() {
  test(
    'ensureCurrentUser stores signup token in current user token provider',
    () async {
      final currentUserTokenProvider = MutableTokenProvider();
      final controller = DefaultMiniAppSessionController(
        store: MiniAppSessionStore(initialUserToken: 'host-user-token'),
        currentUserRepository: _FakeCurrentUserRepository(),
        loginSessionRepository: _FakeLoginSessionRepository(),
        currentUserTokenProvider: currentUserTokenProvider,
        protectedTokenProvider: MutableTokenProvider(),
      );

      final user = await controller.ensureCurrentUser();

      expect(user.admSession, 'signup-jwt-token');
      expect(currentUserTokenProvider.currentAccessToken, 'signup-jwt-token');
    },
  );

  test(
    'ensureCurrentUser refreshes cached user when admSession is missing',
    () async {
      final store = MiniAppSessionStore(initialUserToken: 'host-user-token');
      store.setCurrentUser(
        UserEntityDto(
          registerNo: 'AB12345678',
          firstName: 'Stale',
          lastName: 'User',
          phone: '88993076',
        ),
      );
      final currentUserRepository = _FakeCurrentUserRepository();
      final currentUserTokenProvider = MutableTokenProvider();
      final controller = DefaultMiniAppSessionController(
        store: store,
        currentUserRepository: currentUserRepository,
        loginSessionRepository: _FakeLoginSessionRepository(),
        currentUserTokenProvider: currentUserTokenProvider,
        protectedTokenProvider: MutableTokenProvider(),
      );

      final user = await controller.ensureCurrentUser();

      expect(currentUserRepository.callCount, 1);
      expect(user.admSession, 'signup-jwt-token');
      expect(store.currentUser?.admSession, 'signup-jwt-token');
      expect(currentUserTokenProvider.currentAccessToken, 'signup-jwt-token');
    },
  );
}
