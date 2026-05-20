import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';

/// Wraps content in an adaptive pull-to-refresh container when refresh is set.
class MiniAppRefreshContainer extends StatelessWidget {
  /// Refresh callback. Null disables pull-to-refresh.
  final RefreshCallback? onRefresh;

  /// Content inside the refresh container.
  final Widget child;

  /// Optional scroll padding.
  final EdgeInsetsGeometry? padding;

  /// Reserved for layouts that should fill the viewport.
  final bool fillHeight;

  /// Creates a pull-to-refresh content container.
  const MiniAppRefreshContainer({
    super.key,
    required this.onRefresh,
    required this.child,
    this.padding,
    this.fillHeight = true,
  });

  @override
  Widget build(BuildContext context) {
    if (onRefresh == null) {
      return child;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets resolvedPadding =
            padding?.resolve(Directionality.of(context)) ??
            context.responsive.spacing.pagePadding;

        return RefreshIndicator.adaptive(
          onRefresh: onRefresh!,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: resolvedPadding,
            child: child,
          ),
        );
      },
    );
  }
}
