import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PackCard extends StatelessWidget {
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
                '${context.l10n.ipsPortfolioTitle} ${pack.packCode}',
                variant: MiniAppTextVariant.subtitle3,
                color: Colors.white,
              ),
              SizedBox(height: AppSpacing.xs),
              CustomText(
                pack.name,
                variant: MiniAppTextVariant.subtitle2,
                color: Colors.white,
              ),
              SizedBox(height: AppSpacing.xs),
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
                  variant: MiniAppTextVariant.buttonMedium,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
