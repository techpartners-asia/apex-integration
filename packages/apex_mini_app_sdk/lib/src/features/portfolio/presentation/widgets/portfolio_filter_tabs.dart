part of 'portfolio_holdings_widgets.dart';

class PortfolioFilterTabs extends StatelessWidget {
  final int selectedFilter;
  final ValueChanged<int> onChanged;
  final SdkLocalizations l10n;

  const PortfolioFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final List<String> labels = <String>[
      l10n.ipsPortfolioFilterAll,
      l10n.ipsPortfolioFilterBonds,
      l10n.ipsPortfolioFilterStocks,
    ];
    final double horizontalGap = responsive.dp(8);

    return Container(
      padding: EdgeInsets.all(responsive.dp(4)),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double sliderWidth =
              (constraints.maxWidth - (horizontalGap * 2)) / labels.length;

          return SizedBox(
            height: responsive.dp(46),
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  alignment: _selectedAlignment,
                  child: Container(
                    width: sliderWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        responsive.radius(14),
                      ),
                      border: Border.all(color: const Color(0xFFD9DCE3)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: responsive.dp(10),
                          offset: Offset(0, responsive.dp(2)),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    for (int index = 0; index < labels.length; index++) ...[
                      if (index > 0) SizedBox(width: horizontalGap),
                      Expanded(
                        child: _PortfolioFilterTabButton(
                          label: labels[index],
                          isSelected: selectedFilter == index,
                          onTap: () => onChanged(index),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Alignment get _selectedAlignment {
    return switch (selectedFilter) {
      1 => Alignment.center,
      2 => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };
  }
}

class _PortfolioFilterTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PortfolioFilterTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.radius(14)),
        onTap: onTap,
        child: SizedBox(
          height: double.infinity,
          child: Center(
            child: CustomText(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              variant: isSelected
                  ? MiniAppTextVariant.subtitle3
                  : MiniAppTextVariant.caption1,
              color: isSelected ? DesignTokens.ink : DesignTokens.muted,
            ),
          ),
        ),
      ),
    );
  }
}
