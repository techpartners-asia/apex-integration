import 'dart:typed_data';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

part 'repositories/mini_app_repository_support.dart';

part 'repositories/remote_mini_app_feedback_repository.dart';

part 'repositories/remote_mini_app_payments_repository.dart';

part 'repositories/remote_mini_app_profile_repository.dart';

part 'repositories/remote_mini_app_support_repository.dart';

abstract interface class MiniAppProfileRepository {
  Future<UserEntityDto> getProfileInfo();

  Future<List<QuestionnaireQuestion>> getAllGoals();

  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req);

  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  });

  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req);
}

abstract interface class MiniAppFeedbackRepository {
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req);

  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  });
}

abstract interface class MiniAppSupportRepository {
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false});
}

abstract interface class MiniAppPaymentsRepository {
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req);

  Future<String> getPaymentCallback({required String uuid});
}

abstract interface class MiniAppApiRepository implements MiniAppProfileRepository, MiniAppFeedbackRepository, MiniAppSupportRepository, MiniAppPaymentsRepository {
  const MiniAppApiRepository();
}

class RemoteMiniAppApiRepository implements MiniAppApiRepository {
  final MiniAppProfileRepository profileRepository;
  final MiniAppFeedbackRepository feedbackRepository;
  final MiniAppSupportRepository supportRepository;
  final MiniAppPaymentsRepository paymentsRepository;

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
  Future<List<QuestionnaireQuestion>> getAllGoals() => profileRepository.getAllGoals();

  @override
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) => profileRepository.updateTargetGoal(req);

  @override
  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  }) => profileRepository.updateSignature(bytes: bytes, fileName: fileName);

  @override
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) => profileRepository.updateProfile(req);

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) => feedbackRepository.createFeedback(req);

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
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) => supportRepository.getCompanyInfo(forceRefresh: forceRefresh);

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) => paymentsRepository.createInvoice(req);

  @override
  Future<String> getPaymentCallback({required String uuid}) => paymentsRepository.getPaymentCallback(uuid: uuid);
}
