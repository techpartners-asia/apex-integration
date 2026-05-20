import 'package:flutter/widgets.dart';

import 'mini_app_responsive_api.dart';
import 'mini_app_responsive_data.dart';

/// Convenience responsive accessors on [BuildContext].
extension MiniAppResponsiveContext on BuildContext {
  /// Responsive metrics for the current screen.
  MiniAppResponsiveData get responsive => MiniAppResponsive.of(this);

  /// Alias for [responsive].
  MiniAppResponsiveData get responsiveData => responsive;
}
