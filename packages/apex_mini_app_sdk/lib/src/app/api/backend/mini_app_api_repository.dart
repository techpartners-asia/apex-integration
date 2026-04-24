import 'dart:typed_data';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class MiniAppApiRepository {
  const MiniAppApiRepository();

  Future<UserEntityDto> getProfileInfo() {
    throw UnimplementedError();
  }

  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) {
    throw UnimplementedError();
  }

  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  }) {
    throw UnimplementedError();
  }

  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) {
    throw UnimplementedError();
  }

  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) {
    throw UnimplementedError();
  }

  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) {
    throw UnimplementedError();
  }

  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) {
    throw UnimplementedError();
  }

  Future<String> getPaymentCallback({required String invoiceId}) {
    throw UnimplementedError();
  }
}

class RemoteMiniAppApiRepository implements MiniAppApiRepository {
  static const Duration _feedbackListCacheTtl = Duration(minutes: 2);
  static const Duration _companyInfoCacheTtl = Duration(minutes: 10);

  final MiniAppApiBackend api;
  final MiniAppSessionController session;
  final MiniAppLogger logger;
  final TimedMemoryCacheMap<String, FeedbackListResponse> _feedbackListCache;
  final TimedMemoryCache<BranchInfoEntity> _companyInfoCache;

  String? _feedbackCacheScope;

  RemoteMiniAppApiRepository({
    required this.api,
    required this.session,
    this.logger = const SilentMiniAppLogger(),
    TimedMemoryCacheMap<String, FeedbackListResponse>? feedbackListCache,
    TimedMemoryCache<BranchInfoEntity>? companyInfoCache,
  }) : _feedbackListCache =
           feedbackListCache ??
           TimedMemoryCacheMap<String, FeedbackListResponse>(
             ttl: _feedbackListCacheTtl,
           ),
       _companyInfoCache = companyInfoCache ?? TimedMemoryCache<BranchInfoEntity>(ttl: _companyInfoCacheTtl);

  @override
  Future<UserEntityDto> getProfileInfo() async {
    try {
      await _ensureAdminAuthToken();
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
      final UserEntityDto currentUser = await _ensureAdminAuthToken();
      await api.updateTargetGoal(req);
      return await _refreshProfileAfterMutation(
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
      final UserEntityDto currentUser = await _ensureAdminAuthToken();
      await api.updateSignature(bytes: bytes, fileName: fileName);
      return await _refreshProfileAfterMutation(
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
      final UserEntityDto currentUser = await _ensureAdminAuthToken();
      await api.updateProfile(req);
      return await _refreshProfileAfterMutation(
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

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) async {
    try {
      await _ensureAdminAuthToken();
      final response = await api.createFeedback(req);
      _feedbackListCache.invalidateAll();
      return response.entity;
    } catch (error, stackTrace) {
      logger.onError(
        'create_feedback_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) async {
    try {
      await _ensureAdminAuthToken();
      final String scope = _feedbackScope();
      if (_feedbackCacheScope != scope) {
        _feedbackListCache.invalidateAll();
        _feedbackCacheScope = scope;
      }

      return _feedbackListCache.getOrLoad(
        _feedbackListCacheKey(limit: limit, page: page),
        () async {
          final response = await api.getFeedbackList(
            FeedbackListApiReq(limit: limit, page: page),
          );
          return response.toDomain();
        },
        forceRefresh: forceRefresh,
      );
    } catch (error, stackTrace) {
      logger.onError(
        'get_feedback_list_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) async {
    try {
      return _companyInfoCache.getOrLoad(
        () async {
          await _ensureAdminAuthToken();
          final response = await api.getCompanyInfo();
          return response.entity;
        },
        forceRefresh: forceRefresh,
      );
    } catch (error, stackTrace) {
      logger.onError(
        'get_company_info_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) async {
    try {
      await _ensureAdminAuthToken();
      final response = await api.createInvoice(req);
      return response.toDomain();
    } catch (error, stackTrace) {
      logger.onError(
        'create_invoice_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<String> getPaymentCallback({required String invoiceId}) async {
    try {
      await _ensureAdminAuthToken();
      final response = await api.getPaymentCallback(
        PaymentCallbackQuery(invoiceId: invoiceId),
      );
      return response.body;
    } catch (error, stackTrace) {
      logger.onError(
        'payment_callback_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<UserEntityDto> _ensureAdminAuthToken() async {
    final UserEntityDto user = await session.ensureCurrentUser();
    if ((user.admSession?.trim().isNotEmpty ?? false)) {
      return user;
    }

    throw const ApiIntegrationException(
      'signUp bootstrap did not return an admin auth token.',
    );
  }

  Future<UserEntityDto> _refreshProfileAfterMutation({
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

  String _feedbackScope() {
    final UserEntityDto? currentUser = session.currentUser;
    return <String>[
      session.userToken?.trim() ?? '',
      currentUser?.userId.toString() ?? '',
      currentUser?.registerNo?.trim() ?? '',
    ].join('|');
  }

  String _feedbackListCacheKey({
    required int limit,
    required int page,
  }) {
    return 'limit:$limit|page:$page';
  }
}
