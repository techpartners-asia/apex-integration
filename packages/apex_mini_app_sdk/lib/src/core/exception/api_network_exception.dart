import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Exception thrown for transport/connectivity failures.
class ApiNetworkException extends ApiException {
  /// Creates a network API exception.
  const ApiNetworkException(super.message, {super.cause, super.stackTrace});
}
