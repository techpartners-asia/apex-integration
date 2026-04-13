import 'dart:math' as math;

import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';

class AdaptiveWrap extends StatelessWidget {
  const AdaptiveWrap({
    super.key,
    required this.children,
    this.phoneColumns = 1,
    this.tabletColumns = 2,
    this.largeTabletColumns = 3,
  });

  final List<Widget> children;
  final int phoneColumns;
  final int tabletColumns;
  final int largeTabletColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final responsive = context.responsive;
        final int columns = responsive.adaptiveColumns(
          phone: phoneColumns,
          tablet: tabletColumns,
          largeTablet: largeTabletColumns,
        );
        final double gap = responsive.spacing.cardGap;
        final double constrainedWidth = math.min(
          constraints.maxWidth,
          responsive.maxContentWidth,
        );
        final double itemWidth = columns <= 1
            ? constrainedWidth
            : (constrainedWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((Widget child) => SizedBox(width: itemWidth, child: child))
              .toList(growable: false),
        );
      },
    );
  }
}
