import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiIntegrationException extends ApiException {
  const ApiIntegrationException(super.message, {super.cause, super.stackTrace});
}
