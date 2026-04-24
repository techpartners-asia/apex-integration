import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SignatureScreen extends StatelessWidget {
  final String? appBarTitle;
  final String title;
  final List<Offset?> points;
  final ValueChanged<Offset> onPointAdd;
  final VoidCallback onStrokeEnd;
  final VoidCallback onClear;
  final String continueLabel;
  final bool continueEnabled;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final bool showBackButton;
  final bool showCloseButton;
  final bool appBarCenterTitle;
  final bool appBarReserveLeadingSpace;
  final double? appBarTitleSpacing;
  final TextStyle? appBarTitleStyle;
  final bool hasSafeArea;
  final Widget? overlay;
  final Widget? message;
  final double? height;
  final String? placeholder;
  final bool showPlaceholderWhenEmpty;
  final double strokeWidth;
  final Widget? headerWidget;

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
    this.onClose,
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
      onClose: onClose,
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
