import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Payment step for securities account opening fees.
class SecAcntPaymentScreen extends StatefulWidget {
  /// Creates the payment screen.
  const SecAcntPaymentScreen({
    super.key,
    required this.bootstrapState,
    required this.draft,
    this.currentUser,
    this.isInitialStep = false,
  });

  /// Bootstrap data containing commission/payment requirements.
  final AcntBootstrapState? bootstrapState;

  /// Draft personal/bank data submitted alongside opening payment.
  final SecAcntFlowDraft draft;

  /// Current profile used to skip already-paid contract fees.
  final UserEntityDto? currentUser;

  /// Whether this screen is the first screen in the nested flow.
  final bool isInitialStep;

  @override
  State<SecAcntPaymentScreen> createState() => _SecAcntPaymentScreenState();
}

/// Handles payment submission and post-payment bootstrap refresh.
class _SecAcntPaymentScreenState extends State<SecAcntPaymentScreen> {
  /// Whether account/bootstrap status is being refreshed after payment success.
  bool _isRefreshingBootstrap = false;

  /// Mutable bootstrap snapshot so refreshed state can affect next routing.
  AcntBootstrapState? _bootstrapState;

  @override
  void initState() {
    super.initState();
    _bootstrapState = widget.bootstrapState;
  }

  /// Payable account-opening commission from the current bootstrap snapshot.
  double? get _payableCommission => _bootstrapState?.commission;

  /// Submits opening payment and moves to calculation when payment succeeds.
  Future<void> _submitOpeningPayment() async {
    final IpsSecAcntCubit cubit = context.read<IpsSecAcntCubit>();
    final double? amount = _payableCommission;
    if (amount == null || !amount.isFinite || amount <= 0) {
      return;
    }

    final MiniAppPaymentRes? res = await cubit.submitOpeningPayment(
      payableAmount: amount,
      personalInfo: widget.draft.toPersonalInfoData(),
      requiresOpeningPaymentFlow: requiresSecAcntOpeningPayment(
        _bootstrapState,
        currentUser: widget.currentUser,
      ),
    );
    if (!mounted) {
      return;
    }

    if (res?.status != MiniAppPaymentStatus.success) {
      return;
    }

    setState(() => _isRefreshingBootstrap = true);
    try {
      final AcntBootstrapState? refreshedState = await cubit
          .refreshBootstrapState(currentState: _bootstrapState);
      if (!mounted) {
        return;
      }
      if (refreshedState != null) {
        setState(() => _bootstrapState = refreshedState);
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshingBootstrap = false);
      }
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SecAcntCalculationScreen(bootstrapState: _bootstrapState),
      ),
    );
  }

  /// Handles back behavior for both initial and nested payment routes.
  Future<void> _handleBack() async {
    if (widget.isInitialStep) {
      await closeSecAcntFlow(context);
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double footerClearance =
        responsive.dp(24) +
        responsive.spacing.buttonHeight +
        4 +
        responsive.safeBottom;
    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.payment,
    );

    return BlocBuilder<IpsSecAcntCubit, IpsSecAcntState>(
      builder: (BuildContext context, IpsSecAcntState state) {
        final double? payableCommission = _payableCommission;
        final bool canPay =
            !state.isSubmitting &&
            payableCommission != null &&
            payableCommission.isFinite &&
            payableCommission > 0;

        return CustomScaffold(
          appBarTitle: header.title,
          appBarCenterTitle: header.centerTitle,
          appBarReserveLeadingSpace: header.reserveLeadingSpace,
          appBarTitleSpacing: header.centerTitle ? null : responsive.dp(20),
          showBackButton: header.showBack,
          showCloseButton: header.showClose,
          onBack: _handleBack,
          onDismiss: () => closeSecAcntFlow(context),
          hasSafeArea: false,
          backgroundColor: DesignTokens.softSurface,
          appBarBackgroundColor: DesignTokens.softSurface,
          appBarShowBottomBorder: false,
          appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    responsive.dp(AppSpacing.xl),
                    responsive.dp(8),
                    responsive.dp(AppSpacing.xl),
                    responsive.dp(AppSpacing.xl) + footerClearance,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // SecAcntStepIndicator(
                      //   currentStep: SecAcntFlowStep.payment,
                      //   bootstrapState: _bootstrapState,
                      //   currentUser: widget.currentUser,
                      // ),
                      SecAcntPaymentStep(
                        errorMessage: state.errorMessage,
                        isSubmitting: state.isSubmitting,
                        payableAmount: payableCommission ?? 0,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isRefreshingBootstrap)
                BlockingLoadingOverlay(
                  title: context.l10n.commonLoading,
                  message: context.l10n.ipsBootstrapLoading,
                ),
            ],
          ),
          bottomNavigationBar: SecAcntWizardFooter(
            buttonLabel: state.isSubmitting
                ? context.l10n.commonLoading
                : context.l10n.commonPay,
            onPressed: _submitOpeningPayment,
            enabled: canPay,
          ),
        );
      },
    );
  }
}
