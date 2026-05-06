import 'dart:typed_data';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:dio/dio.dart';

class MiniAppApiBackend {
  final ApiExecutor? publicExecutor;
  final ApiExecutor? authorizedExecutor;

  const MiniAppApiBackend({this.publicExecutor, this.authorizedExecutor});

  Future<UserEntityDto> getProfileInfo() async {
    final ApiExecutor executor = _requireAuthorizedExecutor('getProfileInfo');
    final Map<String, Object?> json = await executor.getJson(
      ApiEndpoints.profileInfo,
      context: const ReqContext(operName: 'getProfileInfo'),
    );

    return UserEntityDto.fromJson(json);
  }

  Future<List<QuestionnaireQuestionDto>> getAllGoals() async {
    final ApiExecutor executor = _requireAuthorizedExecutor('getAllGoals');
    final List<Object?> json = await executor.getJsonList(
      ApiEndpoints.getAllGoals,
      context: const ReqContext(operName: 'getAllGoals'),
    );

    return QuestionnaireQuestionDto.listFromQuestionApiRaw(json);
  }

  Future<CreateInvoiceResponseDto> createInvoice(CreateInvoiceApiReq req) async {
    final ApiExecutor executor = _requireAuthorizedExecutor('createInvoice');
    final Map<String, Object?> json = await executor.postJson(
      ApiEndpoints.createInvoice,
      body: req.toJson(),
      context: const ReqContext(operName: 'createInvoice'),
    );

    return CreateInvoiceResponseDto.fromJson(json);
  }

  Future<ApiActionResponseDto> updateTargetGoal(UpdateTargetGoalApiReq req) async {
    final ApiExecutor executor = _requireAuthorizedExecutor('updateTargetGoal');
    final Map<String, Object?> json = await executor.putJson(
      ApiEndpoints.updateTargetGoal,
      body: req.toJson(),
      context: const ReqContext(operName: 'updateTargetGoal'),
    );

    return ApiActionResponseDto.fromJson(
      json,
      failureMessage: 'Failed to update the target goal.',
    );
  }

  Future<ApiActionResponseDto> updateProfile(UpdateProfileApiReq req) async {
    final ApiExecutor executor = _requireAuthorizedExecutor('updateProfile');
    final Map<String, Object?> json = await executor.putJson(
      ApiEndpoints.updateProfile,
      body: req.toJson(),
      context: const ReqContext(operName: 'updateProfile'),
    );

    return ApiActionResponseDto.fromJson(
      json,
      failureMessage: 'Failed to update the profile.',
    );
  }

  Future<ApiActionResponseDto> updateSignature({required Uint8List bytes, required String fileName}) async {
    final ApiExecutor executor = _requireAuthorizedExecutor('updateSignature');

    final FormData formData = FormData.fromMap(<String, Object?>{
      'signature': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    final Map<String, Object?> json = await executor.putFormData(
      ApiEndpoints.updateSignature,
      body: formData,
      context: const ReqContext(operName: 'updateSignature'),
    );

    return ApiActionResponseDto.fromJson(
      json,
      failureMessage: 'Failed to update the signature.',
    );
  }

  Future<CreateFeedbackResponseDto> createFeedback(CreateFeedbackApiReq req) async {
    final ApiExecutor executor = _requireAuthorizedExecutor('createFeedback');
    final Map<String, Object?> json = await executor.postJson(
      ApiEndpoints.createFeedback,
      body: req.toJson(),
      context: const ReqContext(operName: 'createFeedback'),
    );

    return CreateFeedbackResponseDto.fromJson(json);
  }

  Future<FeedbackListResponseDto> getFeedbackList(FeedbackListApiReq req) async {
    final ApiExecutor executor = _requireAuthorizedExecutor('getFeedbackList');
    final Map<String, Object?> json = await executor.postJson(
      ApiEndpoints.feedbackList,
      body: req.toJson(),
      context: const ReqContext(operName: 'getFeedbackList'),
    );

    return FeedbackListResponseDto.fromJson(json);
  }

  Future<CompanyInfoResponseDto> getCompanyInfo() async {
    final ApiExecutor executor = _requireAuthorizedExecutor('getCompanyInfo');
    final Map<String, Object?> json = await executor.getJson(
      ApiEndpoints.companyInfo,
      context: const ReqContext(operName: 'getCompanyInfo'),
    );

    return CompanyInfoResponseDto.fromJson(json);
  }

  Future<PaymentCallbackResponseDto> getPaymentCallback(PaymentCallbackQuery query) async {
    final ApiExecutor executor = _requirePublicExecutor('getPaymentCallback');
    final Map<String, Object?> json = await executor.getJson(
      ApiEndpoints.paymentCallback,
      queryParameters: query.toQueryParameters(),
      context: const ReqContext(operName: 'getPaymentCallback'),
    );

    return PaymentCallbackResponseDto.fromJson(json);
  }

  ApiExecutor _requirePublicExecutor(String operation) {
    final ApiExecutor? executor = publicExecutor;
    if (executor == null) {
      throw ApiIntegrationException(
        '$operation requires a public API executor, but none was provided.',
      );
    }

    return executor;
  }

  ApiExecutor _requireAuthorizedExecutor(String operation) {
    final ApiExecutor? executor = authorizedExecutor;
    if (executor == null) {
      throw ApiIntegrationException(
        '$operation requires an authorized API executor, but none was provided.',
      );
    }

    return executor;
  }
}
