/// Static application credentials used by Apex backend headers.
class AppCredentials {
  /// Backend application id.
  final String appId;

  /// Backend application secret.
  final String appSecret;

  /// Creates app id/secret credentials for API headers.
  const AppCredentials({required this.appId, required this.appSecret});
}
