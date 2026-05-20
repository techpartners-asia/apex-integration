import 'package:flutter/widgets.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Function used by internals to ask the host shell to close safely.
typedef ApexMiniAppSafeCloseHook =
    Future<void> Function(BuildContext? context, Object? result);

/// Process-wide bridge from SDK internals back to the active host widget.
///
/// The mini app has several feature layers that cannot receive host callbacks
/// through constructors. This context stores the currently active callback
/// bundle, controller, and safe-close hook while `ApexMiniAppSdk` is mounted.
class ApexMiniAppHostContext {
  ApexMiniAppHostContext._();

  /// Current host callback bundle.
  static ApexMiniAppHostCallbacks callbacks = ApexMiniAppHostCallbacks.empty;

  /// Current usable mini-app host controller, when the SDK is mounted.
  static MiniAppHostController? activeController;

  static bool _tokenExpiredEmitted = false;
  static ApexMiniAppSafeCloseHook? _safeClose;

  /// Replaces callbacks and optionally the safe-close hook for the active SDK.
  static void bind({
    required ApexMiniAppHostCallbacks nextCallbacks,
    ApexMiniAppSafeCloseHook? safeClose,
  }) {
    callbacks = nextCallbacks;
    _safeClose = safeClose;
    _tokenExpiredEmitted = false;
  }

  /// Clears callbacks only when the caller still owns the active callback set.
  static void clear(ApexMiniAppHostCallbacks owner) {
    if (!identical(callbacks, owner)) {
      return;
    }
    callbacks = ApexMiniAppHostCallbacks.empty;
    _safeClose = null;
    _tokenExpiredEmitted = false;
  }

  /// Registers the active controller for fallback navigation resolution.
  static void bindController(MiniAppHostController controller) {
    activeController = controller;
  }

  /// Clears the active controller only if it matches the disposing runtime.
  static void clearController(MiniAppHostController controller) {
    if (!identical(activeController, controller)) {
      return;
    }
    activeController = null;
  }

  /// Emits a close result through the current host callback bundle.
  static void emitClose([Object? result]) {
    callbacks.onClose?.call(result);
  }

  /// Runs the active safe-close hook, falling back to direct close emission.
  static Future<void> requestClose({
    BuildContext? context,
    Object? result,
  }) async {
    final ApexMiniAppSafeCloseHook? safeClose = _safeClose;
    if (safeClose == null) {
      emitClose(result);
      return;
    }

    await safeClose(context, result);
  }

  /// Emits a navigation event to the host.
  static void emitNavigate(String? routeName, Object? arguments) {
    callbacks.onNavigate?.call(routeName, arguments);
  }

  /// Emits token expiration at most once per active callback binding.
  static void emitTokenExpired() {
    if (_tokenExpiredEmitted) {
      return;
    }
    _tokenExpiredEmitted = true;
    callbacks.onTokenExpired?.call();
  }

  /// Emits an error to the host.
  static void emitError(Object error, [StackTrace? stackTrace]) {
    callbacks.onError?.call(error, stackTrace);
  }
}
