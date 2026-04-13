import 'package:flutter/material.dart';

extension ContextTextTheme on BuildContext {
  TextTheme get txt => Theme.of(this).textTheme;
}
