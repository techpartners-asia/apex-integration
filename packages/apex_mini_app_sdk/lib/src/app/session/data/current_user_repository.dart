import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

abstract interface class CurrentUserRepository {
  Future<UserEntityDto> getCurrentUser({required String userToken});
}

class RemoteSignupBootstrapRepository implements CurrentUserRepository {
  final SignUpBackendApi api;
  final MiniAppApiBackend? profileApi;
  final MutableTokenProvider? adminTokenProvider;
  final MiniAppLogger logger;

  const RemoteSignupBootstrapRepository({
    required this.api,
    this.profileApi,
    this.adminTokenProvider,
    this.logger = const SilentMiniAppLogger(),
  });

  @override
  Future<UserEntityDto> getCurrentUser({required String userToken}) async {
    try {
      final UserEntityDto response = await api.signUp(
        SignUpApiReq(token: userToken),
      );
      final UserEntityDto bootstrapUser = _attachAdminSession(response);
      final String? adminToken = _normalizedAdminToken(bootstrapUser);
      adminTokenProvider?.updateAccessToken(adminToken);
      final UserEntityDto user = await _hydrateProfile(
        bootstrapUser,
        adminToken: adminToken,
      );

      logger.onInfo(
        'signup_bootstrap_succeeded',
        data: <String, Object?>{
          'userId': user.userId,
          'hasSignupToken': (response.token?.trim().isNotEmpty ?? false),
        },
      );

      return user;
    } catch (error, stackTrace) {
      logger.onError(
        'signup_bootstrap_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  UserEntityDto _attachAdminSession(UserEntityDto user) {
    user.admSession = _normalizedAdminToken(user);
    return user;
  }

  String? _normalizedAdminToken(UserEntityDto user) {
    final String? session = user.admSession?.trim();
    if (session != null && session.isNotEmpty) {
      return session;
    }

    final String? token = user.token?.trim();
    if (token != null && token.isNotEmpty) {
      return token;
    }

    return null;
  }

  Future<UserEntityDto> _hydrateProfile(
    UserEntityDto bootstrapUser, {
    required String? adminToken,
  }) async {
    final MiniAppApiBackend? profileApi = this.profileApi;
    if (profileApi == null || adminToken == null) {
      return bootstrapUser;
    }

    try {
      final UserEntityDto profileUser = await profileApi.getProfileInfo();
      logger.onInfo(
        'signup_profile_hydrated',
        data: <String, Object?>{'profileUserId': profileUser.userId},
      );
      profileUser.admSession = adminToken;
      return profileUser;
    } catch (error, stackTrace) {
      logger.onError(
        'signup_profile_hydration_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return bootstrapUser;
    }
  }
}
