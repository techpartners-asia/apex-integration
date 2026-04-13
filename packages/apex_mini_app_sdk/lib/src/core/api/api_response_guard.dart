import 'api_action_result_parser.dart';

/// Thin backward-compatible wrapper that delegates to [ApiActionResultParser]
/// with `strictResponseCode: true`.
///
/// Retained so existing callers keep compiling without import changes.
/// New code should use [ApiActionResultParser.ensureSuccess] directly.
@Deprecated('Use ApiActionResultParser.ensureSuccess(strictResponseCode: true)')
class ApiResponseGuard {
  const ApiResponseGuard._();

  static void ensureSuccess(
    Map<String, Object?> json, {
    String fallbackMessage = 'Request failed.',
  }) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: fallbackMessage,
      strictResponseCode: true,
    );
  }
}
