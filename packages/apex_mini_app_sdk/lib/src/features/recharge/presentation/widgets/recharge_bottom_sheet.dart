import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
    requestFocus: false,
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
  final FocusNode _focusNode = FocusNode(debugLabel: 'recharge_quantity_input');
  Animation<double>? _routeAnimation;
  bool _initialFocusRequested = false;
  bool _keyboardFallbackRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchBottomSheetOpenAnimation();
  }

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

  void _handleBottomSheetAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _requestInitialFocusAfterOpen();
    }
  }

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
      listenWhen: (IpsRechargeState prev, IpsRechargeState curr) => prev.paymentRes != curr.paymentRes && curr.paymentRes != null,
      listener: (BuildContext context, IpsRechargeState state) {
        Navigator.of(context).pop(state);
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
                btmPad: 0 , // MediaQuery.of(context).viewInsets.bottom,
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

class _RechargeSheetBody extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IpsRechargeState state;
  final VoidCallback onRequestFocus;
  final ValueChanged<String> onQuantityChanged;

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
