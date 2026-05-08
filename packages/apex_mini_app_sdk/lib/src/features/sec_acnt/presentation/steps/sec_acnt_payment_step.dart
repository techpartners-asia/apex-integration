import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntPaymentStep extends StatelessWidget {
  final String? errorMessage;
  final bool isSubmitting;
  final double payableAmount;

  const SecAcntPaymentStep({
    super.key,
    required this.errorMessage,
    required this.isSubmitting,
    required this.payableAmount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final bool hasAmount = payableAmount.isFinite && payableAmount > 0;
    final bool hasError =
        errorMessage != null && errorMessage!.trim().isNotEmpty;
    final String? amountLabel = hasAmount
        ? formatIpsPaymentAmount(payableAmount, 'MNT')
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: responsive.dp(14)),
        CustomImage(
          path: Img.key,
          width: responsive.dp(56),
          height: responsive.dp(56),
        ),
        SizedBox(height: responsive.dp(20)),
        CustomText(
          l10n.secAcntPaymentTitle,
          variant: MiniAppTextVariant.h8,
          color: DesignTokens.ink,
        ),
        SizedBox(height: responsive.dp(22)),
        _PaymentInfoCard(
          icon: hasError
              ? Icons.error_outline_rounded
              : Icons.priority_high_rounded,
          iconColor: hasError ? DesignTokens.danger : const Color(0xFFF29A2E),
          iconBackground: hasError
              ? const Color(0xFFFCE7EA)
              : const Color(0xFFFFF0DD),
          message: hasError
              ? errorMessage!.trim()
              : hasAmount
              ? l10n.secAcntPaymentNoticeMessage
              : l10n.secAcntPaymentAmountUnavailable,
          textColor: hasError ? DesignTokens.danger : DesignTokens.ink,
        ),
        if (hasAmount) ...<Widget>[
          SizedBox(height: responsive.space(AppSpacing.lg)),
          Padding(
            padding: responsive.insetsSymmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: <Widget>[
                CustomText(
                  l10n.commonTotalPayable,
                  variant: MiniAppTextVariant.body3,
                  color: DesignTokens.muted,
                ),
                const Spacer(),
                CustomText(
                  amountLabel!,
                  variant: MiniAppTextVariant.title1,
                ),
              ],
            ),
          ),
        ],
        if (isSubmitting) ...<Widget>[
          SizedBox(height: responsive.dp(20)),
          LinearProgressIndicator(
            minHeight: responsive.dp(4),
            borderRadius: BorderRadius.circular(responsive.radius(999)),
            backgroundColor: DesignTokens.border,
            color: DesignTokens.rose,
          ),
        ],
      ],
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  const _PaymentInfoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.message,
    required this.textColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      padding: responsive.insetsAll(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: responsive.dp(20),
            height: responsive.dp(20),
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: responsive.dp(14), color: iconColor),
          ),
          SizedBox(width: responsive.dp(12)),
          Expanded(
            child: CustomText(
              message,
              variant: MiniAppTextVariant.body3,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
