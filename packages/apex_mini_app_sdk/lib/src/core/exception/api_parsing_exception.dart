import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiParsingException extends ApiException {
  const ApiParsingException(super.message, {super.cause, super.stackTrace});
}
