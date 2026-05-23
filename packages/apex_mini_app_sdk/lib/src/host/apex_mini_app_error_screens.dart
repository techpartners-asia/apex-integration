import 'package:flutter/material.dart';

import 'apex_mini_app_host_config.dart';

/// Host-facing fallback screen shown when the required token is missing.
class ApexMiniAppMissingTokenScreen extends StatelessWidget {
  /// Creates the missing-token fallback screen.
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

/// Host-facing fallback shown when the current host token/session expires.
class ApexMiniAppSessionExpiredScreen extends StatelessWidget {
  /// Creates the session-expired fallback screen.
  const ApexMiniAppSessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ApexMiniAppErrorScreen(
      title: 'Session expired',
      message: 'Please refresh the host token and reopen the Apex mini app.',
      icon: Icons.lock_clock_outlined,
      actionLabel: 'Close',
      onAction: () => Navigator.maybePop(context),
    );
  }
}

/// Host-facing fallback shown when SDK config validation fails.
class ApexMiniAppInvalidParamsScreen extends StatelessWidget {
  /// Creates the invalid-host-parameters fallback screen.
  const ApexMiniAppInvalidParamsScreen({
    super.key,
    required this.validation,
  });

  /// Validation result containing the specific parameter errors.
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

/// Host-facing fallback shown when SDK initialization fails unexpectedly.
class ApexMiniAppInitializationFailureScreen extends StatelessWidget {
  /// Creates the initialization-failure fallback screen.
  const ApexMiniAppInitializationFailureScreen({
    super.key,
    this.message,
  });

  /// Optional failure message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ApexMiniAppErrorScreen(
      title: 'Initialization failed',
      message: message ?? 'Apex mini app could not be initialized.',
      icon: Icons.warning_amber_rounded,
      actionLabel: 'Close',
      onAction: () => Navigator.maybePop(context),
    );
  }
}

/// Generic error surface used before the full mini-app runtime is available.
class ApexMiniAppErrorScreen extends StatelessWidget {
  /// Creates a generic host-facing SDK error screen.
  const ApexMiniAppErrorScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  /// Error title.
  final String title;

  /// Error message.
  final String message;

  /// Icon representing the error category.
  final IconData icon;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional action button callback.
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
