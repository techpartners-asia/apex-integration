import 'package:flutter/material.dart';

import 'apex_mini_app_host_config.dart';

class ApexMiniAppMissingTokenScreen extends StatelessWidget {
  const ApexMiniAppMissingTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ApexMiniAppErrorScreen(
      title: 'Missing token',
      message: 'Apex mini app requires a non-empty host token.',
      icon: Icons.lock_outline_rounded,
    );
  }
}

class ApexMiniAppSessionExpiredScreen extends StatelessWidget {
  const ApexMiniAppSessionExpiredScreen({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return ApexMiniAppErrorScreen(
      title: 'Session expired',
      message: 'Please refresh the host token and reopen the Apex mini app.',
      icon: Icons.lock_clock_outlined,
      actionLabel: 'Close',
      onAction: onClose,
    );
  }
}

class ApexMiniAppInvalidParamsScreen extends StatelessWidget {
  const ApexMiniAppInvalidParamsScreen({
    super.key,
    required this.validation,
  });

  final ApexMiniAppHostValidationResult validation;

  @override
  Widget build(BuildContext context) {
    return ApexMiniAppErrorScreen(
      title: 'Invalid host parameters',
      message: validation.message,
      icon: Icons.error_outline_rounded,
    );
  }
}

class ApexMiniAppInitializationFailureScreen extends StatelessWidget {
  const ApexMiniAppInitializationFailureScreen({
    super.key,
    this.message,
    this.onClose,
  });

  final String? message;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return ApexMiniAppErrorScreen(
      title: 'Initialization failed',
      message: message ?? 'Apex mini app could not be initialized.',
      icon: Icons.warning_amber_rounded,
      actionLabel: onClose == null ? null : 'Close',
      onAction: onClose,
    );
  }
}

class ApexMiniAppErrorScreen extends StatelessWidget {
  const ApexMiniAppErrorScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, size: 52, color: theme.colorScheme.error),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (actionLabel != null && onAction != null) ...<Widget>[
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: onAction,
                      child: Text(actionLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
