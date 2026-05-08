import 'package:mini_app_ui/mini_app_ui.dart';

import 'apex_mini_app_host_callbacks.dart';

class ApexMiniAppHostContext {
  ApexMiniAppHostContext._();

  static ApexMiniAppHostCallbacks callbacks = ApexMiniAppHostCallbacks.empty;
  static MiniAppHostController? activeController;
  static bool _tokenExpiredEmitted = false;

  static void bind({
    required ApexMiniAppHostCallbacks nextCallbacks,
  }) {
    callbacks = nextCallbacks;
    _tokenExpiredEmitted = false;
  }

  static void clear(ApexMiniAppHostCallbacks owner) {
    if (!identical(callbacks, owner)) {
      return;
    }
    callbacks = ApexMiniAppHostCallbacks.empty;
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
