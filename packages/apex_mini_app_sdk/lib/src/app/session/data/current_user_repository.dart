import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Loads the current Apex user from the host-provided authentication token.
abstract interface class CurrentUserRepository {
  /// Resolves the current user and bootstrap session information.
  Future<UserEntityDto> getCurrentUser({required String userToken});
}

/// Current-user repository backed by the sign-up bootstrap endpoint.
class RemoteSignupBootstrapRepository implements CurrentUserRepository {
  /// API wrapper for the sign-up/bootstrap endpoint.
  final SignUpBackendApi api;

  /// Optional profile API used to hydrate richer account fields after sign-up.
  final MiniAppApiBackend? profileApi;

  /// Mutable admin token provider updated once bootstrap returns a session.
  final MutableTokenProvider? adminTokenProvider;

  /// Logger used for bootstrap and hydration diagnostics.
  final MiniAppLogger logger;

  /// Creates the remote bootstrap repository.
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

  /// Ensures [admSession] is populated from the strongest available token.
  UserEntityDto _attachAdminSession(UserEntityDto user) {
    user.admSession = _normalizedAdminToken(user);
    return user;
  }

  /// Chooses the admin session token, falling back to the sign-up token.
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

  /// Fetches profile info when an admin token exists, without failing bootstrap.
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
