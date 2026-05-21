import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen IPS recharge flow.
class RechargeScreen extends StatefulWidget {
  /// Creates the full-screen recharge route.
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

/// Owns recharge quantity input state for the full-screen route.
class _RechargeScreenState extends State<RechargeScreen> {
  /// Quantity text controller.
  final TextEditingController _controller = TextEditingController();

  /// Focus node used to focus the quantity input on open.
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

        if (state.errorMessage.isNotNullOrEmpty) {
          MiniAppToast.showSuccess(
            context,
            message: state.errorMessage ?? context.l10n.errorsGenericTitle,
          );
        }

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
                  showBackButton: true,
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

/// Main recharge form body with input and pricing summary.
class _RechargeBody extends StatelessWidget {
  /// Quantity text controller.
  final TextEditingController controller;

  /// Quantity input focus node.
  final FocusNode focusNode;

  /// Current recharge state.
  final IpsRechargeState state;

  /// Creates the recharge body.
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

/// Fixed bottom submit area for the recharge screen.
class _BottomActionArea extends StatelessWidget {
  /// Current recharge state.
  final IpsRechargeState state;

  /// Creates the bottom action area.
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

/// Displays the payment result after recharge submission.
class _RechargeResultView extends StatelessWidget {
  /// Creates the recharge result view.
  const _RechargeResultView({required this.state});

  /// Final recharge state containing [IpsRechargeState.paymentRes].
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
