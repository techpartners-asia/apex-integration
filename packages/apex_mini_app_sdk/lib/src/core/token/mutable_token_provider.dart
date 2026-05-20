import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Token provider whose token can be updated after session/bootstrap changes.
class MutableTokenProvider implements TokenProvider {
  /// Current normalized token.
  String? accessToken;

  /// Creates a mutable provider with an optional initial token.
  MutableTokenProvider([String? accessToken])
    : accessToken = normalize(accessToken);

  /// Current token without async wrapper.
  String? get currentAccessToken => accessToken;

  /// Whether a non-empty token is present.
  bool get hasToken => accessToken != null;

  /// Updates the stored token after trimming blank values to null.
  void updateAccessToken(String? accessToken) {
    this.accessToken = normalize(accessToken);
  }

  /// Returns the latest normalized token.
  @override
  Future<String?> getAccessToken() async => accessToken;

  /// Normalizes blank strings to null.
  static String? normalize(String? value) {
    if (value == null) return null;

    final String normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
