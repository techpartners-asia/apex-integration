/// Wraps failures from the `/api/v1/user/signup` bootstrap step.
final class SignupBootstrapException implements Exception {
  /// Creates a signup bootstrap failure wrapper.
  const SignupBootstrapException(this.cause);

  /// Original error thrown by signup/bootstrap dependencies.
  final Object cause;

  @override
  String toString() => 'SignupBootstrapException($cause)';
}
