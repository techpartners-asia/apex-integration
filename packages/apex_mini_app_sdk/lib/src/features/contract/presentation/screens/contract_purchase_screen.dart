import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ContractPurchaseScreen extends StatefulWidget {
  const ContractPurchaseScreen({super.key});

  @override
  State<ContractPurchaseScreen> createState() => _ContractPurchaseScreenState();
}

class _ContractPurchaseScreenState extends State<ContractPurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final IpsContractCubit cubit = context.read<IpsContractCubit>();
    final String packTitle =
        cubit.payload.pack.packDesc?.trim().isNotEmpty == true
        ? cubit.payload.pack.packDesc!.trim()
        : cubit.payload.pack.name;

    return BlocListener<IpsContractCubit, IpsContractState>(
      listenWhen: (IpsContractState previous, IpsContractState current) =>
          previous.paymentRes?.status != current.paymentRes?.status,
      listener: (BuildContext context, IpsContractState state) {
        if (state.paymentRes?.status == MiniAppPaymentStatus.success) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ContractSuccessScreen(),
            ),
          );
        }
      },
      child: BlocBuilder<IpsContractCubit, IpsContractState>(
        builder: (BuildContext context, IpsContractState state) {
          if (!state.isReady) {
            return CustomScaffold(
              showBackButton: true,
              showCloseButton: false,
              appBarShowBottomBorder: false,
              backgroundColor: DesignTokens.softSurface,
              appBarBackgroundColor: DesignTokens.softSurface,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: MiniAppLoadingState(
                    title: l10n.commonLoading,
                    message: l10n.ipsContractPreparingAccounts,
                  ),
                ),
              ),
            );
          }

          return CustomScaffold(
            showBackButton: true,
            appBarShowBottomBorder: false,
            backgroundColor: DesignTokens.softSurface,
            appBarBackgroundColor: DesignTokens.softSurface,
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.sm,
                    AppSpacing.xl,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ContractPurchaseSummaryCard(
                        title: packTitle,
                        quantity: state.purchaseQty,
                        quantityPrompt: l10n.ipsContractPackQuantityPrompt,
                        unitPriceLabel: l10n.ipsContractUnitPrice,
                        serviceFeeLabel: l10n.ipsContractServiceFee,
                        totalLabel: l10n.commonTotalPayable,
                        unitPrice: state.unitPrice,
                        serviceFee: state.serviceFee,
                        totalPayable: state.totalPayable,
                      ),
                      if (_buildStatusBanner(context, state)
                          case final Widget banner) ...<Widget>[
                        SizedBox(
                          height: context.responsive.spacing.sectionSpacing,
                        ),
                        banner,
                      ],
                      SizedBox(
                        height: context.responsive.spacing.sectionSpacing,
                      ),
                      ContractQuantityKeypad(
                        onDigitPressed: cubit.appendDigit,
                        onBackspacePressed: cubit.backspaceDigit,
                      ),
                    ],
                  ),
                ),
                if (state.isSubmitting)
                  BlockingLoadingOverlay(
                    title: l10n.commonLoading,
                    message: l10n.ipsContractPreparingPayment,
                  ),
              ],
            ),
            bottomNavigationBar: BottomActionBar(
              child: PrimaryButton(
                label: state.isSubmitting ? l10n.commonLoading : l10n.commonPay,
                onPressed: state.canSubmit ? cubit.submit : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget? _buildStatusBanner(BuildContext context, IpsContractState state) {
    if (state.errorMessage case final String message
        when message.trim().isNotEmpty) {
      return NoticeBanner(
        title: context.l10n.errorsActionFailed,
        message: message,
        icon: Icons.error_outline_rounded,
      );
    }

    final MiniAppPaymentRes? paymentRes = state.paymentRes;
    if (paymentRes == null ||
        paymentRes.status == MiniAppPaymentStatus.success) {
      return null;
    }

    return NoticeBanner(
      title: resolvePaymentStatusLabel(context.l10n, paymentRes.status),
      message:
          resolvePaymentResultMessage(context.l10n, paymentRes) ??
          paymentRes.message ??
          context.l10n.errorsActionFailed,
      icon: Icons.error_outline_rounded,
    );
  }
}
