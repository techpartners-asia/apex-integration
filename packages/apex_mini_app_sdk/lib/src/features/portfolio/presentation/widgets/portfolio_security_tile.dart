part of 'portfolio_holdings_widgets.dart';

class PortfolioSecurityTile extends StatefulWidget {
  final PortfolioSecurity security;
  final String currency;
  final SdkLocalizations l10n;
  final Color? color;
  final LinearGradient? gradient;

  const PortfolioSecurityTile({
    super.key,
    required this.security,
    required this.currency,
    required this.l10n,
    this.color,
    this.gradient,
  });

  @override
  State<PortfolioSecurityTile> createState() => _PortfolioSecurityTileState();
}

class _PortfolioSecurityTileState extends State<PortfolioSecurityTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final PortfolioSecurity security = widget.security;
    final double yieldPercent = security.percent ?? 0;
    final bool isPositive = yieldPercent >= 0;
    final Color toneColor = isPositive ? DesignTokens.success : DesignTokens.danger;
    final String displayName = '${security.securityCode} ${_portfolioSecurityTypeLabel(security.securityType, upper: true)}'.trim();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.dp(8)),
      child: AdaptiveCard(
        color: Colors.transparent,
        // hasShadow: true,
        padding: EdgeInsets.all(responsive.dp(16)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: responsive.dp(24),
                  height: responsive.dp(24),
                  decoration: BoxDecoration(
                    color: widget.color,
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(responsive.radius(5)),
                  ),
                  // child: Center(
                  //   child: CustomText(
                  //     security.securityCode.length >= 3 ? security.securityCode.substring(0, 3) : security.securityCode,
                  //     variant: MiniAppTextVariant.caption2,
                  //     color: DesignTokens.ink,
                  //   ),
                  // ),
                ),
                SizedBox(width: responsive.dp(12)),
                Expanded(
                  child: CustomText(
                    displayName,
                    variant: MiniAppTextVariant.subtitle3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: responsive.dp(8)),
                _YieldBadge(
                  yieldPercent: yieldPercent,
                  toneColor: toneColor,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              reverseDuration: const Duration(milliseconds: 180),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? _SecurityDetails(
                      security: security,
                      currency: widget.currency,
                      l10n: widget.l10n,
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(height: responsive.dp(15)),
            Align(
              alignment: Alignment.centerLeft,
              child: _DetailsToggle(
                isExpanded: _expanded,
                label: widget.l10n.commonViewDetails,
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YieldBadge extends StatelessWidget {
  final double yieldPercent;
  final Color toneColor;

  const _YieldBadge({
    required this.yieldPercent,
    required this.toneColor,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final bool isPositive = yieldPercent >= 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(8),
        vertical: responsive.dp(4),
      ),
      decoration: BoxDecoration(
        color: toneColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: CustomText(
        '${isPositive ? '+' : ''}${yieldPercent.toStringAsFixed(1)}%',
        variant: MiniAppTextVariant.caption2,
        color: toneColor,
      ),
    );
  }
}

class _SecurityDetails extends StatelessWidget {
  final PortfolioSecurity security;
  final String currency;
  final SdkLocalizations l10n;

  const _SecurityDetails({
    required this.security,
    required this.currency,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.only(top: responsive.dp(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PortfolioCompactMetricTile(
            label: l10n.ipsPortfolioHoldingValueLabel,
            value: formatIpsPaymentAmount(security.currentPrice ?? 0, currency, showDecimal: true),
            showHorizontal: true,
          ),
          SizedBox(height: responsive.dp(10)),
          PortfolioCompactMetricTile(
            label: l10n.ipsPortfolioHoldingQuantity,
            value: '${(security.qty ?? 0).toStringAsFixed(2)} ш',
            showHorizontal: true,
          ),
        ],
      ),
    );
  }
}

class _DetailsToggle extends StatelessWidget {
  final bool isExpanded;
  final String label;
  final VoidCallback onPressed;

  const _DetailsToggle({
    required this.isExpanded,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppAdaptivePressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.dp(2),
          vertical: responsive.dp(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomText(
              label,
              variant: MiniAppTextVariant.caption1,
              color: DesignTokens.muted,
            ),
            SizedBox(width: responsive.dp(4)),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: responsive.dp(16),
                color: DesignTokens.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
