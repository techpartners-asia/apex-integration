import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Exception for invalid SDK usage or malformed host/API integration inputs.
class ApiIntegrationException extends ApiException {
  /// Creates an API integration exception.
  const ApiIntegrationException(super.message, {super.cause, super.stackTrace});
}
