import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for the account-opening payment-active check.
class IsPaymentActiveResponseDto {
  /// Whether the opening-fee commission payment is required.
  final bool isActive;

  /// Creates an is-payment-active response DTO.
  const IsPaymentActiveResponseDto({required this.isActive});

  /// Parses the `POST /api/v1/user/payment/is-payment-active` response.
  factory IsPaymentActiveResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Failed to check payment-active status.',
    );

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);

    return IsPaymentActiveResponseDto(
      isActive: ApiParser.asFlag(body['is_active']),
    );
  }
}
