import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class RechargeQuantityInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final bool unfocusOnTapOutside;

  const RechargeQuantityInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.unfocusOnTapOutside = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      width: double.infinity,
      height: responsive.dp(96),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.unspecified,
          showCursor: true,
          onTap: () => focusNode.requestFocus(),
          onTapOutside: unfocusOnTapOutside
              ? (_) => FocusScope.of(context).unfocus()
              : null,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: MiniAppTypography.h3.copyWith(
            color: DesignTokens.ink,
            height: 1.2,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class RechargePricingSummaryCard extends StatelessWidget {
  final IpsRechargeState state;

  const RechargePricingSummaryCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final String currency = state.currency;

    return Container(
      padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IpsDetailRow(
            label: l10n.ipsContractUnitPrice,
            value: formatIpsPaymentAmount(state.unitPrice, currency),
          ),
          IpsDetailRow(
            label: l10n.ipsContractServiceFee,
            value: formatIpsPaymentAmount(state.serviceFee, currency),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.spacing.inlineSpacing * 0.3,
            ),
            child: CustomPaint(
              painter: RechargeDashedLinePainter(
                color: DesignTokens.border,
              ),
              size: const Size(double.infinity, 1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.spacing.inlineSpacing * 0.7,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CustomText(
                    '${l10n.ipsPaymentRechargeTotalAmount}:',
                    variant: MiniAppTextVariant.subtitle3,
                    color: DesignTokens.ink,
                  ),
                ),
                CustomText(
                  formatIpsPaymentAmount(state.totalPayable, currency),
                  variant: MiniAppTextVariant.subtitle2,
                  color: DesignTokens.ink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RechargeDashedLinePainter extends CustomPainter {
  const RechargeDashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(RechargeDashedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}
