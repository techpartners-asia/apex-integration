import 'package:flutter/material.dart';
import '../../images/images.dart';
import 'widgets.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class InvestXSignaturePanel extends StatelessWidget {
  final String title;
  final List<Offset?> points;
  final ValueChanged<Offset> onPointAdd;
  final VoidCallback onStrokeEnd;
  final VoidCallback onClear;
  final Widget? message;
  final String? placeholder;
  final double? height;
  final bool expandCanvasToFill;
  final double strokeWidth;
  final bool showPlaceholderWhenEmpty;

  const InvestXSignaturePanel({
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
                painter: InvestXSignaturePainter(
                  pointSnapshot,
                  strokeWidth: strokeWidth,
                ),
                child: showPlaceholder
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.dp(24),
                          ),
                          child: Text(
                            resolvedPlaceholder,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: InvestXDesignTokens.muted.withValues(
                                    alpha: 0.72,
                                  ),
                                ),
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
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: InvestXDesignTokens.ink,
              fontWeight: MiniAppTypography.bold,
              height: 1.25,
            ),
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

class InvestXSignaturePainter extends CustomPainter {
  const InvestXSignaturePainter(this.points, {this.strokeWidth = 2.6});

  final List<Offset?> points;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = InvestXDesignTokens.ink
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
  bool shouldRepaint(covariant InvestXSignaturePainter oldDelegate) {
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
