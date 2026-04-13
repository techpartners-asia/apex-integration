import 'api_exception_base.dart';

class ApiUnauthorizedException extends ApiException {
  const ApiUnauthorizedException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}
