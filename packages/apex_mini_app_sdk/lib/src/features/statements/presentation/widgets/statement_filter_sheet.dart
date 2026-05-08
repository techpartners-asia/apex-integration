import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class StatementFilterSheet extends StatefulWidget {
  final IpsStatementFilter initialFilter;
  final ValueChanged<IpsStatementFilter>? onApply;
  final VoidCallback? onClear;

  const StatementFilterSheet({
    super.key,
    this.initialFilter = const IpsStatementFilter(),
    this.onApply,
    this.onClear,
  });

  @override
  State<StatementFilterSheet> createState() => _StatementFilterSheetState();
}

class _StatementFilterSheetState extends State<StatementFilterSheet> {
  late RangeValues _amountRange;
  late int _selectedDateFilter;

  IpsStatementFilter get _currentFilter {
    return IpsStatementFilter(
      minAmount: _amountRange.start,
      maxAmount: _amountRange.end,
      dateFilter: IpsStatementDateFilter.values[_selectedDateFilter],
    );
  }

  @override
  void initState() {
    super.initState();
    final double initialStart = widget.initialFilter.minAmount
        .clamp(
          IpsStatementFilter.defaultMinAmount,
          IpsStatementFilter.defaultMaxAmount,
        )
        .toDouble();
    final double initialEnd = widget.initialFilter.maxAmount
        .clamp(
          IpsStatementFilter.defaultMinAmount,
          IpsStatementFilter.defaultMaxAmount,
        )
        .toDouble();
    _amountRange = RangeValues(
      initialStart <= initialEnd ? initialStart : initialEnd,
      initialStart <= initialEnd ? initialEnd : initialStart,
    );
    _selectedDateFilter = widget.initialFilter.dateFilter.index;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(responsive.radius(24)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        responsive.spacing.financialCardSpacing,
        responsive.dp(16),
        responsive.spacing.financialCardSpacing,
        responsive.safeBottom + responsive.dp(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Spacer(),
              CustomText(
                l10n.ipsStatementFilterTitle,
                variant: MiniAppTextVariant.subtitle2,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: responsive.dp(30),
                  height: responsive.dp(30),
                  decoration: BoxDecoration(
                    color: DesignTokens.softSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: responsive.dp(16),
                    color: DesignTokens.ink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          CustomText(
            l10n.ipsStatementFilterAmountTitle,
            variant: MiniAppTextVariant.subtitle3,
          ),
          SizedBox(height: responsive.dp(12)),
          SliderTheme(
            data: SliderThemeData(
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: responsive.dp(10),
              ),
              activeTrackColor: DesignTokens.rose,
              inactiveTrackColor: DesignTokens.border,
              thumbColor: Colors.white,
              overlayColor: DesignTokens.rose.withValues(alpha: 0.12),
              trackHeight: responsive.dp(4),
            ),
            child: RangeSlider(
              values: _amountRange,
              min: IpsStatementFilter.defaultMinAmount,
              max: IpsStatementFilter.defaultMaxAmount,
              onChanged: (RangeValues values) {
                setState(() => _amountRange = values);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.dp(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomText(
                  '${_amountRange.start.toInt()}₮',
                  variant: MiniAppTextVariant.caption1,
                  color: DesignTokens.muted,
                ),
                CustomText(
                  "${_amountRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}'")}₮",
                  variant: MiniAppTextVariant.caption1,
                  color: DesignTokens.muted,
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          CustomText(
            l10n.ipsStatementFilterDateTitle,
            variant: MiniAppTextVariant.subtitle3,
          ),
          SizedBox(height: responsive.dp(12)),
          Row(
            children: <Widget>[
              _DateFilterChip(
                label: l10n.ipsStatementFilterToday,
                isSelected: _selectedDateFilter == 1,
                onTap: () => setState(() {
                  _selectedDateFilter = _selectedDateFilter == 1 ? 0 : 1;
                }),
              ),
              SizedBox(width: responsive.dp(8)),
              _DateFilterChip(
                label: l10n.ipsStatementFilterWeek,
                isSelected: _selectedDateFilter == 2,
                onTap: () => setState(() {
                  _selectedDateFilter = _selectedDateFilter == 2 ? 0 : 2;
                }),
              ),
              SizedBox(width: responsive.dp(8)),
              _DateFilterChip(
                label: l10n.ipsStatementFilterMonth,
                isSelected: _selectedDateFilter == 3,
                onTap: () => setState(() {
                  _selectedDateFilter = _selectedDateFilter == 3 ? 0 : 3;
                }),
              ),
              SizedBox(width: responsive.dp(8)),
              _DateFilterChip(
                label: l10n.ipsStatementFilter3Months,
                isSelected: _selectedDateFilter == 4,
                onTap: () => setState(() {
                  _selectedDateFilter = _selectedDateFilter == 4 ? 0 : 4;
                }),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryButton(
                  label: l10n.ipsStatementFilterClear,
                  onPressed: () {
                    setState(() {
                      _amountRange = const RangeValues(
                        IpsStatementFilter.defaultMinAmount,
                        IpsStatementFilter.defaultMaxAmount,
                      );
                      _selectedDateFilter = IpsStatementDateFilter.all.index;
                    });
                    widget.onClear?.call();
                  },
                ),
              ),
              SizedBox(width: responsive.dp(12)),
              Expanded(
                child: PrimaryButton(
                  label: l10n.ipsStatementFilterSearch(
                    _currentFilter.activeFilterCount,
                  ),
                  onPressed: () {
                    widget.onApply?.call(_currentFilter);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateFilterChip extends StatelessWidget {
  const _DateFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: responsive.dp(10)),
          decoration: BoxDecoration(
            color: isSelected ? DesignTokens.ink : Colors.white,
            borderRadius: BorderRadius.circular(responsive.radius(12)),
            border: Border.all(
              color: isSelected ? DesignTokens.ink : DesignTokens.border,
            ),
          ),
          child: Center(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.caption1,
              color: isSelected ? Colors.white : DesignTokens.ink,
            ),
          ),
        ),
      ),
    );
  }
}
