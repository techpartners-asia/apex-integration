import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

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
