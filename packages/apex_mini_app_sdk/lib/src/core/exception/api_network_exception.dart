

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

class ApiNetworkException extends ApiException {
  const ApiNetworkException(super.message, {super.cause, super.stackTrace});
}
