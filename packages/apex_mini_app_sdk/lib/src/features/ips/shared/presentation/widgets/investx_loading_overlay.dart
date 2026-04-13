import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../images/images.dart';
import '../helpers/investx_design_tokens.dart';
import 'custom_image.dart';
import 'investx_agreement.dart';

class InvestXBlockingLoadingOverlay extends StatelessWidget {
  const InvestXBlockingLoadingOverlay({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.84),
      child: Center(
        child: Padding(
          padding: responsive.insetsSymmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsive.dp(280)),
            child: InvestXAgreementBodyCard(
              padding: responsive.insetsSymmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomImage(
                    path: Img.loadingAnimation,
                    width: responsive.dp(88),
                    height: responsive.dp(88),
                  ),
                  SizedBox(height: responsive.dp(16)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: InvestXDesignTokens.ink,
                      fontWeight: MiniAppTypography.bold,
                    ),
                  ),
                  SizedBox(height: responsive.dp(8)),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: InvestXDesignTokens.muted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
