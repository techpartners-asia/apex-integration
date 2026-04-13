import '../exception/api_exception.dart';
import 'api_parser.dart';

/// Unified API response guard that validates `responseCode`, optional `success`
/// flag, and extracts `message`/`body` fields from raw JSON responses.
///
/// Replaces the former `ApiResponseGuard` — all response validation now flows
/// through this single class.
final class ApiActionResultParser {
  const ApiActionResultParser._();

  /// Validates that the response indicates success.
  ///
  /// Throws [ApiBusinessException] when:
  /// - `responseCode` is present and non-zero, OR
  /// - `success` key is explicitly `false`
  ///
  /// When [strictResponseCode] is true (default: false), a missing
  /// `responseCode` is treated as failure (code 1). This matches the
  /// former `ApiResponseGuard.ensureSuccess` behaviour used by broker
  /// API DTOs where every response must carry `responseCode: 0`.
  static void ensureSuccess(
    Map<String, Object?> json, {
    required String fallbackErrorMessage,
    bool strictResponseCode = false,
  }) {
    final int? responseCode = ApiParser.asNullableInt(json['responseCode']);

    if (strictResponseCode) {
      final int code = responseCode ?? 1;
      if (code != 0) {
        throw ApiBusinessException(
          responseCode: code,
          message: messageOf(json) ?? fallbackErrorMessage,
        );
      }
      return;
    }

    if (responseCode != null && responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: messageOf(json) ?? fallbackErrorMessage,
      );
    }

    if (json.containsKey('success') &&
        !ApiParser.asFlag(json['success'], defaultValue: true)) {
      throw ApiBusinessException(
        responseCode: responseCode ?? 1,
        message: messageOf(json) ?? fallbackErrorMessage,
      );
    }
  }

  static String? messageOf(Map<String, Object?> json) {
    return ApiParser.asNullableString(json['responseDesc']) ??
        ApiParser.asNullableString(json['message']);
  }

  static Map<String, Object?> bodyOf(Map<String, Object?> json) {
    return ApiParser.asObjectMap(json['body']);
  }
}
