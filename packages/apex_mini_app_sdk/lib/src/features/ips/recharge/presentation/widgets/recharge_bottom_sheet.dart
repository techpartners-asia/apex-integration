import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../../../runtime/mini_app_payment_executor.dart';
import '../../../shared/domain/services/investment_services.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_recharge_cubit.dart';
import '../../application/ips_recharge_state.dart';

/// Shows the recharge flow as a modal bottom sheet.
///
/// Returns the [IpsRechargeState] when the sheet closes, or `null` if
/// dismissed without completing.
Future<IpsRechargeState?> showRechargeBottomSheet(
  BuildContext context, {
  required OrdersService ordersService,
  PortfolioService? portfolioService,
  required MiniAppPaymentExecutor paymentExecutor,
  required SdkLocalizations l10n,
  MiniAppLogger logger = const SilentMiniAppLogger(),
}) {
  return showModalBottomSheet<IpsRechargeState>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return BlocProvider<IpsRechargeCubit>(
        create: (_) => IpsRechargeCubit(
          service: ordersService,
          portfolioService: portfolioService,
          paymentExecutor: paymentExecutor,
          l10n: l10n,
          logger: logger,
        )..loadPricing(),
        child: const _RechargeBottomSheet(),
      );
    },
  );
}

class _RechargeBottomSheet extends StatefulWidget {
  const _RechargeBottomSheet();

  @override
  State<_RechargeBottomSheet> createState() => _RechargeBottomSheetState();
}

class _RechargeBottomSheetState extends State<_RechargeBottomSheet> {
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
    final l10n = context.l10n;

    return BlocConsumer<IpsRechargeCubit, IpsRechargeState>(
      listenWhen: (IpsRechargeState prev, IpsRechargeState curr) => prev.paymentRes != curr.paymentRes && curr.paymentRes != null,
      listener: (BuildContext context, IpsRechargeState state) {
        Navigator.of(context).pop(state);
      },
      builder: (BuildContext context, IpsRechargeState state) {
        return Theme(
          data: InvestXDesignTokens.theme(Theme.of(context)),
          child: Builder(
            builder: (BuildContext context) {
              return InvestXActionSheet(
                title: l10n.ipsPaymentRechargeTitle,
                showDivider: false,
                backgroundColor: InvestXDesignTokens.softSurface,
                child: _RechargeSheetBody(
                  controller: _controller,
                  focusNode: _focusNode,
                  state: state,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _RechargeSheetBody extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IpsRechargeState state;

  const _RechargeSheetBody({
    required this.controller,
    required this.focusNode,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: responsive.spacing.sectionSpacing),
          _SheetQuantityInput(
            controller: controller,
            focusNode: focusNode,
          ),
          SizedBox(height: responsive.spacing.inlineSpacing),
          CustomText(
            l10n.ipsPaymentRechargeQuantityHint,
            variant: MiniAppTextVariant.bodySmall,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.muted,
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
          _SheetPricingSummary(state: state),
          SizedBox(height: responsive.spacing.sectionSpacing),
          InvestXPrimaryButton(
            label: state.isSubmitting ? l10n.commonLoading : l10n.commonPay,
            onPressed: state.canSubmit ? context.read<IpsRechargeCubit>().submit : null,
          ),
          SizedBox(height: responsive.spacing.inlineSpacing),
        ],
      ),
    );
  }
}

class _SheetQuantityInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _SheetQuantityInput({
    required this.controller,
    required this.focusNode,
  });

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

class _SheetPricingSummary extends StatelessWidget {
  const _SheetPricingSummary({required this.state});

  final IpsRechargeState state;

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
