import 'app_credentials.dart';
import 'api_timeouts.dart';

class ApiConfig {
  final String baseUrl;
  final AppCredentials credentials;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final bool enableDebugLogs;

  const ApiConfig({
    required this.baseUrl,
    required this.credentials,
    this.connectTimeout = ApiTimeouts.connect,
    this.sendTimeout = ApiTimeouts.send,
    this.receiveTimeout = ApiTimeouts.receive,
    this.enableDebugLogs = false,
  });
}
