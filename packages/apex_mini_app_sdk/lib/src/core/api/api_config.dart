import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Low-level HTTP configuration for one API runtime.
class ApiConfig {
  /// Base URL for this runtime.
  final String baseUrl;

  /// App id/secret headers.
  final AppCredentials credentials;

  /// Connection timeout.
  final Duration connectTimeout;

  /// Request body send timeout.
  final Duration sendTimeout;

  /// Response receive timeout.
  final Duration receiveTimeout;

  /// Whether Dio debug logs should be attached in debug mode.
  final bool enableDebugLogs;

  /// Whether API calls should be mirrored to the admin backend logger.
  final bool enableBackendLogger;

  /// Base URL used for `/api/v1/logger/create` (admin root, not IPS prefix).
  final String? backendLoggerBaseUrl;

  /// Creates HTTP configuration for one Dio-backed API runtime.
  const ApiConfig({
    required this.baseUrl,
    required this.credentials,
    this.connectTimeout = ApiTimeouts.connect,
    this.sendTimeout = ApiTimeouts.send,
    this.receiveTimeout = ApiTimeouts.receive,
    this.enableDebugLogs = false,
    this.enableBackendLogger = true,
    this.backendLoggerBaseUrl,
  });
}
