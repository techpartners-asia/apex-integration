/// Route arguments for the startup blocked screen.
class StartupBlockedArguments {
  /// Creates startup blocked route arguments.
  const StartupBlockedArguments({
    this.message,
    this.responseCode,
    this.hideHero = false,
  });

  /// Optional user-facing error message from the backend.
  final String? message;

  /// Signup/bootstrap business response code used to pick the page title.
  final int? responseCode;

  /// Hides the error hero/title, e.g. for client-side gates that aren't
  /// really "errors" and should only show the message card.
  final bool hideHero;
}
