part of 'portfolio_holdings_widgets.dart';

/// Expandable security holding row in the portfolio holdings list.
class PortfolioSecurityTile extends StatefulWidget {
  /// Security/holding to display.
  final PortfolioSecurity security;

  /// Currency used for amount formatting.
  final String currency;

  /// Localized labels used inside the tile.
  final SdkLocalizations l10n;

  /// Optional solid color for the leading swatch.
  final Color? color;

  /// Optional gradient for the leading swatch.
  final LinearGradient? gradient;

  /// Creates a portfolio security tile.
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

/// Tracks whether the holding detail rows are expanded.
class _PortfolioSecurityTileState extends State<PortfolioSecurityTile> {
  /// Whether close-price details are visible.
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final PortfolioSecurity security = widget.security;
    final double yieldPercent = security.percent ?? 0;
    final bool isPositive = yieldPercent >= 0;
    final Color toneColor = isPositive
        ? DesignTokens.success
        : DesignTokens.danger;
    final String displayName =
        '${security.securityCode} ${_portfolioSecurityTypeLabel(security.securityType, upper: true)}'
            .trim();

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
            _SecurityDetails(
              security: security,
              currency: widget.currency,
              l10n: widget.l10n,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              reverseDuration: const Duration(milliseconds: 180),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 3,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: (security.closePrices ?? [])
                            .map(
                              (el) => _SecurityClosedPriceWidget(
                                closedPrice: el,
                                currency: widget.currency,
                                l10n: widget.l10n,
                              ),
                            )
                            .toList(),
                      ),
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

/// Percentage badge for holding yield/profit.
class _YieldBadge extends StatelessWidget {
  /// Yield percentage value.
  final double yieldPercent;

  /// Positive/negative tone color.
  final Color toneColor;

  /// Creates a yield badge.
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

/// Compact metrics shown for a portfolio security.
class _SecurityDetails extends StatelessWidget {
  /// Security data to render.
  final PortfolioSecurity security;

  /// Currency used for amount formatting.
  final String currency;

  /// Localized labels.
  final SdkLocalizations l10n;

  /// Creates security detail metrics.
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
            value: formatIpsPaymentAmount(
              security.currentPrice ?? 0,
              currency,
              showDecimal: true,
            ),
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

/// One historical close-price row for an expanded security tile.
class _SecurityClosedPriceWidget extends StatelessWidget {
  /// Historical close-price point.
  final PortfolioClosePrice closedPrice;

  /// Currency used for price formatting.
  final String currency;

  /// Localized labels.
  final SdkLocalizations l10n;

  /// Creates a closed-price row.
  const _SecurityClosedPriceWidget({
    required this.closedPrice,
    required this.currency,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.only(top: responsive.dp(10)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: PortfolioCompactMetricTile(
              label: l10n.closedPrice,
              value: formatIpsPaymentAmount(
                closedPrice.closePrice,
                currency,
                showDecimal: true,
              ),
              showHorizontal: false,
              variant: MiniAppTextVariant.caption1,
            ),
          ),
          // SizedBox(height: responsive.dp(10)),
          Expanded(
            child: PortfolioCompactMetricTile(
              label: l10n.closedDate,
              value: (DateTimeFormatter.toDateTime(
                closedPrice.tradeDate ?? DateTime.now(),
              )),
              // showHorizontal: true,
              variant: MiniAppTextVariant.caption1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Expand/collapse control for security detail rows.
class _DetailsToggle extends StatelessWidget {
  /// Whether the tile is currently expanded.
  final bool isExpanded;

  /// Control label.
  final String label;

  /// Toggle callback.
  final VoidCallback onPressed;

  /// Creates a details toggle.
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
