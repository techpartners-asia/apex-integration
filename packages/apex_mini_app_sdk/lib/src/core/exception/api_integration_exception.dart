import 'api_exception_base.dart';

class ApiIntegrationException extends ApiException {
  const ApiIntegrationException(super.message, {super.cause, super.stackTrace});
}
