import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

class ApiIntegrationException extends ApiException {
  const ApiIntegrationException(super.message, {super.cause, super.stackTrace});
}
