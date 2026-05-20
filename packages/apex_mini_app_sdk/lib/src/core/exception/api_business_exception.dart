import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Exception for backend business-rule failures with a response code.
class ApiBusinessException extends ApiException {
  /// Backend response code that caused the failure.
  final int responseCode;

  /// Creates a backend business-rule exception.
  const ApiBusinessException({
    required this.responseCode,
    required String message,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}
