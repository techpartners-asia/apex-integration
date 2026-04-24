import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiUnknownException extends ApiException {
  const ApiUnknownException(super.message, {super.cause, super.stackTrace});
}
