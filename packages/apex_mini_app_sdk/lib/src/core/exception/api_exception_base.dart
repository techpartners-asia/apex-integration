/// Base exception type for SDK API and integration errors.
class ApiException implements Exception {
  /// Human-readable error message.
  final String message;

  /// Original error object, when this exception wraps another failure.
  final Object? cause;

  /// Stack trace associated with [cause].
  final StackTrace? stackTrace;

  /// Creates the base API exception.
  const ApiException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => '$runtimeType(message: $message, cause: $cause)';
}
