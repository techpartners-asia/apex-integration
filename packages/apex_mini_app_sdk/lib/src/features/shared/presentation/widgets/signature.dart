import 'package:flutter/material.dart';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Signature capture panel with a drawable canvas and clear action.
class SignaturePanel extends StatelessWidget {
  /// Panel title shown above the canvas.
  final String title;

  /// Stroke points. `null` entries separate strokes.
  final List<Offset?> points;

  /// Called when the user adds a point while drawing.
  final ValueChanged<Offset> onPointAdd;

  /// Called when the current stroke ends.
  final VoidCallback onStrokeEnd;

  /// Called when the clear button is tapped.
  final VoidCallback onClear;

  /// Optional message/instructions shown above the canvas.
  final Widget? message;

  /// Placeholder text shown while the canvas is empty.
  final String? placeholder;

  /// Fixed canvas height when [expandCanvasToFill] is false.
  final double? height;

  /// Whether the canvas should fill remaining vertical space.
  final bool expandCanvasToFill;

  /// Width of the drawn signature stroke.
  final double strokeWidth;

  /// Whether the placeholder remains visible until drawing starts.
  final bool showPlaceholderWhenEmpty;

  /// Creates a drawable signature panel.
  const SignaturePanel({
    super.key,
    required this.title,
    required this.points,
    required this.onPointAdd,
    required this.onStrokeEnd,
    required this.onClear,
    this.message,
    this.placeholder,
    this.height,
    this.expandCanvasToFill = false,
    this.strokeWidth = 2.6,
    this.showPlaceholderWhenEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final String resolvedPlaceholder =
        placeholder ?? l10n.commonSignaturePlaceholder;
    final double fallbackHeight = responsive.dp(320);
    final List<Offset?> pointSnapshot = List<Offset?>.of(
      points,
      growable: false,
    );
    final bool hasSignature = pointSnapshot.any(
      (Offset? point) => point != null,
    );
    final bool showPlaceholder =
        !hasSignature &&
        showPlaceholderWhenEmpty &&
        resolvedPlaceholder.trim().isNotEmpty;

    final Widget signatureCanvas = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(responsive.radius(18)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.radius(18)),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (DragStartDetails details) =>
                  onPointAdd(details.localPosition),
              onPanUpdate: (DragUpdateDetails details) =>
                  onPointAdd(details.localPosition),
              onPanEnd: (_) => onStrokeEnd(),
              child: CustomPaint(
                painter: SignaturePainter(
                  pointSnapshot,
                  strokeWidth: strokeWidth,
                ),
                child: showPlaceholder
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.dp(24),
                          ),
                          child: CustomText(
                            resolvedPlaceholder,
                            textAlign: TextAlign.center,
                            variant: MiniAppTextVariant.caption1,
                            color: DesignTokens.muted.withValues(alpha: 0.72),
                          ),
                        ),
                      )
                    : const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Positioned(
          top: responsive.dp(12),
          right: responsive.dp(12),
          child: InkWell(
            onTap: onClear,
            child: CustomImage(
              path: Img.clear,
              width: responsive.dp(32),
              height: responsive.dp(32),
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: expandCanvasToFill ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          CustomText(
            title,
            variant: MiniAppTextVariant.subtitle2,
            color: DesignTokens.ink,
          ),
          SizedBox(height: responsive.dp(14)),
          if (message != null) ...<Widget>[
            message!,
            SizedBox(height: responsive.dp(14)),
          ],
          if (expandCanvasToFill)
            Expanded(
              child: SizedBox(width: double.infinity, child: signatureCanvas),
            )
          else
            SizedBox(
              height: height ?? fallbackHeight,
              width: double.infinity,
              child: signatureCanvas,
            ),
        ],
      ),
    );
  }
}

/// Painter that renders signature strokes from point lists.
class SignaturePainter extends CustomPainter {
  /// Creates a painter for the captured signature strokes.
  const SignaturePainter(this.points, {this.strokeWidth = 2.6});

  /// Stroke points. `null` entries split separate strokes.
  final List<Offset?> points;

  /// Stroke width used by the painter.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = DesignTokens.ink
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int index = 0; index < points.length - 1; index += 1) {
      final Offset? current = points[index];
      final Offset? next = points[index + 1];
      if (current == null || next == null) {
        continue;
      }
      canvas.drawLine(current, next, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    if (oldDelegate.strokeWidth != strokeWidth) {
      return true;
    }

    if (oldDelegate.points.length != points.length) {
      return true;
    }

    for (int index = 0; index < points.length; index += 1) {
      if (oldDelegate.points[index] != points[index]) {
        return true;
      }
    }

    return false;
  }
}
