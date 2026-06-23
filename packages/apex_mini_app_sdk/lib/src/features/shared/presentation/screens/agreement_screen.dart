import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Shared agreement/terms screen with consent and continue action.
class AgreementScreen extends StatelessWidget {
  /// App bar title.
  final String? appBarTitle;

  /// Agreement title.
  final String title;

  /// Agreement body widget.
  final Widget body;

  /// Consent checkbox label.
  final String consentLabel;

  /// Whether consent is accepted.
  final bool accepted;

  /// Called when consent changes.
  final ValueChanged<bool> onAcceptedChanged;

  /// Continue button label.
  final String continueLabel;

  /// Continue action.
  final VoidCallback? onContinue;

  /// Back action.
  final VoidCallback? onBack;

  /// Dismiss action.
  final VoidCallback? onDismiss;

  /// Whether back button is visible.
  final bool showBackButton;

  /// Whether close button is visible.
  final bool showCloseButton;

  /// Whether app bar title is centered.
  final bool appBarCenterTitle;

  /// Whether leading app bar space is reserved.
  final bool appBarReserveLeadingSpace;

  /// Optional title spacing.
  final double? appBarTitleSpacing;

  /// Optional title style.
  final TextStyle? appBarTitleStyle;

  /// Whether safe area is applied.
  final bool hasSafeArea;

  /// Optional blocking overlay.
  final Widget? overlay;

  /// Optional widget above agreement content.
  final Widget? headerWidget;

  /// Creates a shared agreement screen.
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
    this.onDismiss,
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

/// Scrollable sanitized HTML body for agreement copy.
class AgreementHtmlBody extends StatelessWidget {
  /// Raw agreement HTML/text from backend or localization.
  final String agreementText;

  /// Creates an agreement HTML body.
  const AgreementHtmlBody({super.key, required this.agreementText});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
      child: SelectionArea(
        child: Html(
          data: sanitizeAgreementHtml(agreementText),
          style: <String, Style>{
            'body': Style(textAlign: TextAlign.justify),
            'p': Style(textAlign: TextAlign.justify),
            'div': Style(textAlign: TextAlign.justify),
          },
        ),
      ),
    );
  }
}

/// Removes unsafe or irrelevant HTML wrapper tags before rendering.
String sanitizeAgreementHtml(String raw) {
  return raw
      .replaceAll(RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<head[\s\S]*?</head>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<script[\s\S]*?</script>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<style[\s\S]*?</style>', caseSensitive: false), '')
      .replaceAll('charset=windows-1252', 'charset=UTF-8')
      .replaceAll('charset=Windows-1252', 'charset=UTF-8');
}
