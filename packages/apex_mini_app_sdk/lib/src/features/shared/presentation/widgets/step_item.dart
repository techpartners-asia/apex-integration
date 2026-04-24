import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class StepItem {
  final String title;
  final StepStatus status;
  final VoidCallback? onTap;

  const StepItem({
    required this.title,
    required this.status,
    this.onTap,
  });
}
