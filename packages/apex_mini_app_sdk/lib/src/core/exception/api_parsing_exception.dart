import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Exception for invalid or unexpected backend response shapes.
class ApiParsingException extends ApiException {
  /// Creates an API parsing exception.
  const ApiParsingException(super.message, {super.cause, super.stackTrace});
}
