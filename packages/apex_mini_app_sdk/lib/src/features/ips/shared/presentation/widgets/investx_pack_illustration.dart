import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class InvestXPackIllustration extends StatelessWidget {
  const InvestXPackIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      height: responsive.component(92),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: responsive.component(84),
            height: responsive.component(84),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
          ),
          Icon(
            Icons.stacked_line_chart_rounded,
            color: Colors.white,
            size: responsive.icon(AppSpacing.display),
          ),
          Positioned(
            left: responsive.space(18),
            top: responsive.space(18),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white.withValues(alpha: 0.92),
              size: responsive.icon(AppComponentSize.iconLg),
            ),
          ),
          Positioned(
            right: responsive.space(18),
            bottom: responsive.space(18),
            child: Icon(
              Icons.pie_chart_outline_rounded,
              color: Colors.white.withValues(alpha: 0.92),
              size: responsive.icon(AppComponentSize.iconLg),
            ),
          ),
        ],
      ),
    );
  }
}
