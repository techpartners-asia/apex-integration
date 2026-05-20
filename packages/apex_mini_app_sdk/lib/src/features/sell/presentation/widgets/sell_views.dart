import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Request-state view for confirming a pack sell operation.
class SellRequestView extends StatelessWidget {
  /// Creates the sell request confirmation view.
  const SellRequestView({super.key, required this.state});

  /// Current sell flow state.
  final IpsSellState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CustomScaffold(
      appBarTitle: l10n.ipsSellCloseTitle,
      showCloseButton: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive.spacing.financialCardSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                  if (state.pack case final IpsPack pack) PackCard(pack: pack),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                  ReminderCard(
                    title: l10n.ipsOverviewDashboardReminderTitle,
                    message: l10n.ipsSellReminderBody,
                  ),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                  SellAmountSummaryCard(state: state),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                ],
              ),
            ),
          ),
          SellBottomAction(state: state),
        ],
      ),
    );
  }
}

/// Pricing and payout summary card for a sell request.
class SellAmountSummaryCard extends StatefulWidget {
  /// Current sell flow state used to render all amount rows.
  final IpsSellState state;

  /// Creates the sell amount summary card.
  const SellAmountSummaryCard({super.key, required this.state});

  @override
  State<SellAmountSummaryCard> createState() => _SellAmountSummaryCardState();
}

/// Tracks whether fee breakdown rows are expanded.
class _SellAmountSummaryCardState extends State<SellAmountSummaryCard> {
  /// Whether fee detail rows are visible.
  bool _feeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final IpsSellState state = widget.state;
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
            label: '${l10n.ipsContractUnitPrice}:',
            value: formatIpsPaymentAmount(state.unitPrice, currency),
          ),
          IpsDetailRow(
            label: '${l10n.ipsSellQuantityClosing}:',
            value: state.packQty.toString(),
          ),
          SellBoldDetailRow(
            label: l10n.ipsSellTotalAmount,
            value: formatIpsPaymentAmount(state.totalAmount, currency),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: SellDashedLinePainter(color: DesignTokens.border),
              size: const Size(double.infinity, 1),
            ),
          ),
          SellHighlightDetailRow(
            label: '${l10n.ipsSellProfit}:',
            value: formatIpsPaymentAmount(state.profit, currency),
            valueColor: DesignTokens.successStrong,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: SellDashedLinePainter(color: DesignTokens.border),
              size: const Size(double.infinity, 1),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _feeExpanded = !_feeExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CustomText(
                      l10n.ipsSellTotalFee,
                      variant: MiniAppTextVariant.body2,
                      color: DesignTokens.ink,
                    ),
                  ),
                  CustomText(
                    formatIpsPaymentAmount(state.totalFee, currency),
                    variant: MiniAppTextVariant.subtitle2,
                    color: DesignTokens.ink,
                  ),
                  SizedBox(width: responsive.dp(4)),
                  AnimatedRotation(
                    turns: _feeExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: responsive.dp(20),
                      color: DesignTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(left: responsive.dp(12), bottom: 5),
              child: IpsDetailRow(
                label: '${l10n.ipsContractServiceFee}:',
                value: formatIpsPaymentAmount(state.serviceFee, currency),
              ),
            ),
            crossFadeState: _feeExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: SellDashedLinePainter(color: DesignTokens.border),
              size: const Size(double.infinity, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CustomText(
                    '${l10n.ipsSellPayoutAmount}:',
                    variant: MiniAppTextVariant.subtitle2,
                    color: DesignTokens.ink,
                  ),
                ),
                CustomText(
                  formatIpsPaymentAmount(state.payoutAmount, currency),
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

/// Bold label/value row used for important sell totals.
class SellBoldDetailRow extends StatelessWidget {
  /// Row label.
  final String label;

  /// Row value.
  final String value;

  /// Creates a bold sell detail row.
  const SellBoldDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.body2,
              color: DesignTokens.ink,
            ),
          ),
          CustomText(
            value,
            variant: MiniAppTextVariant.subtitle2,
            color: DesignTokens.ink,
          ),
        ],
      ),
    );
  }
}

