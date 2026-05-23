import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Immutable configuration for a securities account wizard header.
class SecAcntWizardHeaderData {
  /// Header title.
  final String? title;

  /// Whether the back button is visible.
  final bool showBack;

  /// Whether the close button is visible.
  final bool showClose;

  /// Whether the title uses the brand accent style.
  final bool highlightBrand;

  /// Whether the title is centered.
  final bool centerTitle;

  /// Whether leading space is reserved when the back button is hidden.
  final bool reserveLeadingSpace;

  /// Top padding applied to the body under the header.
  final double bodyTopPadding;

  /// Creates header data.
  const SecAcntWizardHeaderData({
    required this.title,
    this.showBack = true,
    this.showClose = false,
    this.highlightBrand = false,
    this.centerTitle = true,
    this.reserveLeadingSpace = true,
    this.bodyTopPadding = 8,
  });
}

/// Immutable configuration for the wizard footer button.
class SecAcntWizardFooterData {
  /// Button label.
  final String buttonLabel;

  /// Button action.
  final VoidCallback? onPressed;

  /// Whether the button is enabled.
  final bool enabled;

  /// Creates footer data for a visible footer button.
  const SecAcntWizardFooterData({
    required this.buttonLabel,
    this.onPressed,
    this.enabled = true,
  });

  /// Creates footer data that hides the footer button.
  const SecAcntWizardFooterData.hidden()
    : buttonLabel = '',
      onPressed = null,
      enabled = false;
}

/// Shared header widget for the securities account wizard.
class SecAcntWizardHeader extends StatelessWidget {
  /// Header title.
  final String? title;

  /// Whether the back button is visible.
  final bool showBack;

  /// Whether the close button is visible.
  final bool showClose;

  /// Whether the title uses the brand accent style.
  final bool highlightBrand;

  /// Whether the title is centered.
  final bool centerTitle;

  /// Whether leading space is reserved when the back button is hidden.
  final bool reserveLeadingSpace;

  /// Back action callback.
  final VoidCallback onBack;

  /// Dismiss action callback.
  final VoidCallback onDismiss;

  /// Creates a shared wizard header.
  const SecAcntWizardHeader({
    super.key,
    this.title,
    required this.showBack,
    required this.showClose,
    required this.highlightBrand,
    this.centerTitle = true,
    this.reserveLeadingSpace = true,
    required this.onBack,
    required this.onDismiss,
  });

  @override
  // Size get preferredSize => const Size.fromHeight(CustomAppBar.defaultToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color titleColor = highlightBrand
        ? DesignTokens.rose
        : DesignTokens.ink;

    return CustomAppBar(
      title: title,
      showBackButton: showBack,
      showCloseButton: showClose,
      onBack: onBack,
      onDismiss: onDismiss,
      centerTitle: centerTitle,
      reserveLeadingSpace: reserveLeadingSpace,
      titleSpacing: centerTitle ? null : responsive.dp(20),
      backgroundColor: DesignTokens.softSurface,
      showBottomBorder: false,
      titleStyle:
          (highlightBrand
                  ? MiniAppTypography.title1
                  : MiniAppTypography.subtitle2)
              .copyWith(
                color: titleColor,
              ),
    );
  }
}

/// Shared bottom action area for the securities account wizard.
class SecAcntWizardFooter extends StatelessWidget {
  /// Button label.
  final String buttonLabel;

  /// Button action.
  final VoidCallback? onPressed;

  /// Whether the button is enabled.
  final bool enabled;

  /// Creates a wizard footer.
  const SecAcntWizardFooter({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    if (buttonLabel.isEmpty) {
      return SizedBox(height: responsive.safeBottom + responsive.dp(12));
    }

    return BottomActionBar(
      padding: EdgeInsets.fromLTRB(
        responsive.dp(20),
        responsive.dp(12),
        responsive.dp(20),
        responsive.safeBottom + responsive.dp(12),
      ),
      child: PrimaryButton(
        label: buttonLabel,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
