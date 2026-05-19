import 'package:flutter/widgets.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

typedef ApexMiniAppSafeCloseHook =
    Future<void> Function(BuildContext? context, Object? result);

class ApexMiniAppHostContext {
  ApexMiniAppHostContext._();

  static ApexMiniAppHostCallbacks callbacks = ApexMiniAppHostCallbacks.empty;
  static MiniAppHostController? activeController;
  static bool _tokenExpiredEmitted = false;
  static ApexMiniAppSafeCloseHook? _safeClose;

  static void bind({
    required ApexMiniAppHostCallbacks nextCallbacks,
    ApexMiniAppSafeCloseHook? safeClose,
  }) {
    callbacks = nextCallbacks;
    _safeClose = safeClose;
    _tokenExpiredEmitted = false;
  }

  static void clear(ApexMiniAppHostCallbacks owner) {
    if (!identical(callbacks, owner)) {
      return;
    }
    callbacks = ApexMiniAppHostCallbacks.empty;
    _safeClose = null;
    _tokenExpiredEmitted = false;
  }

  static void bindController(MiniAppHostController controller) {
    activeController = controller;
  }

  static void clearController(MiniAppHostController controller) {
    if (!identical(activeController, controller)) {
      return;
    }
    activeController = null;
  }

  static void emitClose([Object? result]) {
    callbacks.onClose?.call(result);
  }

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

  static void emitNavigate(String? routeName, Object? arguments) {
    callbacks.onNavigate?.call(routeName, arguments);
  }

  static void emitTokenExpired() {
    if (_tokenExpiredEmitted) {
      return;
    }
    _tokenExpiredEmitted = true;
    callbacks.onTokenExpired?.call();
  }

  static void emitError(Object error, [StackTrace? stackTrace]) {
    callbacks.onError?.call(error, stackTrace);
  }
}
