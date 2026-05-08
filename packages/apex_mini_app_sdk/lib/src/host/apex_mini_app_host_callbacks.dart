typedef ApexMiniAppCloseHook = void Function();
typedef ApexMiniAppCloseResultHook = void Function(Object? result);
typedef ApexMiniAppTokenExpiredHook = void Function();
typedef ApexMiniAppNavigateHook =
    void Function(
      String? routeName,
      Object? arguments,
    );
typedef ApexMiniAppErrorHook =
    void Function(
      Object error,
      StackTrace? stackTrace,
    );

class ApexMiniAppHostCallbacks {
  const ApexMiniAppHostCallbacks({
    this.onClose,
    this.onTokenExpired,
    this.onNavigate,
    this.onError,
  });

  static const ApexMiniAppHostCallbacks empty = ApexMiniAppHostCallbacks();

  final ApexMiniAppCloseResultHook? onClose;
  final ApexMiniAppTokenExpiredHook? onTokenExpired;
  final ApexMiniAppNavigateHook? onNavigate;
  final ApexMiniAppErrorHook? onError;
}
