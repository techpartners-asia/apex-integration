import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class ApiUnauthorizedException extends ApiException {
  const ApiUnauthorizedException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}
