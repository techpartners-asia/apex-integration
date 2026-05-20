import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Sizes a mini-app page to the available host viewport.
class MiniAppHostShell extends StatelessWidget {
  /// Page content.
  final Widget child;

  /// Whether the shell should provide a scroll view around [child].
  final bool scrollable;

  /// Creates a host shell for embedded mini-app content.
  const MiniAppHostShell({
    super.key,
    required this.child,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget content = child;

        if (scrollable) {
          content = SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: math.max(0, constraints.maxHeight),
                minWidth: constraints.maxWidth,
              ),
              child: content,
            ),
          );
        } else {
          content = SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: content,
          );
        }

        return content;
      },
    );
  }
}
