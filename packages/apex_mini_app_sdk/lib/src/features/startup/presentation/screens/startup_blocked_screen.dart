import 'dart:async';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Full-screen startup gate shown when signup/bootstrap blocks entry.
class StartupBlockedScreen extends StatelessWidget {
  /// Creates the startup blocked screen.
  const StartupBlockedScreen({super.key, required this.arguments});

  /// Route arguments with the backend error message.
  final StartupBlockedArguments arguments;

  @override
  Widget build(BuildContext context) {
    final SdkLocalizations l10n = context.l10n;
    final responsive = context.responsive;
    final String title = arguments.title ?? l10n.ipsStartupBlockedTitle;

    return CustomScaffold(
      hasAppBar: false,
      backgroundColor: DesignTokens.softSurface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            responsive.space(AppSpacing.xl),
            responsive.space(AppSpacing.md),
            responsive.space(AppSpacing.xl),
            responsive.space(AppSpacing.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              _StartupBlockedHero(title: title),
              SizedBox(height: responsive.dp(32)),
              _StartupBlockedMessageCard(message: arguments.message),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: l10n.commonDismiss,
          onPressed: () => unawaited(closeMiniAppSafely(context)),
        ),
      ),
    );
  }
}

class _StartupBlockedHero extends StatelessWidget {
  const _StartupBlockedHero({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      children: <Widget>[
        Icon(
            Icons.error_outline_rounded,
            size: responsive.dp(52),
            color: MiniAppStateColors.errorForeground,
          ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        CustomText(
          title,
          variant: MiniAppTextVariant.h8,
          textAlign: TextAlign.center,
          color: DesignTokens.ink,
        ),
      ],
    );
  }
}

class _StartupBlockedMessageCard extends StatelessWidget {
  const _StartupBlockedMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppSurfaceCard(
      backgroundColor: Colors.white,
      borderColor: MiniAppStateColors.errorBorder,
      borderRadius: responsive.radius(20),
      hasBorder: true,
      hasShadow: true,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.space(AppSpacing.xl),
        vertical: responsive.space(AppSpacing.lg),
      ),
      child: CustomText(
        message,
        variant: MiniAppTextVariant.body2,
        textAlign: TextAlign.left,
        color: DesignTokens.ink,
      ),
    );
  }
}
