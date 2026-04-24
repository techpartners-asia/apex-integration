import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntStepIndicator extends StatelessWidget {
  final SecAcntFlowStep currentStep;
  final AcntBootstrapState? bootstrapState;

  const SecAcntStepIndicator({
    super.key,
    required this.currentStep,
    required this.bootstrapState,
  });

  @override
  Widget build(BuildContext context) {
    final List<SecAcntFlowStep> steps = resolveSecAcntFlowSteps(bootstrapState);
    final int currentIndex = steps.indexOf(currentStep);
    if (currentIndex < 0 || steps.length <= 1) {
      return const SizedBox.shrink();
    }

    final responsive = context.responsive;
    final int total = steps.length;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.dp(4),
        responsive.dp(4),
        responsive.dp(4),
        responsive.dp(12),
      ),
      child: Row(
        children: List<Widget>.generate(total, (int index) {
          final bool isActive = index <= currentIndex;
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.dp(2)),
              height: responsive.dp(3),
              decoration: BoxDecoration(
                color: isActive
                    ? DesignTokens.rose
                    : DesignTokens.muted.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(responsive.dp(2)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
