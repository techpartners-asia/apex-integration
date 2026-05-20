import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Token provider that always returns the same access token.
class StaticTokenProvider implements TokenProvider {
  /// Static access token supplied at construction time.
  final String? accessToken;

  /// Creates a provider that always returns [accessToken].
  const StaticTokenProvider(this.accessToken);

  /// Returns the fixed token supplied at construction time.
  @override
  Future<String?> getAccessToken() async => accessToken;
}
