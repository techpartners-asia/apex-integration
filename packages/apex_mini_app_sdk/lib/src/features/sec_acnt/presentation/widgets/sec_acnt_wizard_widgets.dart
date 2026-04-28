import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntWizardHeaderData {
  final String? title;
  final bool showBack;
  final bool showClose;
  final bool highlightBrand;
  final bool centerTitle;
  final bool reserveLeadingSpace;
  final double bodyTopPadding;

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

class SecAcntWizardFooterData {
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool enabled;

  const SecAcntWizardFooterData({
    required this.buttonLabel,
    this.onPressed,
    this.enabled = true,
  });

  const SecAcntWizardFooterData.hidden()
    : buttonLabel = '',
      onPressed = null,
      enabled = false;
}

class SecAcntWizardHeader extends StatelessWidget {
  final String? title;
  final bool showBack;
  final bool showClose;
  final bool highlightBrand;
  final bool centerTitle;
  final bool reserveLeadingSpace;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const SecAcntWizardHeader({
    super.key,
    this.title,
    required this.showBack,
    required this.showClose,
    required this.highlightBrand,
    this.centerTitle = true,
    this.reserveLeadingSpace = true,
    required this.onBack,
    required this.onClose,
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
      onClose: onClose,
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

class SecAcntWizardFooter extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool enabled;

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
