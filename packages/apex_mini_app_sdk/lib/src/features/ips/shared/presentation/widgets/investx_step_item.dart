import 'package:flutter/material.dart';

import 'investx_step_status.dart';

class InvestXStepItem {
  final String title;
  final InvestXStepStatus status;
  final VoidCallback? onTap;

  const InvestXStepItem({
    required this.title,
    required this.status,
    this.onTap,
  });
}
