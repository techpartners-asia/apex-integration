/// Supplies the current access token to API header builders.
abstract interface class TokenProvider {
  /// Returns the current access token, or `null` when unauthenticated.
  Future<String?> getAccessToken();
}
