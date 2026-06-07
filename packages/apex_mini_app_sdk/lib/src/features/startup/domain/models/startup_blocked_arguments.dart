/// Route arguments for the startup blocked screen.
class StartupBlockedArguments {
  /// Creates startup blocked route arguments.
  const StartupBlockedArguments({
    required this.message,
    this.title,
  });

  /// User-facing error message from the backend.
  final String message;

  /// Optional page title override.
  final String? title;
}
