import 'package:flutter/widgets.dart';

import 'mini_app_responsive_data.dart';

class MiniAppResponsive {
  const MiniAppResponsive._();

  static MiniAppResponsiveData of(BuildContext context) {
    return MiniAppResponsiveData.fromMediaQuery(MediaQuery.of(context));
  }

  static MiniAppResponsiveData fromWidth(double width) {
    return MiniAppResponsiveData.fromWidth(width);
  }

  static double maxContentWidthFor(double width) {
    return fromWidth(width).maxContentWidth;
  }

  static EdgeInsets contentPaddingFor(double width) {
    return fromWidth(width).spacing.pagePadding;
  }

  static double maxContentWidth(BuildContext context) {
    return of(context).maxContentWidth;
  }

  static EdgeInsets contentPadding(BuildContext context) {
    return of(context).spacing.pagePadding;
  }
}
