final class ApiHeaderNames {
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String authorization = 'Authorization';
  static const String appId = 'APPID';
  static const String appSecret = 'APPSECRET';
  static const String accessToken = 'ACCESSTOKEN';
  static const String neSession = 'NESSESSION';
  static const String retry = 'x-retry';

  const ApiHeaderNames._();
}

final class ApiContentTypes {
  static const String json = 'application/json';
  static const String file = 'multipart/form-data';

  const ApiContentTypes._();
}
