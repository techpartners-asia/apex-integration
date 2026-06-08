part of '../mini_app_api_repository.dart';

/// Remote implementation of profile operations.
class RemoteMiniAppProfileRepository implements MiniAppProfileRepository {
  /// Low-level API facade for profile endpoints.
  final MiniAppApiBackend api;

  /// Session controller that supplies and caches the current user.
  final MiniAppSessionController session;

  /// Logger used for endpoint failures.
  final MiniAppLogger logger;

  /// Creates the remote profile repository.
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
  Future<List<QuestionnaireQuestion>> getAllGoals() async {
    try {
      await _ensureAdminAuthToken(session);
      final List<QuestionnaireQuestionDto> res = await api.getAllGoals();
      return res
          .map((QuestionnaireQuestionDto dto) => dto.toDomain())
          .toList(growable: false);
    } catch (error, stackTrace) {
      logger.onError(
        'get_all_goals_failed',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  @override
  Future<GrapeQuestionnaireCompletionStatus> checkGrapeQuestionnaireCompleted() async {
    try {
      await _ensureAdminAuthToken(session);
      final GrapeQuestionnaireCheckCompletedResDto res =
          await api.checkGrapeQuestionnaireCompleted();
      return res.toDomain();
    } catch (error, stackTrace) {
      logger.onError(
        'check_grape_questionnaire_completed_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> completeGrapeQuestionnaire({
    required List<GrapeQuestionAnswerSubmission> questions,
  }) async {
    try {
      await _ensureAdminAuthToken(session);
      await api.completeGrapeQuestionnaire(questions: questions);
    } catch (error, stackTrace) {
      logger.onError(
        'complete_grape_questionnaire_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<QuestionnaireRes> setGrapeQuestionnaireScore({
    required int totalScore,
  }) async {
    try {
      await _ensureAdminAuthToken(session);
      final QuestionnaireResDto res = await api.setGrapeQuestionnaireScore(
        totalScore: totalScore,
      );
      return res.toDomain(true);
    } catch (error, stackTrace) {
      logger.onError(
        'set_grape_questionnaire_score_failed',
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
        fallbackUser: currentUser,
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
