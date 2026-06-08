/// Client-side gate when signup profile is missing required identity fields.
final class ProfileIncompleteSignupException implements Exception {
  /// Creates a profile-incomplete signup gate failure.
  const ProfileIncompleteSignupException();
}
