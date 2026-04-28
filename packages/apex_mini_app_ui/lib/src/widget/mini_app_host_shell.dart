import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniAppHostShell extends StatelessWidget {
  final Widget child;
  final bool scrollable;

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
