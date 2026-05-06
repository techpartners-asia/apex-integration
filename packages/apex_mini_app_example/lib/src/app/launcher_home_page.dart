import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:flutter/material.dart';

import 'example_app_tokens.dart';

class LauncherHomePage extends StatelessWidget {
  final MiniAppSdk sdk;

  const LauncherHomePage({required this.sdk, super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              colors.primary.withValues(alpha: 0.10),
              colors.secondary.withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: <Widget>[
              CustomText(
                'Mini App Launcher',
                key: const Key('launcher_title'),
                variant: MiniAppTextVariant.h8,
              ),
              const SizedBox(height: 8),
              CustomText(
                'Reference host for the partner-facing SDK surface.'
                'Tap once to open the ${sdk.miniAppDisplayName} mini app directly.',
                variant: MiniAppTextVariant.body2,
                color: ExampleAppTokens.mutedText,
              ),
              const SizedBox(height: 24),
              HeroCard(sdk: sdk, onLaunchMiniApp: () => launchMiniApp(context)),
              const SizedBox(height: 16),
              DetailsCard(
                sdk: sdk,
                onLaunchMiniApp: () => launchMiniApp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchMiniApp(BuildContext context) async {
    final MiniAppLaunchRes res = await sdk.launchRoute(context);

    if (!context.mounted || res.status == MiniAppLaunchStatus.success) {
      return;
    }

    final String title = res.errorCode?.title ?? 'Launch error';
    final String message = toSafeUserMessage(res);
    MiniAppToast.showError(
      context,
      title: title,
      message: message,
    );
  }

  String toSafeUserMessage(MiniAppLaunchRes res) {
    return switch (res.errorCode) {
      MiniAppLaunchErrorCode.routeNotFound => 'Сонгосон дэлгэц нээгдэх боломжгүй байна.',
      MiniAppLaunchErrorCode.invalidReq => 'Илгээсэн хүсэлт буруу форматтай байна.',
      _ => 'Системийн алдаа гарлаа. Дараа дахин оролдоно уу.',
    };
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.sdk, required this.onLaunchMiniApp});

  final MiniAppSdk sdk;
  final VoidCallback onLaunchMiniApp;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.22),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_graph_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 24),
          CustomText(
            sdk.miniAppDisplayName,
            variant: MiniAppTextVariant.h8,
            color: colors.onPrimary,
          ),
          const SizedBox(height: 8),
          CustomText(
            'Direct entry into the active investX mini app flow.',
            variant: MiniAppTextVariant.body2,
            color: colors.onPrimary.withValues(alpha: 0.84),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const Key('launch_invest_x_button'),
            onPressed: onLaunchMiniApp,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colors.primary,
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: CustomText(
              'Open ${sdk.miniAppDisplayName}',
              variant: MiniAppTextVariant.buttonMedium,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  final MiniAppSdk sdk;
  final VoidCallback onLaunchMiniApp;

  const DetailsCard({
    super.key,
    required this.sdk,
    required this.onLaunchMiniApp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        key: const Key('launch_invest_x_card'),
        borderRadius: BorderRadius.circular(24),
        onTap: onLaunchMiniApp,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomText(
                'Launch configuration',
                variant: MiniAppTextVariant.subtitle2,
              ),
              const SizedBox(height: 16),
              InfoRow(
                icon: Icons.route_outlined,
                label: 'Initial route',
                value: sdk.initialRoute,
              ),
              const SizedBox(height: 12),
              InfoRow(
                icon: Icons.apps_outlined,
                label: 'Active mini app',
                value: sdk.miniAppDisplayName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomText(
                label,
                variant: MiniAppTextVariant.caption1,
                color: ExampleAppTokens.mutedText,
              ),
              const SizedBox(height: 2),
              CustomText(
                value,
                variant: MiniAppTextVariant.subtitle2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
