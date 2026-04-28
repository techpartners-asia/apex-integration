part of '../mini_app_api_repository.dart';

Future<UserEntityDto> _ensureAdminAuthToken(
  MiniAppSessionController session,
) async {
  final UserEntityDto user = await session.ensureCurrentUser();
  if ((user.admSession?.trim().isNotEmpty ?? false)) {
    return user;
  }

  throw const ApiIntegrationException(
    'signUp bootstrap did not return an admin auth token.',
  );
}

Future<UserEntityDto> _refreshProfileAfterMutation({
  required MiniAppApiBackend api,
  required MiniAppSessionController session,
  required MiniAppLogger logger,
  required UserEntityDto fallbackUser,
  required String operation,
}) async {
  try {
    final UserEntityDto user = await api.getProfileInfo();
    session.cacheCurrentUser(user);
    return user;
  } catch (error, stackTrace) {
    logger.onError(
      '${operation}_profile_refresh_failed',
      error: error,
      stackTrace: stackTrace,
    );
    session.cacheCurrentUser(fallbackUser);
    return fallbackUser;
  }
}

String _feedbackScope(MiniAppSessionController session) {
  final UserEntityDto? currentUser = session.currentUser;
  return <String>[
    session.userToken?.trim() ?? '',
    currentUser?.userId.toString() ?? '',
    currentUser?.registerNo?.trim() ?? '',
  ].join('|');
}
