import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';

class MiniAppRefreshContainer extends StatelessWidget {
  final RefreshCallback? onRefresh;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool fillHeight;

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
        final EdgeInsets resolvedPadding = padding?.resolve(Directionality.of(context)) ?? context.responsive.spacing.pagePadding;

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
