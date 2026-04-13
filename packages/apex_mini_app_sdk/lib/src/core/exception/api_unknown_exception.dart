import 'api_exception_base.dart';

class ApiUnknownException extends ApiException {
  const ApiUnknownException(super.message, {super.cause, super.stackTrace});
}
