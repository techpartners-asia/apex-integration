class ApiException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const ApiException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => '$runtimeType(message: $message, cause: $cause)';
}