/// Highlighted label/value row used for profit or status amounts.
class SellHighlightDetailRow extends StatelessWidget {
  /// Row label.
  final String label;

  /// Row value.
  final String value;

  /// Text color for both label and value.
  final Color valueColor;

  /// Creates a highlighted sell detail row.
  const SellHighlightDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.body2,
              color: valueColor,
            ),
          ),
          CustomText(
            value,
            variant: MiniAppTextVariant.subtitle2,
            color: valueColor,
          ),
        ],
      ),
    );
  }
}

/// Painter for dashed dividers in sell amount summaries.
class SellDashedLinePainter extends CustomPainter {
  /// Dash color.
  final Color color;

  /// Creates a dashed-line painter for sell summaries.
  const SellDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 10;
    const double dashSpace = 10;
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
  bool shouldRepaint(SellDashedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}

/// Bottom action area for sell request submission.
class SellBottomAction extends StatelessWidget {
  /// Creates the sell flow bottom action area.
  const SellBottomAction({super.key, required this.state});

  /// Current sell flow state.
  final IpsSellState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.spacing.financialCardSpacing,
        responsive.spacing.inlineSpacing,
        responsive.spacing.financialCardSpacing,
        responsive.spacing.inlineSpacing,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (state.errorMessage case final String error)
            Padding(
              padding: EdgeInsets.only(
                bottom: responsive.spacing.inlineSpacing,
              ),
              child: CustomText(
                error,
                variant: MiniAppTextVariant.caption1,
                textAlign: TextAlign.center,
                color: DesignTokens.danger,
              ),
            ),
          PrimaryButton(
            label: state.isSubmitting
                ? l10n.commonLoading
                : l10n.ipsSellSubmitRequest,
            onPressed: state.canSubmit
                ? context.read<IpsSellCubit>().submit
                : null,
          ),
        ],
      ),
    );
  }
}

/// Success-state view shown after a sell request is submitted.
class SellSuccessView extends StatelessWidget {
  /// Creates the sell success view.
  const SellSuccessView({super.key, required this.state});

  /// Current sell flow state.
  final IpsSellState state;

  /// Refreshes packs and navigates back to pack selection after success.
  Future<void> _goToPackList(BuildContext context) async {
    final List<IpsPack>? packs = await context
        .read<IpsSellCubit>()
        .refreshPacksAfterSuccess();
    if (!context.mounted || packs == null) {
      return;
    }

    await replaceIpsRoute(
      context,
      route: MiniAppRoutes.packs,
      arguments: packs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return CustomScaffold(
      hasAppBar: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing.financialCardSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: responsive.spacing.sectionSpacing * 3),
                    Center(
                      child: Container(
                        width: responsive.dp(72),
                        height: responsive.dp(72),
                        decoration: const BoxDecoration(
                          color: DesignTokens.successStrong,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: responsive.dp(40),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.spacing.sectionSpacing),
                    CustomText(
                      l10n.ipsSellSuccessTitle,
                      variant: MiniAppTextVariant.title1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
                    ReminderCard(
                      title: l10n.ipsOverviewDashboardReminderTitle,
                      message: l10n.ipsSellSuccessBody,
                    ),
                    SizedBox(height: responsive.spacing.sectionSpacing),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.spacing.financialCardSpacing,
                responsive.spacing.inlineSpacing,
                responsive.spacing.financialCardSpacing,
                responsive.spacing.inlineSpacing,
              ),
              child: PrimaryButton(
                label: state.isRefreshingPacks
                    ? l10n.commonLoading
                    : l10n.commonGoHome,
                onPressed: state.canCompleteSuccessFlow
                    ? () => _goToPackList(context)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
