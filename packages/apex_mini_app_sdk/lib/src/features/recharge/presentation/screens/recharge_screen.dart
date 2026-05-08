import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
          data: DesignTokens.theme(Theme.of(context)),
          child: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: DesignTokens.softSurface,
                resizeToAvoidBottomInset: true,
                appBar: CustomAppBar(
                  title: l10n.ipsPaymentRechargeTitle,
                  showBackButton: false,
                  showCloseButton: true,
                  backgroundColor: DesignTokens.softSurface,
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
                          SizedBox(
                            height: responsive.spacing.sectionSpacing * 2,
                          ),

                          /// The quantity input
                          RechargeQuantityInput(
                            controller: controller,
                            focusNode: focusNode,
                            onChanged: context
                                .read<IpsRechargeCubit>()
                                .updatePackQty,
                          ),
                          SizedBox(height: responsive.spacing.inlineSpacing),

                          /// The hint text
                          CustomText(
                            l10n.ipsPaymentRechargeQuantityHint,
                            variant: MiniAppTextVariant.caption1,
                            color: DesignTokens.muted,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.spacing.sectionSpacing,
                        ),
                        child: RechargePricingSummaryCard(state: state),
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
      child: PrimaryButton(
        label: state.isSubmitting ? l10n.commonLoading : l10n.commonPay,
        onPressed: state.canSubmit
            ? context.read<IpsRechargeCubit>().submit
            : null,
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

    return CustomScaffold(
      appBarTitle: l10n.ipsPaymentRechargeTitle,
      children: <Widget>[PaymentResState(res: state.paymentRes!)],
    );
  }
}
