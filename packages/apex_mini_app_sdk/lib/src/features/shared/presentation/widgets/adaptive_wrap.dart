import 'dart:math' as math;
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Responsive wrapping grid that calculates item width from size class columns.
class AdaptiveWrap extends StatelessWidget {
  /// Creates a responsive wrap with adaptive column counts.
  const AdaptiveWrap({
    super.key,
    required this.children,
    this.phoneColumns = 1,
    this.tabletColumns = 2,
    this.largeTabletColumns = 3,
  });

  /// Widgets to place in the responsive wrap.
  final List<Widget> children;

  /// Number of columns on phone-sized layouts.
  final int phoneColumns;

  /// Number of columns on tablet-sized layouts.
  final int tabletColumns;

  /// Number of columns on large tablet layouts.
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
