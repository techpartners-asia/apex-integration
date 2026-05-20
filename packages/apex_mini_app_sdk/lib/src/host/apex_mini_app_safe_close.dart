import 'package:flutter/widgets.dart';

import 'apex_mini_app_host_context.dart';

/// Requests a host close after the SDK has dismissed mini-app overlays.
///
/// Feature screens should call this helper instead of invoking host callbacks
/// directly. The active `ApexMiniAppSdk` owns the actual close implementation,
/// including dialog/sheet cleanup and duplicate-close protection.
///
/// [result] is forwarded to `onCloseWithResult`/close callbacks when present.
Future<void> closeMiniAppSafely(
  BuildContext context, {
  Object? result,
}) {
  return ApexMiniAppHostContext.requestClose(
    context: context,
    result: result,
  );
}
