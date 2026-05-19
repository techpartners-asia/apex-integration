import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class ApiIntegrationException extends ApiException {
  const ApiIntegrationException(super.message, {super.cause, super.stackTrace});
}
