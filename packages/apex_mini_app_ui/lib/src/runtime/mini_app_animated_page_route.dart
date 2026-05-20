import 'package:flutter/material.dart';

/// Shared page route animation used by the mini-app navigator.
class MiniAppAnimatedPageRoute<T> extends PageRouteBuilder<T> {
  /// Forward transition duration.
  static const Duration defaultTransitionDuration = Duration(milliseconds: 280);

  /// Reverse transition duration.
  static const Duration defaultReverseTransitionDuration = Duration(
    milliseconds: 220,
  );

  /// Creates a route that fades and slides pages in a platform-neutral way.
  MiniAppAnimatedPageRoute({
    required WidgetBuilder builder,
    super.settings,
    super.fullscreenDialog = false,
  }) : super(
         transitionDuration: defaultTransitionDuration,
         reverseTransitionDuration: defaultReverseTransitionDuration,
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) => builder(context),
         transitionsBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child,
             ) {
               final CurvedAnimation curvedAnimation = CurvedAnimation(
                 parent: animation,
                 curve: Curves.easeOutCubic,
                 reverseCurve: Curves.easeInCubic,
               );

               final Tween<Offset> slideTween = Tween<Offset>(
                 begin: fullscreenDialog
                     ? const Offset(0, 0.06)
                     : const Offset(0.04, 0),
                 end: Offset.zero,
               );

               return FadeTransition(
                 opacity: curvedAnimation,
                 child: SlideTransition(
                   position: slideTween.animate(curvedAnimation),
                   child: child,
                 ),
               );
             },
       );
}
