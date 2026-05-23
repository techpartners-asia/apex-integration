import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Shared full-screen signature capture layout.
class SignatureScreen extends StatelessWidget {
  /// App bar title.
  final String? appBarTitle;

  /// Prompt displayed above the signature canvas.
  final String title;

  /// Stroke points drawn by the user.
  final List<Offset?> points;

  /// Called when a point is added during drawing.
  final ValueChanged<Offset> onPointAdd;

  /// Called when the current stroke ends.
  final VoidCallback onStrokeEnd;

  /// Clears all signature points.
  final VoidCallback onClear;

  /// Continue button label.
  final String continueLabel;

  /// Whether continue is enabled.
  final bool continueEnabled;

  /// Continue action.
  final VoidCallback? onContinue;

  /// Back action.
  final VoidCallback? onBack;

  /// Dismiss action.
  final VoidCallback? onDismiss;

  /// Whether the app bar back button is visible.
  final bool showBackButton;

  /// Whether the app bar close button is visible.
  final bool showCloseButton;

  /// Whether app bar title is centered.
  final bool appBarCenterTitle;

  /// Whether leading app bar space is reserved.
  final bool appBarReserveLeadingSpace;

  /// Optional app bar title spacing.
  final double? appBarTitleSpacing;

  /// Optional app bar title style override.
  final TextStyle? appBarTitleStyle;

  /// Whether the scaffold applies safe area.
  final bool hasSafeArea;

  /// Optional blocking overlay.
  final Widget? overlay;

  /// Optional message shown near the signature panel.
  final Widget? message;

  /// Optional fixed canvas height.
  final double? height;

  /// Placeholder text for the canvas.
  final String? placeholder;

  /// Whether the placeholder is visible when no points exist.
  final bool showPlaceholderWhenEmpty;

  /// Signature stroke width.
  final double strokeWidth;

  /// Optional widget rendered above the signature panel.
  final Widget? headerWidget;

  /// Creates a shared signature screen.
  const SignatureScreen({
    super.key,
    required this.appBarTitle,
    required this.title,
    required this.points,
    required this.onPointAdd,
    required this.onStrokeEnd,
    required this.onClear,
    required this.continueLabel,
    required this.continueEnabled,
    required this.onContinue,
    this.onBack,
    this.onDismiss,
    this.showBackButton = true,
    this.showCloseButton = false,
    this.appBarCenterTitle = true,
    this.appBarReserveLeadingSpace = true,
    this.appBarTitleSpacing,
    this.appBarTitleStyle,
    this.hasSafeArea = true,
    this.overlay,
    this.message,
    this.height,
    this.placeholder,
    this.showPlaceholderWhenEmpty = false,
    this.strokeWidth = 2.6,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: appBarTitle,
      showBackButton: showBackButton,
      showCloseButton: showCloseButton,
      onBack: onBack,
      onDismiss: onDismiss,
      appBarCenterTitle: appBarCenterTitle,
      appBarReserveLeadingSpace: appBarReserveLeadingSpace,
      appBarTitleSpacing: appBarTitleSpacing,
      appBarTitleStyle: appBarTitleStyle,
      hasSafeArea: hasSafeArea,
      backgroundColor: DesignTokens.softSurface,
      appBarBackgroundColor: DesignTokens.softSurface,
      appBarShowBottomBorder: false,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              if (headerWidget case final Widget header) header,
              Expanded(
                child: SignaturePanel(
                  title: title,
                  points: points,
                  onPointAdd: onPointAdd,
                  onStrokeEnd: onStrokeEnd,
                  onClear: onClear,
                  message: message,
                  height: height,
                  expandCanvasToFill: height == null,
                  placeholder: placeholder,
                  showPlaceholderWhenEmpty: showPlaceholderWhenEmpty,
                  strokeWidth: strokeWidth,
                ),
              ),
            ],
          ),
          if (overlay case final Widget child) Positioned.fill(child: child),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: continueLabel,
          onPressed: continueEnabled ? onContinue : null,
        ),
      ),
    );
  }
}
