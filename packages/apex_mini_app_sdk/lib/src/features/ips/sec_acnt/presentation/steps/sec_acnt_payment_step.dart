import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/images/images.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';

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
    final ThemeData theme = Theme.of(context);
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
        Text(
          l10n.secAcntPaymentTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: InvestXDesignTokens.ink,
            fontWeight: MiniAppTypography.bold,
            height: 1.25,
          ),
        ),
        SizedBox(height: responsive.dp(22)),
        _PaymentInfoCard(
          icon: hasError
              ? Icons.error_outline_rounded
              : Icons.priority_high_rounded,
          iconColor: hasError
              ? InvestXDesignTokens.danger
              : const Color(0xFFF29A2E),
          iconBackground: hasError
              ? const Color(0xFFFCE7EA)
              : const Color(0xFFFFF0DD),
          message: hasError
              ? errorMessage!.trim()
              : hasAmount
              ? l10n.secAcntPaymentNoticeMessage
              : l10n.secAcntPaymentAmountUnavailable,
          textColor: hasError
              ? InvestXDesignTokens.danger
              : InvestXDesignTokens.ink,
        ),
        if (hasAmount) ...<Widget>[
          SizedBox(height: responsive.space(AppSpacing.lg)),
          Padding(
            padding: responsive.insetsSymmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: <Widget>[
                CustomText(
                  l10n.commonTotalPayable,
                  variant: MiniAppTextVariant.body,
                  color: InvestXDesignTokens.muted,
                ),
                const Spacer(),
                CustomText(
                  amountLabel!,
                  variant: MiniAppTextVariant.titleLarge,
                  // style: theme.textTheme.titleLarge?.copyWith(
                  //   color: InvestXDesignTokens.ink,
                  //   fontWeight: MiniAppTypography.bold,
                  // ),
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
            backgroundColor: InvestXDesignTokens.border,
            color: InvestXDesignTokens.rose,
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
    final ThemeData theme = Theme.of(context);

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
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
