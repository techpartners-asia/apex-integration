import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_contract_cubit.dart';
import '../../application/ips_contract_state.dart';
import 'contract_purchase_screen.dart';

class ContractSetupScreen extends StatefulWidget {
  const ContractSetupScreen({super.key});

  @override
  State<ContractSetupScreen> createState() => _ContractSetupScreenState();
}

class _ContractSetupScreenState extends State<ContractSetupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<IpsContractCubit>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IpsContractCubit, IpsContractState>(
      listenWhen: (IpsContractState previous, IpsContractState current) =>
          previous.isReady != current.isReady && current.isReady,
      listener: (BuildContext context, IpsContractState state) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const ContractPurchaseScreen(),
          ),
        );
      },
      child: BlocBuilder<IpsContractCubit, IpsContractState>(
        builder: (BuildContext context, IpsContractState state) {
          final l10n = context.l10n;
          final bool showLoading =
              state.isInitializing ||
              (!state.isReady && state.errorMessage == null);

          return InvestXPageScaffold(
            showBackButton: true,
            showCloseButton: false,
            onBack: () => Navigator.of(context, rootNavigator: true).maybePop(),
            appBarShowBottomBorder: false,
            backgroundColor: InvestXDesignTokens.softSurface,
            appBarBackgroundColor: InvestXDesignTokens.softSurface,
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: showLoading
                    ? MiniAppLoadingState(
                        title: l10n.commonLoading,
                        message: l10n.ipsContractPreparingAccounts,
                      )
                    : MiniAppErrorState(
                        title: l10n.errorsActionFailed,
                        message: state.errorMessage ?? l10n.errorsActionFailed,
                        retryLabel: l10n.commonRetry,
                        onRetry: context.read<IpsContractCubit>().initialize,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
