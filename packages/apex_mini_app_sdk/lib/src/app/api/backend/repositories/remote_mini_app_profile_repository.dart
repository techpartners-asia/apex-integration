part of '../mini_app_api_repository.dart';

class RemoteMiniAppProfileRepository implements MiniAppProfileRepository {
  final MiniAppApiBackend api;
  final MiniAppSessionController session;
  final MiniAppLogger logger;

  const RemoteMiniAppProfileRepository({
    required this.api,
    required this.session,
    this.logger = const SilentMiniAppLogger(),
  });

  @override
  Future<UserEntityDto> getProfileInfo() async {
    try {
      await _ensureAdminAuthToken(session);
      final UserEntityDto user = await api.getProfileInfo();
      session.cacheCurrentUser(user);
      return user;
    } catch (error, stackTrace) {
      logger.onError(
        'profile_info_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) async {
    try {
      final UserEntityDto currentUser = await _ensureAdminAuthToken(session);
      await api.updateTargetGoal(req);
      return await _refreshProfileAfterMutation(
        api: api,
        session: session,
        logger: logger,
        fallbackUser: currentUser.copyWith(
          account: (currentUser.account ?? const AccountDto()).copyWith(
            targetGoal: req.targetGoal,
          ),
        ),
        operation: 'update_target_goal',
      );
    } catch (error, stackTrace) {
      logger.onError(
        'update_target_goal_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  }) async {
    try {
      final UserEntityDto currentUser = await _ensureAdminAuthToken(session);
      await api.updateSignature(bytes: bytes, fileName: fileName);
      return await _refreshProfileAfterMutation(
        api: api,
        session: session,
        logger: logger,
        fallbackUser: currentUser,
        operation: 'update_signature',
      );
    } catch (error, stackTrace) {
      logger.onError(
        'update_signature_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) async {
    try {
      final UserEntityDto currentUser = await _ensureAdminAuthToken(session);
      await api.updateProfile(req);
      return await _refreshProfileAfterMutation(
        api: api,
        session: session,
        logger: logger,
        fallbackUser: currentUser.copyWith(
          bank: (currentUser.bank ?? const BankDto()).copyWith(
            accountNumber: req.bank?.accountNumber,
            accountName: req.bank?.accountName,
            bankCode: req.bank?.bankCode,
            bankName: req.bank?.bankName,
          ),
          email: req.email,
          phone: req.phone,
          phoneAddition: req.phoneAddition,
          currentDepartment: req.currentDepartment,
          currentPosition: req.currentPosition,
          gender: req.gender,
          lastName: req.lastName,
          residenceAddress: req.residenceAddress,
          residenceCountry: req.residenceCountry,
        ),
        operation: 'update_profile',
      );
    } catch (error, stackTrace) {
      logger.onError(
        'update_profile_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
