import 'package:flutter/material.dart';

extension MiniAppTextThemeContext on BuildContext {
  TextTheme get textTheme => MiniAppTextTheme.of(this);
}

class MiniAppTextTheme {
  static TextTheme of(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
