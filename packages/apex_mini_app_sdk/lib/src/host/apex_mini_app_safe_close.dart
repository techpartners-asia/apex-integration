import 'package:flutter/widgets.dart';

import 'apex_mini_app_host_context.dart';

/// Requests a local mini-app close after the SDK dismisses transient UI.
///
/// Feature screens should call this helper for close buttons and fatal exits.
/// The active `ApexMiniAppSdk` owns duplicate-close protection and navigator
/// selection; no host callback is invoked.
Future<void> closeMiniAppSafely(BuildContext context) {
  return ApexMiniAppHostContext.requestClose(context: context);
}
