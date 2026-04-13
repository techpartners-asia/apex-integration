import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXOptionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final String? indexLabel;

  const InvestXOptionCard({
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
            gradient: selected ? InvestXDesignTokens.primaryGradient : null,
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
              child: Text(
                indexLabel == null ? label : '$indexLabel.$label',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? Colors.white : InvestXDesignTokens.ink,
                  fontWeight: MiniAppTypography.semiBold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
