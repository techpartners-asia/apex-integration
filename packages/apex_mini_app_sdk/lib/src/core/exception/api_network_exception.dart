import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiNetworkException extends ApiException {
  const ApiNetworkException(super.message, {super.cause, super.stackTrace});
}
