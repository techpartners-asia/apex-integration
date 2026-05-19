import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class ApiParsingException extends ApiException {
  const ApiParsingException(super.message, {super.cause, super.stackTrace});
}
