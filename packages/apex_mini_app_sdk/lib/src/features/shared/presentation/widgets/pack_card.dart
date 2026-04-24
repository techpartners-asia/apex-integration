import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PackCard extends StatelessWidget {
  // final String title;
  // final String subtitle;
  // final String allocation;
  // final bool recommended;
  // final String? headerLabel;
  final IpsPack pack;

  const PackCard({super.key, required this.pack});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      height: responsive.dp(responsive.width / 1.5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: DesignTokens.cardRadius,
          image: DecorationImage(
            image: AssetImage(
              pack.isRecommended == 1 ? Img.pack1 : Img.pack2,
              package: 'mini_app_sdk',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomText(
                pack.name,
                variant: MiniAppTextVariant.body,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              // SizedBox(height: responsive.spacing.inlineSpacing * 0.2),
              CustomText(
                pack.packDesc ?? '',
                variant: MiniAppTextVariant.title,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              // SizedBox(height: responsive.spacing.inlineSpacing * 0.2),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: responsive.insetsSymmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: CustomText(
                  context.l10n.ipsPackAllocationValue(
                    pack.bondPercent.toStringAsFixed(0),
                    pack.stockPercent.toStringAsFixed(0),
                  ),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: MiniAppTypography.regular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
