/// Header names shared by Apex and IPS API clients.
final class ApiHeaderNames {
  /// Standard content type header.
  static const String contentType = 'Content-Type';

  /// Standard accept header.
  static const String accept = 'Accept';

  /// Bearer authorization header used by Tech InvestX APIs.
  static const String authorization = 'Authorization';

  /// Apex app id header.
  static const String appId = 'APPID';

  /// Apex app secret header.
  static const String appSecret = 'APPSECRET';

  /// IPS access token header.
  static const String accessToken = 'ACCESSTOKEN';

  /// NE session header/key.
  static const String neSession = 'NESSESSION';

  /// Internal retry marker used by session refresh interceptor.
  static const String retry = 'x-retry';

  const ApiHeaderNames._();
}

/// Content types used by SDK API requests.
final class ApiContentTypes {
  /// JSON request/response content type.
  static const String json = 'application/json';

  /// Multipart form-data content type.
  static const String file = 'multipart/form-data';

  const ApiContentTypes._();
}
