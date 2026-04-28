import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class BlockingLoadingOverlay extends StatelessWidget {
  final String title;
  final String message;

  const BlockingLoadingOverlay({
    super.key,
    required this.title,
    required this.message,
  });

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
            child: AgreementBodyCard(
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
                  CustomText(
                    title,
                    textAlign: TextAlign.center,
                    variant: MiniAppTextVariant.subtitle2,
                    color: DesignTokens.ink,
                  ),
                  SizedBox(height: responsive.dp(8)),
                  CustomText(
                    message,
                    textAlign: TextAlign.center,
                    variant: MiniAppTextVariant.body3,
                    color: DesignTokens.muted,
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
