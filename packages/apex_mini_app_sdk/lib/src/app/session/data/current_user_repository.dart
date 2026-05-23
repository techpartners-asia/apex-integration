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
      return _mergeHydratedProfile(
        profileUser: profileUser,
        bootstrapUser: bootstrapUser,
        adminToken: adminToken,
      );
    } catch (error, stackTrace) {
      logger.onError(
        'signup_profile_hydration_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return bootstrapUser;
    }
  }

  /// Merges signup-only onboarding flags into hydrated profile responses.
  UserEntityDto _mergeHydratedProfile({
    required UserEntityDto profileUser,
    required UserEntityDto bootstrapUser,
    required String? adminToken,
  }) {
    return UserEntityDto(
      token: _firstText(profileUser.token, bootstrapUser.token),
      account: _mergeAccount(profileUser.account, bootstrapUser.account),
      bank: _mergeBank(profileUser.bank, bootstrapUser.bank),
      id: profileUser.id ?? bootstrapUser.id,
      registerNo: _firstText(profileUser.registerNo, bootstrapUser.registerNo),
      firstName: _firstText(profileUser.firstName, bootstrapUser.firstName),
      lastName: _firstText(profileUser.lastName, bootstrapUser.lastName),
      phone: _firstText(profileUser.phone, bootstrapUser.phone),
      phoneAddition: _firstText(
        profileUser.phoneAddition,
        bootstrapUser.phoneAddition,
      ),
      email: _firstText(profileUser.email, bootstrapUser.email),
      gender: _firstText(profileUser.gender, bootstrapUser.gender),
      integrationId: _firstText(
        profileUser.integrationId,
        bootstrapUser.integrationId,
      ),
      currentDepartment: _firstText(
        profileUser.currentDepartment,
        bootstrapUser.currentDepartment,
      ),
      currentPosition: _firstText(
        profileUser.currentPosition,
        bootstrapUser.currentPosition,
      ),
      image: profileUser.image ?? bootstrapUser.image,
      imageId: profileUser.imageId ?? bootstrapUser.imageId,
      platform: profileUser.platform != PlatformType.unknown
          ? profileUser.platform
          : bootstrapUser.platform,
      region: profileUser.region ?? bootstrapUser.region,
      regionId: profileUser.regionId ?? bootstrapUser.regionId,
      residenceAddress: _firstText(
        profileUser.residenceAddress,
        bootstrapUser.residenceAddress,
      ),
      residenceCountry: _firstText(
        profileUser.residenceCountry,
        bootstrapUser.residenceCountry,
      ),
      createdAt: profileUser.createdAt ?? bootstrapUser.createdAt,
      updatedAt: profileUser.updatedAt ?? bootstrapUser.updatedAt,
      accessToken: _firstText(
        profileUser.accessToken,
        bootstrapUser.accessToken,
      ),
      admSession:
          adminToken ??
          _firstText(profileUser.admSession, bootstrapUser.admSession),
    );
  }

  AccountDto? _mergeAccount(AccountDto? profile, AccountDto? bootstrap) {
    if (profile == null) {
      return bootstrap;
    }
    if (bootstrap == null) {
      return profile;
    }

    return AccountDto(
      accountCreationDate: _firstText(
        profile.accountCreationDate,
        bootstrap.accountCreationDate,
      ),
      acntCode: _firstText(profile.acntCode, bootstrap.acntCode),
      createdAt: _firstText(profile.createdAt, bootstrap.createdAt),
      id: profile.id ?? bootstrap.id,
      investAmount: profile.investAmount ?? bootstrap.investAmount,
      isInvest: _mergeNullableFlag(profile.isInvest, bootstrap.isInvest),
      isInvestContract: _mergeNullableFlag(
        profile.isInvestContract,
        bootstrap.isInvestContract,
      ),
      isPaidContract: profile.isPaidContract || bootstrap.isPaidContract,
      kycStatus: profile.kycStatus != KycStatusType.unknown
          ? profile.kycStatus
          : bootstrap.kycStatus,
      packageCode: _firstText(profile.packageCode, bootstrap.packageCode),
      profitAmount: profile.profitAmount ?? bootstrap.profitAmount,
      profitPercent: profile.profitPercent ?? bootstrap.profitPercent,
      scAcntCode: _firstText(profile.scAcntCode, bootstrap.scAcntCode),
      signatureId: profile.signatureId ?? bootstrap.signatureId,
      streak: _firstText(profile.streak, bootstrap.streak),
      targetGoal: profile.targetGoal ?? bootstrap.targetGoal,
      totalAmount: profile.totalAmount ?? bootstrap.totalAmount,
      updatedAt: _firstText(profile.updatedAt, bootstrap.updatedAt),
      userId: profile.userId ?? bootstrap.userId,
      signatureFile: profile.signatureFile ?? bootstrap.signatureFile,
      signatureFileReference: _firstText(
        profile.signatureFileReference,
        bootstrap.signatureFileReference,
      ),
    );
  }

  BankDto? _mergeBank(BankDto? profile, BankDto? bootstrap) {
    if (profile == null) {
      return bootstrap;
    }
    if (bootstrap == null) {
      return profile;
    }

    return BankDto(
      accountNumber: _firstText(
        profile.accountNumber,
        bootstrap.accountNumber,
      ),
      accountName: _firstText(profile.accountName, bootstrap.accountName),
      bankId: _firstText(profile.bankId, bootstrap.bankId),
      bankCode: _firstText(profile.bankCode, bootstrap.bankCode),
      bankName: _firstText(profile.bankName, bootstrap.bankName),
      id: profile.id ?? bootstrap.id,
      userId: profile.userId ?? bootstrap.userId,
      createdAt: _firstText(profile.createdAt, bootstrap.createdAt),
      updatedAt: _firstText(profile.updatedAt, bootstrap.updatedAt),
    );
  }

  bool? _mergeNullableFlag(bool? profile, bool? bootstrap) {
    if (profile == true || bootstrap == true) {
      return true;
    }
    return profile ?? bootstrap;
  }

  String? _firstText(String? primary, String? fallback) {
    final String primaryText = primary?.trim() ?? '';
    if (primaryText.isNotEmpty) {
      return primaryText;
    }

    final String fallbackText = fallback?.trim() ?? '';
    return fallbackText.isEmpty ? null : fallbackText;
  }
}
