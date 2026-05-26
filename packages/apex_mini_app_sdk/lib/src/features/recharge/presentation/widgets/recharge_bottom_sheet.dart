import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows the recharge flow as a modal bottom sheet.
///
/// [ordersService] submits recharge actions, [portfolioService] and
/// [bootstrapService] can refresh portfolio/account context, [pricingContext]
/// provides an already-resolved account context, and [paymentExecutor] delegates
/// payment to the host app. Returns the [IpsRechargeState] when the sheet
/// closes, or `null` if dismissed without completing.
Future<IpsRechargeState?> showRechargeBottomSheet(
  BuildContext context, {
  required OrdersService ordersService,
  PortfolioService? portfolioService,
  InvestmentBootstrapService? bootstrapService,
  SdkPortfolioContext? pricingContext,
  required MiniAppPaymentExecutor paymentExecutor,
  required SdkLocalizations l10n,
  MiniAppLogger logger = const SilentMiniAppLogger(),
}) {
  return showModalBottomSheet<IpsRechargeState>(
    context: context,
    isScrollControlled: true,
    requestFocus: false,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return BlocProvider<IpsRechargeCubit>(
        create: (_) => IpsRechargeCubit(
          service: ordersService,
          portfolioService: portfolioService,
          bootstrapService: bootstrapService,
          pricingContext: pricingContext,
          paymentExecutor: paymentExecutor,
          l10n: l10n,
          logger: logger,
        )..loadPricing(),
        child: const _RechargeBottomSheet(),
      );
    },
  );
}

/// Modal content shell for the recharge flow.
class _RechargeBottomSheet extends StatefulWidget {
  /// Creates the recharge bottom-sheet content.
  const _RechargeBottomSheet();

  @override
  State<_RechargeBottomSheet> createState() => _RechargeBottomSheetState();
}

/// Manages input focus and listens to recharge submission state.
class _RechargeBottomSheetState extends State<_RechargeBottomSheet> {
  /// Quantity text controller for the hidden/visible input.
  final TextEditingController _controller = TextEditingController();

  /// Focus node used to show the keyboard when the sheet opens.
  final FocusNode _focusNode = FocusNode(debugLabel: 'recharge_quantity_input');

  /// Current bottom-sheet route animation being observed.
  Animation<double>? _routeAnimation;

  /// Whether initial focus has already been requested for this sheet.
  bool _initialFocusRequested = false;

  /// Whether the platform keyboard fallback has already been attempted.
  bool _keyboardFallbackRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchBottomSheetOpenAnimation();
  }

  /// Waits for the sheet opening animation before requesting input focus.
  void _watchBottomSheetOpenAnimation() {
    final Animation<double>? animation = ModalRoute.of(context)?.animation;
    if (identical(_routeAnimation, animation)) return;

    _routeAnimation?.removeStatusListener(_handleBottomSheetAnimationStatus);
    _routeAnimation = animation;

    if (animation == null || animation.status == AnimationStatus.completed) {
      _requestInitialFocusAfterOpen();
      return;
    }

    animation.addStatusListener(_handleBottomSheetAnimationStatus);
  }

  /// Requests focus once the modal route animation reaches completed.
  void _handleBottomSheetAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _requestInitialFocusAfterOpen();
    }
  }

  /// Schedules initial focus after layout and route animation are stable.
  void _requestInitialFocusAfterOpen() {
    if (_initialFocusRequested) return;
    _initialFocusRequested = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      _focusQuantityInput(showKeyboardFallback: true);
    });
  }

  /// Focuses the quantity input and optionally asks the platform keyboard to open.
  void _focusQuantityInput({bool showKeyboardFallback = false}) {
    if (!mounted) return;

    FocusScope.of(context).requestFocus(_focusNode);
    if (!showKeyboardFallback || _keyboardFallbackRequested) return;
    _keyboardFallbackRequested = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_focusNode.hasFocus) return;
      if (MediaQuery.of(context).viewInsets.bottom > 0) return;
      SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    });
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_handleBottomSheetAnimationStatus);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // final bool hasKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<IpsRechargeCubit, IpsRechargeState>(
      listenWhen: (IpsRechargeState prev, IpsRechargeState curr) => (prev.paymentRes != curr.paymentRes && curr.paymentRes != null) || (prev.errorMessage != curr.errorMessage && (curr.errorMessage?.trim().isNotEmpty ?? false)),
      listener: (BuildContext context, IpsRechargeState state) {
        if (state.paymentRes != null) {
          if (state.paymentRes?.status == MiniAppPaymentStatus.success) {
            MiniAppToast.showSuccess(
              context,
              message: context.l10n.commonSuccess,
            );
          }
          Navigator.of(context).pop(state);
          return;
        }

        final String? message = state.errorMessage?.trim();
        if (message != null && message.isNotEmpty) {
          MiniAppToast.showError(context, message: message);
        }
      },
      builder: (BuildContext context, IpsRechargeState state) {
        return Theme(
          data: DesignTokens.theme(Theme.of(context)),
          child: Builder(
            builder: (BuildContext context) {
              return ActionSheet(
                title: l10n.ipsPaymentRechargeTitle,
                showDivider: false,
                backgroundColor: DesignTokens.softSurface,
                btmPad: 0,
                // MediaQuery.of(context).viewInsets.bottom,
                child: _RechargeSheetBody(
                  controller: _controller,
                  focusNode: _focusNode,
                  state: state,
                  onRequestFocus: _focusQuantityInput,
                  onQuantityChanged: context.read<IpsRechargeCubit>().updatePackQty,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Scrollable body and submit button for the recharge sheet.
class _RechargeSheetBody extends StatelessWidget {
  /// Controller bound to the recharge quantity input.
  final TextEditingController controller;

  /// Focus node bound to the recharge quantity input.
  final FocusNode focusNode;

  /// Current recharge state.
  final IpsRechargeState state;

  /// Called when the user taps the input area.
  final VoidCallback onRequestFocus;

  /// Called when the quantity text changes.
  final ValueChanged<String> onQuantityChanged;

  /// Creates the recharge sheet body.
  const _RechargeSheetBody({
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.onRequestFocus,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    // final hasKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    final Widget quantitySection = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRequestFocus,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: responsive.spacing.sectionSpacing),
          RechargeQuantityInput(
            controller: controller,
            focusNode: focusNode,
            onChanged: onQuantityChanged,
            unfocusOnTapOutside: true,
          ),
          SizedBox(height: responsive.spacing.inlineSpacing),
          CustomText(
            l10n.ipsPaymentRechargeQuantityHint,
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.muted,
          ),
        ],
      ),
    );

    final Widget summarySection = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
        RechargePricingSummaryCard(state: state),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                quantitySection,
                summarySection,
              ],
            ),
          ),
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        PrimaryButton(
          label: state.isSubmitting ? l10n.commonLoading : l10n.commonPay,
          onPressed: state.canSubmit ? context.read<IpsRechargeCubit>().submit : null,
        ),
        SizedBox(height: responsive.spacing.inlineSpacing),
      ],
    );
  }
}
