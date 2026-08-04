import 'package:flutter/widgets.dart';

import 'apex_mini_app_host_context.dart';

/// Requests a local mini-app close after the SDK dismisses transient UI.
///
/// Feature screens should call this helper for close buttons and fatal exits.
/// The active `ApexMiniAppSdk` owns duplicate-close protection and navigator
/// selection; no host callback is invoked.
///
/// Pass [force] to drain every internal mini-app route in one call instead of
/// popping a single route — use this from root-level screens (e.g. the IPS
/// overview) so their close button always exits straight to the host instead
/// of surfacing a leftover internal route first.
Future<void> closeMiniAppSafely(BuildContext context, {bool force = false}) {
  return ApexMiniAppHostContext.requestClose(context: context, force: force);
}
