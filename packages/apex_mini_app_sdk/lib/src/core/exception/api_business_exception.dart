import 'api_exception_base.dart';

class ApiBusinessException extends ApiException {
  final int responseCode;

  const ApiBusinessException({
    required this.responseCode,
    required String message,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}
