/// Protected login-session values used by InvestX/IPS APIs.
class LoginSession {
  /// Access token for protected APIs.
  final String accessToken;

  /// Optional backend/customer token.
  final String? customerToken;

  /// Creates a protected login session used by IPS APIs.
  const LoginSession({required this.accessToken, this.customerToken});
}
