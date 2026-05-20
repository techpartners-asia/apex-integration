/// Called when the mini app should close without returning structured data.
typedef ApexMiniAppCloseHook = void Function();

/// Called when the mini app closes and returns a result to the host.
typedef ApexMiniAppCloseResultHook = void Function(Object? result);

/// Called when the mini app detects that the host token/session is no longer
/// valid and the host must re-authenticate the user.
typedef ApexMiniAppTokenExpiredHook = void Function();

/// Called whenever the mini app opens or replaces an internal route.
typedef ApexMiniAppNavigateHook =
    void Function(
      /// The mini-app route name that became active.
      String? routeName,

      /// Optional route payload after SDK-internal launch context is stripped.
      Object? arguments,
    );

/// Called for host-visible initialization, navigation, API, and payment errors.
typedef ApexMiniAppErrorHook =
    void Function(
      /// Error object produced by the mini app.
      Object error,

      /// Stack trace when the error originated from an exception path.
      StackTrace? stackTrace,
    );

/// Callback bundle supplied by the host integration layer.
///
/// The SDK keeps callbacks in a single immutable object so runtime rebuilds can
/// update host communication without recreating unrelated dependencies.
class ApexMiniAppHostCallbacks {
  /// Creates a host callback bundle.
  const ApexMiniAppHostCallbacks({
    this.onClose,
    this.onTokenExpired,
    this.onNavigate,
    this.onError,
  });

  /// Empty callback bundle used when the host did not provide callbacks.
  static const ApexMiniAppHostCallbacks empty = ApexMiniAppHostCallbacks();

  /// Host close callback. The optional result is forwarded from completed
  /// routes or explicit `closeMiniAppSafely` calls.
  final ApexMiniAppCloseResultHook? onClose;

  /// Host token-expired callback.
  final ApexMiniAppTokenExpiredHook? onTokenExpired;

  /// Host navigation-observer callback.
  final ApexMiniAppNavigateHook? onNavigate;

  /// Host error-reporting callback.
  final ApexMiniAppErrorHook? onError;
}
