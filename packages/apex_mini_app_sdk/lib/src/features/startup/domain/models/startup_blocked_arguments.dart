/// Route arguments for the startup blocked screen.
class StartupBlockedArguments {
  /// Creates startup blocked route arguments.
  const StartupBlockedArguments({
    this.message,
    this.responseCode,
  });

  /// Optional user-facing error message from the backend.
  final String? message;

  /// Signup/bootstrap business response code used to pick the page title.
  final int? responseCode;
}
