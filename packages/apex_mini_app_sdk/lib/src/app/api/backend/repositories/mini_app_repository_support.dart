part of '../mini_app_api_repository.dart';

/// Ensures the session contains the admin token required by backend calls.
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

/// Refreshes profile after a mutation and keeps a local fallback if refresh fails.
Future<UserEntityDto> _refreshProfileAfterMutation({
  required MiniAppApiBackend api,
  required MiniAppSessionController session,
  required MiniAppLogger logger,
  required UserEntityDto fallbackUser,
  required String operation,
}) async {
  try {
    final UserEntityDto profileUser = await api.getProfileInfo();
    final UserEntityDto mergedUser = _mergeProfileAfterMutation(
      profileUser: profileUser,
      fallbackUser: fallbackUser,
    );
    session.cacheCurrentUser(mergedUser);
    return mergedUser;
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

UserEntityDto _mergeProfileAfterMutation({
  required UserEntityDto profileUser,
  required UserEntityDto fallbackUser,
}) {
  final AccountDto? profileAccount = profileUser.account;
  final AccountDto? fallbackAccount = fallbackUser.account;
  if (fallbackAccount == null) {
    return profileUser;
  }
  if (profileAccount == null) {
    return profileUser.copyWith(account: fallbackAccount);
  }

  return profileUser.copyWith(
    account: profileAccount.copyWith(
      isInvest: _mergeNullableFlag(
        profileAccount.isInvest,
        fallbackAccount.isInvest,
      ),
      isInvestContract: _mergeNullableFlag(
        profileAccount.isInvestContract,
        fallbackAccount.isInvestContract,
      ),
      isPaidContract:
          profileAccount.isPaidContract || fallbackAccount.isPaidContract,
      signatureId: profileAccount.signatureId ?? fallbackAccount.signatureId,
      signatureFile: profileAccount.signatureFile ?? fallbackAccount.signatureFile,
      signatureFileReference: _firstNonEmptyText(
        profileAccount.signatureFileReference,
        fallbackAccount.signatureFileReference,
      ),
    ),
  );
}

bool? _mergeNullableFlag(bool? primary, bool? fallback) {
  if (primary == true || fallback == true) {
    return true;
  }
  return primary ?? fallback;
}

String? _firstNonEmptyText(String? primary, String? fallback) {
  final String? trimmedPrimary = _trimToNull(primary);
  if (trimmedPrimary != null) {
    return trimmedPrimary;
  }

  return _trimToNull(fallback);
}

String? _trimToNull(String? value) {
  final String trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}

/// Builds the feedback cache scope so cached lists do not leak across users.
String _feedbackScope(MiniAppSessionController session) {
  final UserEntityDto? currentUser = session.currentUser;
  return <String>[
    session.userToken?.trim() ?? '',
    currentUser?.userId.toString() ?? '',
    currentUser?.registerNo?.trim() ?? '',
  ].join('|');
}
