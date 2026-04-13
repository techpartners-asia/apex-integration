import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../application/ips_recharge_cubit.dart';
import '../../application/ips_recharge_state.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../../shared/presentation/widgets/financial/financial.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsRechargeCubit, IpsRechargeState>(
      builder: (BuildContext context, IpsRechargeState state) {
        final l10n = context.l10n;

        if (state.paymentRes != null) {
          return _RechargeResultView(state: state);
        }

        return Theme(
          data: InvestXDesignTokens.theme(Theme.of(context)),
          child: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: InvestXDesignTokens.softSurface,
                resizeToAvoidBottomInset: true,
                appBar: InvestXAppBar(
                  title: l10n.ipsPaymentRechargeTitle,
                  showBackButton: false,
                  showCloseButton: true,
                  backgroundColor: InvestXDesignTokens.softSurface,
                  showBottomBorder: false,
                ),
                body: SafeArea(
                  child: _RechargeBody(
                    controller: _controller,
                    focusNode: _focusNode,
                    state: state,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _RechargeBody extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IpsRechargeState state;

  const _RechargeBody({
    required this.controller,
    required this.focusNode,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return Column(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing.financialCardSpacing,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: responsive.spacing.sectionSpacing * 2),

                          /// The quantity input
                          _QuantityInput(
                            controller: controller,
                            focusNode: focusNode,
                          ),
                          SizedBox(height: responsive.spacing.inlineSpacing),

                          /// The hint text
                          CustomText(
                            l10n.ipsPaymentRechargeQuantityHint,
                            variant: MiniAppTextVariant.bodySmall,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: InvestXDesignTokens.muted,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: responsive.spacing.sectionSpacing),
                        child: _PricingSummaryCard(state: state),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _BottomActionArea(state: state),
      ],
    );
  }
}

class _QuantityInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _QuantityInput({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontWeight: MiniAppTypography.bold,
        color: InvestXDesignTokens.ink,
        height: 1.2,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (String value) {
        context.read<IpsRechargeCubit>().updatePackQty(value);
      },
    );
  }
}

class _PricingSummaryCard extends StatelessWidget {
  final IpsRechargeState state;

  const _PricingSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
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
            label: l10n.ipsContractUnitPrice,
            value: formatIpsPaymentAmount(state.unitPrice, currency),
          ),
          IpsDetailRow(
            label: l10n.ipsContractServiceFee,
            value: formatIpsPaymentAmount(state.serviceFee, currency),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.spacing.inlineSpacing * 0.3,
            ),
            child: CustomPaint(
              painter: _DashedLinePainter(
                color: InvestXDesignTokens.border,
              ),
              size: const Size(double.infinity, 1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.spacing.inlineSpacing * 0.7,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CustomText(
                    '${l10n.ipsPaymentRechargeTotalAmount}:',
                    variant: MiniAppTextVariant.body,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: InvestXDesignTokens.ink,
                      fontWeight: MiniAppTypography.bold,
                    ),
                  ),
                ),
                CustomText(
                  formatIpsPaymentAmount(state.totalPayable, currency),
                  variant: MiniAppTextVariant.body,
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

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 4;
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
  bool shouldRepaint(_DashedLinePainter oldDelegate) => color != oldDelegate.color;
}

class _BottomActionArea extends StatelessWidget {
  final IpsRechargeState state;

  const _BottomActionArea({required this.state});

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
      child: InvestXPrimaryButton(
        label: state.isSubmitting ? l10n.commonLoading : l10n.commonPay,
        onPressed: state.canSubmit ? context.read<IpsRechargeCubit>().submit : null,
      ),
    );
  }
}

class _RechargeResultView extends StatelessWidget {
  const _RechargeResultView({required this.state});

  final IpsRechargeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InvestXPageScaffold(
      appBarTitle: l10n.ipsPaymentRechargeTitle,
      children: <Widget>[
        PaymentResState(res: state.paymentRes!),
        // if (state.paymentRes!.status == MiniAppPaymentStatus.success)
        //   if (state.refreshedOverview case final PortfolioOverview overview) ...<Widget>[
        //     SizedBox(
        //       height: context.responsive.spacing.sectionSpacing,
        //     ),
        //     _RechargeBalanceCard(overview: overview),
        //   ],
      ],
    );
  }
}

class _RechargeBalanceCard extends StatelessWidget {
  const _RechargeBalanceCard({required this.overview});

  final PortfolioOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IpsBalanceCard(
      title: l10n.ipsPortfolioTitle,
      subtitle: l10n.ipsPaymentRechargeSubtitle,
      balance: overview.availableBalance?.toStringAsFixed(2) ?? '0.00',
      currency: overview.currency,
      availableBalanceLabel: l10n.ipsPortfolioAvailableBalance,
      availableBalanceValue: overview.availableBalance == null ? null : formatIpsAmount(overview.availableBalance!, overview.currency),
      investedBalanceLabel: l10n.ipsPortfolioInvestedBalance,
      investedBalanceValue: overview.investedBalance == null ? null : formatIpsAmount(overview.investedBalance!, overview.currency),
    );
  }
}
