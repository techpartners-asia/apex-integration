import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Exception thrown when the backend rejects auth/session credentials.
class ApiUnauthorizedException extends ApiException {
  /// Creates an unauthorized API exception.
  const ApiUnauthorizedException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}
