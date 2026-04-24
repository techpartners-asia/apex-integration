import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class AgreementScreen extends StatelessWidget {
  final String? appBarTitle;
  final String title;
  final Widget body;
  final String consentLabel;
  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;
  final String continueLabel;
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
  final Widget? headerWidget;

  const AgreementScreen({
    super.key,
    required this.appBarTitle,
    required this.title,
    required this.body,
    required this.consentLabel,
    required this.accepted,
    required this.onAcceptedChanged,
    required this.continueLabel,
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
                child: AgreementPageTemplate(
                  title: title,
                  body: body,
                  consentLabel: consentLabel,
                  accepted: accepted,
                  onAcceptedChanged: onAcceptedChanged,
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
          onPressed: accepted ? onContinue : null,
        ),
      ),
    );
  }
}

class AgreementHtmlBody extends StatelessWidget {
  const AgreementHtmlBody({super.key, required this.agreementText});

  final String agreementText;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
      child: SelectionArea(
        child: Html(data: sanitizeAgreementHtml(agreementText)),
      ),
    );
  }
}

String sanitizeAgreementHtml(String raw) {
  return raw
      .replaceAll(RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<head[\s\S]*?</head>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<script[\s\S]*?</script>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<style[\s\S]*?</style>', caseSensitive: false), '');
}
