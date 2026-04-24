import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiUnauthorizedException extends ApiException {
  const ApiUnauthorizedException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}
