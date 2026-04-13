import 'api_exception_base.dart';

class ApiParsingException extends ApiException {
  const ApiParsingException(super.message, {super.cause, super.stackTrace});
}
