import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Quick action grid shown on the portfolio screen.
class PortfolioQuickActionsSection extends StatelessWidget {
  /// Creates the portfolio quick action section.
  const PortfolioQuickActionsSection({
    super.key,
    required this.portfolioContext,
    required this.l10n,
  });

  /// Portfolio context passed to statements.
  final SdkPortfolioContext portfolioContext;

  /// Localized labels used by the action tiles.
  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: l10n.ipsHomeNextStepsTitle,
      subtitle: l10n.ipsHomeNextStepsSubtitle,
      children: <Widget>[
        AdaptiveWrap(
          phoneColumns: 1,
          tabletColumns: 2,
          largeTabletColumns: 2,
          children: <Widget>[
            IpsQuickActionTile(
              title: l10n.ipsPortfolioRecharge,
              subtitle: l10n.ipsPaymentRechargeSubtitle,
              icon: Icons.add_card_rounded,
              emphasized: true,
              onTap: () => launchIpsRoute(
                context,
                route: MiniAppRoutes.recharge,
              ),
            ),
            IpsQuickActionTile(
              title: l10n.ipsPortfolioSellOrder,
              subtitle: l10n.ipsSellSubtitle,
              icon: Icons.trending_down_rounded,
              onTap: () => launchIpsRoute(context, route: MiniAppRoutes.sell),
            ),
            IpsQuickActionTile(
              title: l10n.ipsPortfolioOrderList,
              subtitle: l10n.ipsOrdersSubtitle,
              icon: Icons.receipt_long_outlined,
              onTap: () => launchIpsRoute(
                context,
                route: MiniAppRoutes.orders,
              ),
            ),
            IpsQuickActionTile(
              title: l10n.ipsPortfolioStatements,
              subtitle: l10n.ipsStatementSubtitle,
              icon: Icons.summarize_outlined,
              onTap: () => launchIpsRoute(
                context,
                route: MiniAppRoutes.statements,
                arguments: portfolioContext,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
