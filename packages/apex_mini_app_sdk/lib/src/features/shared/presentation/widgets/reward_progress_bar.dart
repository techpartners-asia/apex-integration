import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Segmented streak progress bar with a fire marker at the current month.
class RewardProgressBar extends StatelessWidget {
  const RewardProgressBar({
    super.key,
    required this.months,
    this.total = 12,
  });

  /// Completed month count.
  final int months;

  /// Total months represented by the bar.
  final int total;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double barHeight = responsive.dp(16);
    final double markerSize = responsive.dp(25);
    final int clamped = months.clamp(0, total).toInt();

    return SizedBox(
      height: markerSize,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double progress = total > 0 ? clamped / total : 0;
          final double markerLeft = (maxWidth * progress - markerSize / 2)
              .clamp(0.0, maxWidth - markerSize)
              .toDouble();

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: barHeight,
                  child: Row(
                    children: List<Widget>.generate(
                      total * 2 - 1,
                      (int index) {
                        if (index.isOdd) {
                          return Container(
                            width: responsive.dp(2),
                            color: Colors.white,
                          );
                        }

                        final int segmentIndex = index ~/ 2;
                        final bool completed = segmentIndex < clamped;

                        return Expanded(
                          child: ColoredBox(
                            color: completed
                                ? DesignTokens.rose
                                : DesignTokens.softPeach.withValues(alpha: 0.55),
                            child: SizedBox(height: barHeight),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (clamped > 0)
                Positioned(
                  left: markerLeft,
                  child: CustomImage(
                    path: Img.fireFull,
                    height: markerSize,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
