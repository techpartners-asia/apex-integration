import 'dart:async';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

/// Startup screen that loads bootstrap state and routes to the first IPS page.
class IpsSplashScreen extends StatefulWidget {
  /// Creates the IPS startup splash screen.
  const IpsSplashScreen({super.key});

  @override
  State<IpsSplashScreen> createState() => IpsSplashScreenState();
}

/// State for [IpsSplashScreen].
///
/// Owns delayed navigation and startup error dialog lifecycle so pending work
/// is cancelled when the mini app closes during splash.
class IpsSplashScreenState extends State<IpsSplashScreen> {
  /// Whether bootstrap success has already scheduled navigation.
  bool navigated = false;

  /// Prevents multiple startup error dialogs from stacking.
  bool errorDialogVisible = false;

  Timer? _navigationTimer;

  @override
  void dispose() {
    _cancelPendingNavigation();
    super.dispose();
  }

  /// Cancels any delayed route replacement scheduled by bootstrap success.
  void _cancelPendingNavigation() {
    _navigationTimer?.cancel();
    _navigationTimer = null;
  }

  /// Safely closes the mini app from splash after cancelling pending work.
  Future<void> _closeSplash(BuildContext context) async {
    _cancelPendingNavigation();
    Navigator.of(context).maybePop();
  }

  /// Schedules the resolved initial route after the current frame.
  void _scheduleResolvedNavigation(MiniAppBootstrapRes resolution) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _navigationTimer?.cancel();
      _navigationTimer = Timer(const Duration(milliseconds: 300), () {
        _navigationTimer = null;
        if (!mounted || !isIpsNavigationControllerAvailable(context)) {
          return;
        }

        unawaited(
          replaceIpsRoute(
            context,
            route: resolution.nextRoute,
            arguments: resolution.bootstrapState,
          ),
        );
      });
    });
  }

  /// Shows the fatal startup error dialog with close and retry actions.
  Future<void> showErrorDialog(
    BuildContext context,
    LoadableState<MiniAppBootstrapRes> state,
  ) async {
    if (errorDialogVisible || !mounted) {
      return;
    }

    errorDialogVisible = true;
    final MiniAppBootstrapCubit cubit = context.read<MiniAppBootstrapCubit>();
    final l10n = context.l10n;

    await showMiniAppDialog<void>(
      context: context,
      barrierDismissible: false,
      title: l10n.errorsGenericTitle,

      /// Error Text
      body: CustomText(
        state.errorMessage ?? l10n.errorsNetwork,
        variant: MiniAppTextVariant.body2,
      ),

      /// Error icon
      icon: Icon(
        Icons.error_outline_rounded,
        color: DesignTokens.rose,
        size: 35,
      ),

      /// Buttons
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await Future<void>.delayed(const Duration(milliseconds: 100));
            if (!mounted || !context.mounted) {
              return;
            }
            await closeMiniAppSafely(context);
          },
          child: CustomText(
            l10n.commonDismiss,
            variant: MiniAppTextVariant.buttonMedium,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            cubit.load();
          },
          child: CustomText(
            l10n.commonRetry,
            variant: MiniAppTextVariant.buttonMedium,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );

    errorDialogVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MiniAppBootstrapCubit, LoadableState<MiniAppBootstrapRes>>(
      listener: (BuildContext context, LoadableState<MiniAppBootstrapRes> state) {
        final MiniAppBootstrapRes? resolution = state.data;
        if (state.isFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(context, state);
          });

          return;
        }

        if (navigated || resolution == null || !state.isSuccess) return;

        navigated = true;

        _scheduleResolvedNavigation(resolution);
      },
      builder: (BuildContext context, LoadableState<MiniAppBootstrapRes> state) {
        final ThemeData theme = DesignTokens.theme(
          Theme.of(context),
        );
        final responsive = context.responsive;
        final double closeTop = responsive.safeTop + responsive.dp(14);

        return Theme(
          data: theme,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    DesignTokens.rose,
                    DesignTokens.coral,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Align(
                    alignment: const Alignment(0, -0.03),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomImage(
                        path: Img.splashInvestX,
                        height: responsive.dp(60),
                      ),
                    ),
                  ),
                  Positioned(
                    top: closeTop,
                    right: responsive.space(AppSpacing.md),
                    child: ActionButton(
                      onPressed: () => _closeSplash(context),
                      icon: Icons.close_rounded,
                      iosIcon: CupertinoIcons.xmark,
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0x5B3A2834),
                      boxShadow: const <BoxShadow>[],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
