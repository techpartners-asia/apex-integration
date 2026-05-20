/// Normalized securities account status used by onboarding decisions.
enum AcntStatus {
  /// No securities account exists.
  none,

  /// Account opening is in progress.
  pending,

  /// Securities account is active.
  active,
}
