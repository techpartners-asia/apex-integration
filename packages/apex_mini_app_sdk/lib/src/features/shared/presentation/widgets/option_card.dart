import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Selectable card used by questionnaire and option-selection flows.
class OptionCard extends StatelessWidget {
  /// Option label.
  final String label;

  /// Whether this option is selected.
  final bool selected;

  /// Optional tap handler.
  final VoidCallback? onTap;

  /// Optional prefix index shown before the label.
  final String? indexLabel;

  /// Creates a selectable option card.
  const OptionCard({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.indexLabel,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radius(14)),
        child: Ink(
          decoration: BoxDecoration(
            gradient: selected ? DesignTokens.primaryGradient : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(responsive.radius(14)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.spacing.financialCardSpacing,
              vertical: responsive.spacing.inlineSpacing,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                indexLabel == null ? label : '$indexLabel.$label',
                variant: MiniAppTextVariant.subtitle3,
                color: selected ? Colors.white : DesignTokens.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
