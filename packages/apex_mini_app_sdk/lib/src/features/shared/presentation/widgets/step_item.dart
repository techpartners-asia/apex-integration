import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Data object for a tappable step in progress/stepper widgets.
class StepItem {
  /// Step title.
  final String title;

  /// Current visual state of the step.
  final StepStatus status;

  /// Optional tap handler when the step can be opened.
  final VoidCallback? onTap;

  /// Creates step metadata for progress and onboarding lists.
  const StepItem({
    required this.title,
    required this.status,
    this.onTap,
  });
}
