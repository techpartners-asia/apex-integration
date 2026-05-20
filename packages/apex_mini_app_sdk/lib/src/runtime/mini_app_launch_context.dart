import '../host/apex_mini_app_host_config.dart';

/// Internal argument wrapper passed with the first mini-app launch.
///
/// It keeps host token/session/user data available during startup while still
/// allowing the original host-provided arguments to be forwarded to the first
/// route.
class MiniAppLaunchContext {
  /// Host token used by startup/session initialization.
  final String? userToken;

  /// Optional host user snapshot.
  final ApexMiniAppHostUser? hostUser;

  /// Optional host session snapshot.
  final ApexMiniAppHostSession? hostSession;

  /// Original route arguments supplied by the host.
  final Object? arguments;

  /// Creates launch context passed to the first mini-app route.
  ///
  /// The runtime wraps primitive route arguments in this object so feature
  /// bootstrap code can read host authentication and session data without
  /// exposing that wrapper back through public host navigation callbacks.
  const MiniAppLaunchContext({
    this.userToken,
    this.hostUser,
    this.hostSession,
    this.arguments,
  });
}
