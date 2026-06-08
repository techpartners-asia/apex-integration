import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Reusable status page content for securities account completion/pending states.
class SecAcntStatusContent extends StatelessWidget {
  /// Main status title.
  final String title;

  /// Title shown inside the status card.
  final String cardTitle;

  /// Supporting message shown inside the status card.
  final String message;

  /// Creates status content.
  const SecAcntStatusContent({
    super.key,
    required this.title,
    required this.cardTitle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets padding = EdgeInsets.fromLTRB(
          responsive.dp(20),
          responsive.dp(24),
          responsive.dp(20),
          responsive.dp(20),
        );

        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - padding.vertical,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: responsive.dp(28)),
                Center(
                  child: CustomImage(
                    path: Img.success,
                    width: responsive.dp(53),
                    height: responsive.dp(53),
                  ),
                ),
                SizedBox(height: responsive.dp(20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.dp(20)),
                  child: CustomText(
                    title,
                    textAlign: TextAlign.center,
                    variant: MiniAppTextVariant.h8,
                  ),
                ),
                SizedBox(height: responsive.dp(30)),
                _SecAcntStatusCard(title: cardTitle, message: message),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// White status card nested inside [SecAcntStatusContent].
class _SecAcntStatusCard extends StatelessWidget {
  /// Creates a securities-account status card.
  const _SecAcntStatusCard({required this.title, required this.message});

  /// Status card title.
  final String title;

  /// Status card supporting message.
  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppGlassCard(
      radius: responsive.radius(20),
      padding: EdgeInsets.all(responsive.dp(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomImage(
            path: Img.clock,
            width: responsive.dp(56),
            height: responsive.dp(56),
          ),
          SizedBox(height: responsive.dp(15)),

          /// Title
          CustomText(title, variant: MiniAppTextVariant.subtitle3),

          SizedBox(height: responsive.dp(10)),

          /// Message
          CustomText(
            message,
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.muted,
          ),
        ],
      ),
    );
  }
}
