import 'api_exception_base.dart';

class ApiNetworkException extends ApiException {
  const ApiNetworkException(super.message, {super.cause, super.stackTrace});
}
