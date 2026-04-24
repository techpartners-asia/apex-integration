import 'package:mini_app_sdk/mini_app_sdk.dart';

class MutableTokenProvider implements TokenProvider {
  String? accessToken;

  MutableTokenProvider([String? accessToken])
    : accessToken = normalize(accessToken);

  String? get currentAccessToken => accessToken;

  bool get hasToken => accessToken != null;

  void updateAccessToken(String? accessToken) {
    this.accessToken = normalize(accessToken);
  }

  @override
  Future<String?> getAccessToken() async => accessToken;

  static String? normalize(String? value) {
    if (value == null) return null;

    final String normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
