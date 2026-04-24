import 'package:flutter/cupertino.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsSplashScreen extends StatefulWidget {
  const IpsSplashScreen({super.key});

  @override
  State<IpsSplashScreen> createState() => IpsSplashScreenState();
}

class IpsSplashScreenState extends State<IpsSplashScreen> {
  bool navigated = false;
  bool errorDialogVisible = false;

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
      body: Text(
        state.errorMessage ?? l10n.errorsNetwork,
        style: Theme.of(context).textTheme.bodyMedium,
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
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text(l10n.commonClose),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            cubit.load();
          },
          child: Text(l10n.commonRetry),
        ),
      ],
    );

    errorDialogVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      MiniAppBootstrapCubit,
      LoadableState<MiniAppBootstrapRes>
    >(
      listener:
          (BuildContext context, LoadableState<MiniAppBootstrapRes> state) {
            final MiniAppBootstrapRes? resolution = state.data;
            if (state.isFailure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showErrorDialog(context, state);
              });
              return;
            }

            if (navigated || resolution == null || !state.isSuccess) return;

            navigated = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future<void>.delayed(const Duration(milliseconds: 300), () {
                if (!mounted) return;
                replaceIpsRoute(
                  this.context,
                  route: resolution.nextRoute,
                  arguments: resolution.bootstrapState,
                );
              });
            });
          },
      builder:
          (BuildContext context, LoadableState<MiniAppBootstrapRes> state) {
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
                          onPressed: () => Navigator.of(
                            context,
                            rootNavigator: true,
                          ).maybePop(),
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
