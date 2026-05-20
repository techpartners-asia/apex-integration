/// Shared Dio timeout values for Apex SDK API calls.
final class ApiTimeouts {
  /// Maximum time to establish a connection.
  static const Duration connect = Duration(seconds: 30);

  /// Maximum time to send a request body.
  static const Duration send = Duration(seconds: 30);

  /// Maximum time to wait for a response body.
  static const Duration receive = Duration(seconds: 30);

  const ApiTimeouts._();
}
