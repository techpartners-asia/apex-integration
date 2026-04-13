import 'package:flutter/widgets.dart';

import 'mini_app_responsive_api.dart';
import 'mini_app_responsive_data.dart';

extension MiniAppResponsiveContext on BuildContext {
  MiniAppResponsiveData get responsive => MiniAppResponsive.of(this);

  MiniAppResponsiveData get responsiveData => responsive;
}
