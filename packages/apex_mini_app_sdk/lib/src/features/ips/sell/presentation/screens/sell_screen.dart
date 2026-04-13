import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_pack.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_sell_cubit.dart';
import '../../application/ips_sell_state.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsSellCubit, IpsSellState>(
      builder: (BuildContext context, IpsSellState state) {
        if (state.isSuccess) {
          return _SellSuccessView(state: state);
        }
        return _SellRequestView(state: state);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Request view
// ---------------------------------------------------------------------------

class _SellRequestView extends StatelessWidget {
  const _SellRequestView({required this.state});

  final IpsSellState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InvestXPageScaffold(
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
                  if (state.pack case final IpsPack pack)
                    InvestXPackCard(pack: pack),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                  InvestXReminderCard(
                    title: l10n.ipsOverviewDashboardReminderTitle,
                    message: l10n.ipsSellReminderBody,
                  ),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                  _AmountSummaryCard(state: state),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                ],
              ),
            ),
          ),
          _BottomAction(state: state),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Amount summary card
// ---------------------------------------------------------------------------

class _AmountSummaryCard extends StatefulWidget {
  final IpsSellState state;

  const _AmountSummaryCard({required this.state});

  @override
  State<_AmountSummaryCard> createState() => _AmountSummaryCardState();
}

class _AmountSummaryCardState extends State<_AmountSummaryCard> {
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
        borderRadius: InvestXDesignTokens.cardRadius,
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
          _BoldDetailRow(
            label: state.totalAmount > 0
                ? l10n.ipsSellTotalAmount
                : l10n.ipsSellTotalAmount,
            value: formatIpsPaymentAmount(state.totalAmount, currency),
          ),

          // Dashed separator
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: _DashedLinePainter(color: InvestXDesignTokens.border),
              size: const Size(double.infinity, 1),
            ),
          ),

          // Profit row (green)
          _HighlightDetailRow(
            label: '${l10n.ipsSellProfit}:',
            value: formatIpsPaymentAmount(state.profit, currency),
            valueColor: InvestXDesignTokens.successStrong,
          ),

          // Dashed separator
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: _DashedLinePainter(color: InvestXDesignTokens.border),
              size: const Size(double.infinity, 1),
            ),
          ),

          // Fee row (expandable)
          GestureDetector(
            onTap: () => setState(() => _feeExpanded = !_feeExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CustomText(
                      l10n.ipsSellTotalFee,
                      variant: MiniAppTextVariant.bodySmall,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: InvestXDesignTokens.ink,
                        fontWeight: MiniAppTypography.regular,
                      ),
                    ),
                  ),
                  CustomText(
                    formatIpsPaymentAmount(state.totalFee, currency),
                    variant: MiniAppTextVariant.body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: InvestXDesignTokens.ink,
                      fontWeight: MiniAppTypography.bold,
                    ),
                  ),
                  SizedBox(width: responsive.dp(4)),
                  AnimatedRotation(
                    turns: _feeExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: responsive.dp(20),
                      color: InvestXDesignTokens.muted,
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

          // Dashed separator
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomPaint(
              painter: _DashedLinePainter(color: InvestXDesignTokens.border),
              size: const Size(double.infinity, 1),
            ),
          ),

          // Payout row (bold, large)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CustomText(
                    '${l10n.ipsSellPayoutAmount}:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: InvestXDesignTokens.ink,
                      fontWeight: MiniAppTypography.semiBold,
                    ),
                  ),
                ),
                CustomText(
                  formatIpsPaymentAmount(state.payoutAmount, currency),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: InvestXDesignTokens.ink,
                    fontWeight: MiniAppTypography.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper rows
// ---------------------------------------------------------------------------

class _BoldDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _BoldDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: InvestXDesignTokens.ink,
                fontWeight: MiniAppTypography.regular,
              ),
            ),
          ),
          CustomText(
            value,
            variant: MiniAppTextVariant.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: InvestXDesignTokens.ink,
              fontWeight: MiniAppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _HighlightDetailRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomText(
              label,
              variant: MiniAppTextVariant.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: MiniAppTypography.regular,
              ),
            ),
          ),
          CustomText(
            value,
            variant: MiniAppTextVariant.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: MiniAppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashed line painter
// ---------------------------------------------------------------------------

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

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
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}

// ---------------------------------------------------------------------------
// Bottom action bar
// ---------------------------------------------------------------------------

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.state});

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
                variant: MiniAppTextVariant.bodySmall,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: InvestXDesignTokens.danger,
                ),
              ),
            ),
          InvestXPrimaryButton(
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

// ---------------------------------------------------------------------------
// Success view
// ---------------------------------------------------------------------------

class _SellSuccessView extends StatelessWidget {
  const _SellSuccessView({required this.state});

  final IpsSellState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return InvestXPageScaffold(
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

                    // Green checkmark
                    Center(
                      child: Container(
                        width: responsive.dp(72),
                        height: responsive.dp(72),
                        decoration: const BoxDecoration(
                          color: InvestXDesignTokens.successStrong,
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

                    // Title
                    CustomText(
                      l10n.ipsSellSuccessTitle,
                      variant: MiniAppTextVariant.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: MiniAppTypography.bold,
                      ),
                    ),
                    SizedBox(height: responsive.spacing.sectionSpacing * 1.5),

                    // Reminder card
                    InvestXReminderCard(
                      title: l10n.ipsOverviewDashboardReminderTitle,
                      message: l10n.ipsSellSuccessBody,
                    ),
                    SizedBox(height: responsive.spacing.sectionSpacing),
                  ],
                ),
              ),
            ),

            // Go home button
            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.spacing.financialCardSpacing,
                responsive.spacing.inlineSpacing,
                responsive.spacing.financialCardSpacing,
                responsive.spacing.inlineSpacing,
              ),
              child: InvestXPrimaryButton(
                label: l10n.commonGoHome,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
