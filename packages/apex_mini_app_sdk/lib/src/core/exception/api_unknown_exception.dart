import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class ApiUnknownException extends ApiException {
  const ApiUnknownException(super.message, {super.cause, super.stackTrace});
}
