import 'dart:typed_data';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'repositories/mini_app_repository_support.dart';

part 'repositories/remote_mini_app_feedback_repository.dart';

part 'repositories/remote_mini_app_payments_repository.dart';

part 'repositories/remote_mini_app_profile_repository.dart';

part 'repositories/remote_mini_app_support_repository.dart';

/// Profile-related repository operations exposed to SDK features.
abstract interface class MiniAppProfileRepository {
  /// Fetches the current profile/account payload.
  Future<UserEntityDto> getProfileInfo();

  /// Loads all questionnaire goals.
  Future<List<QuestionnaireQuestion>> getAllGoals();

  /// Updates the selected investment target goal.
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req);

  /// Uploads and stores the user's drawn signature.
  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  });

  /// Updates personal and bank profile fields.
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req);
}

/// Feedback repository operations used by feedback screens.
abstract interface class MiniAppFeedbackRepository {
  /// Creates one feedback entry.
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req);

  /// Loads a paged feedback list.
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  });
}

/// Support repository operations used by Help screens.
abstract interface class MiniAppSupportRepository {
  /// Loads company support/contact data.
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false});
}

/// Payment repository operations used by contract/payment flows.
abstract interface class MiniAppPaymentsRepository {
  /// Creates a payment invoice for a mini-app action.
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req);

  /// Fetches payment status by invoice UUID.
  Future<String> getPaymentCallback({required String uuid});
}

/// Composite repository facade for all backend-backed mini-app features.
abstract interface class MiniAppApiRepository
    implements
        MiniAppProfileRepository,
        MiniAppFeedbackRepository,
        MiniAppSupportRepository,
        MiniAppPaymentsRepository {
  /// Creates the base composite mini-app API repository.
  const MiniAppApiRepository();
}

/// Default composite repository that delegates to focused remote repositories.
class RemoteMiniAppApiRepository implements MiniAppApiRepository {
  /// Profile repository implementation.
  final MiniAppProfileRepository profileRepository;

  /// Feedback repository implementation.
  final MiniAppFeedbackRepository feedbackRepository;

  /// Support repository implementation.
  final MiniAppSupportRepository supportRepository;

  /// Payments repository implementation.
  final MiniAppPaymentsRepository paymentsRepository;

  /// Creates a composite repository with optional overrides for tests.
  RemoteMiniAppApiRepository({
    required MiniAppApiBackend api,
    required MiniAppSessionController session,
    MiniAppLogger logger = const SilentMiniAppLogger(),
    TimedMemoryCacheMap<String, FeedbackListResponse>? feedbackListCache,
    TimedMemoryCache<BranchInfoEntity>? companyInfoCache,
    MiniAppProfileRepository? profileRepository,
    MiniAppFeedbackRepository? feedbackRepository,
    MiniAppSupportRepository? supportRepository,
    MiniAppPaymentsRepository? paymentsRepository,
  }) : profileRepository =
           profileRepository ??
           RemoteMiniAppProfileRepository(
             api: api,
             session: session,
             logger: logger,
           ),
       feedbackRepository =
           feedbackRepository ??
           RemoteMiniAppFeedbackRepository(
             api: api,
             session: session,
             logger: logger,
             feedbackListCache: feedbackListCache,
           ),
       supportRepository =
           supportRepository ??
           RemoteMiniAppSupportRepository(
             api: api,
             session: session,
             logger: logger,
             companyInfoCache: companyInfoCache,
           ),
       paymentsRepository =
           paymentsRepository ??
           RemoteMiniAppPaymentsRepository(
             api: api,
             session: session,
             logger: logger,
           );

  @override
  Future<UserEntityDto> getProfileInfo() => profileRepository.getProfileInfo();

  @override
  Future<List<QuestionnaireQuestion>> getAllGoals() =>
      profileRepository.getAllGoals();

  @override
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) =>
      profileRepository.updateTargetGoal(req);

  @override
  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  }) => profileRepository.updateSignature(bytes: bytes, fileName: fileName);

  @override
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) =>
      profileRepository.updateProfile(req);

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) =>
      feedbackRepository.createFeedback(req);

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) => feedbackRepository.getFeedbackList(
    limit: limit,
    page: page,
    forceRefresh: forceRefresh,
  );

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) =>
      supportRepository.getCompanyInfo(forceRefresh: forceRefresh);

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) =>
      paymentsRepository.createInvoice(req);

  @override
  Future<String> getPaymentCallback({required String uuid}) =>
      paymentsRepository.getPaymentCallback(uuid: uuid);
}
