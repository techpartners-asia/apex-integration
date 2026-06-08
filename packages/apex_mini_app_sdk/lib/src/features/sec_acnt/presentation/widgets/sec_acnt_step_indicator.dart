import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Progress indicator for the resolved securities account onboarding steps.
class SecAcntStepIndicator extends StatelessWidget {
  /// Current wizard step.
  final SecAcntFlowStep currentStep;

  /// Bootstrap state used to resolve which steps are included.
  final AcntBootstrapState? bootstrapState;

  /// Current user profile used for skip logic.
  final UserEntityDto? currentUser;

  /// Creates a securities account step indicator.
  const SecAcntStepIndicator({
    super.key,
    required this.currentStep,
    required this.bootstrapState,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final List<SecAcntFlowStep> steps = resolveSecAcntFlowProgressSteps(
      bootstrapState,
      currentUser: currentUser,
    );
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
