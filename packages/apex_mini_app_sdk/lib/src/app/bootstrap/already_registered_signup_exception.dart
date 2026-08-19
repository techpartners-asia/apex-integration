/// Client-side gate when the user already has a securities account opened
/// through the standalone APEX APP but hasn't paid the contract fee there.
final class AlreadyRegisteredSignupException implements Exception {
  /// Creates an already-registered-in-APEX-APP signup gate failure.
  const AlreadyRegisteredSignupException();
}
