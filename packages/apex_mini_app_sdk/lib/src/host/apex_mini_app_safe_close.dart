import 'package:flutter/widgets.dart';

import 'apex_mini_app_host_context.dart';

Future<void> closeMiniAppSafely(
  BuildContext context, {
  Object? result,
}) {
  return ApexMiniAppHostContext.requestClose(
    context: context,
    result: result,
  );
}
