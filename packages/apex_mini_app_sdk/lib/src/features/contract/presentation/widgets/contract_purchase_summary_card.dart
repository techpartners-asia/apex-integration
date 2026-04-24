import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ContractPurchaseSummaryCard extends StatelessWidget {
  final String title;
  final int quantity;
  final String quantityPrompt;
  final String unitPriceLabel;
  final String serviceFeeLabel;
  final String totalLabel;
  final double unitPrice;
  final double serviceFee;
  final double totalPayable;
  final String currency;

  const ContractPurchaseSummaryCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.quantityPrompt,
    required this.unitPriceLabel,
    required this.serviceFeeLabel,
    required this.totalLabel,
    required this.unitPrice,
    required this.serviceFee,
    required this.totalPayable,
    this.currency = 'MNT',
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppSurfaceCard(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomText(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
              color: DesignTokens.ink,
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              CustomText(
                quantity.toString(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                  color: DesignTokens.ink,
                  height: 1,
                ),
              ),
              SizedBox(width: responsive.spacing.inlineSpacing * 0.35),
              Padding(
                padding: EdgeInsets.only(
                  bottom: responsive.spacing.inlineSpacing * 0.2,
                ),
                child: CustomText(
                  context.l10n.commonPackUnit,
                  variant: MiniAppTextVariant.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: DesignTokens.muted,
                    fontWeight: MiniAppTypography.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing.inlineSpacing),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.spacing.inlineSpacing,
            ),
            child: CustomText(
              quantityPrompt,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: DesignTokens.muted),
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          Divider(color: DesignTokens.border, height: 1),
          SizedBox(height: responsive.spacing.inlineSpacing),
          IpsDetailRow(
            label: unitPriceLabel,
            value: formatIpsPaymentAmount(unitPrice, currency),
          ),
          IpsDetailRow(
            label: serviceFeeLabel,
            value: formatIpsPaymentAmount(serviceFee, currency),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.spacing.inlineSpacing * 0.45,
            ),
            child: Divider(color: DesignTokens.border, height: 1),
          ),
          IpsDetailRow(
            label: totalLabel,
            valueWidget: CustomText(
              formatIpsPaymentAmount(totalPayable, currency),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DesignTokens.ink,
                fontWeight: MiniAppTypography.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
