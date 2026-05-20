import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Exception for unexpected failures that do not fit a narrower API category.
class ApiUnknownException extends ApiException {
  /// Creates an unknown API exception.
  const ApiUnknownException(super.message, {super.cause, super.stackTrace});
}
