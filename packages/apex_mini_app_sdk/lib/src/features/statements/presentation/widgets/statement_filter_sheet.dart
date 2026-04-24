import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class StatementFilterSheet extends StatefulWidget {
  const StatementFilterSheet({super.key});

  @override
  State<StatementFilterSheet> createState() => _StatementFilterSheetState();
}

class _StatementFilterSheetState extends State<StatementFilterSheet> {
  RangeValues _amountRange = const RangeValues(0, 1000000);
  int _selectedDateFilter = 0;

  int get _activeFilterCount {
    int count = 0;
    if (_amountRange.start > 0 || _amountRange.end < 1000000) count++;
    if (_selectedDateFilter > 0) count++;
    return count;
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
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
              min: 0,
              max: 1000000,
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
                  variant: MiniAppTextVariant.caption,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DesignTokens.muted,
                  ),
                ),
                CustomText(
                  "${_amountRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}'")}₮",
                  variant: MiniAppTextVariant.caption,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DesignTokens.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          CustomText(
            l10n.ipsStatementFilterDateTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
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
                      _amountRange = const RangeValues(0, 1000000);
                      _selectedDateFilter = 0;
                    });
                  },
                ),
              ),
              SizedBox(width: responsive.dp(12)),
              Expanded(
                child: PrimaryButton(
                  label: l10n.ipsStatementFilterSearch(_activeFilterCount),
                  onPressed: () => Navigator.pop(context),
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
              color: isSelected
                  ? DesignTokens.ink
                  : DesignTokens.border,
            ),
          ),
          child: Center(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.caption,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : DesignTokens.ink,
                fontWeight: MiniAppTypography.semiBold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
