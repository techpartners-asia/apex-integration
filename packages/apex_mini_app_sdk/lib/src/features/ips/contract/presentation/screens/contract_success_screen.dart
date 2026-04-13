import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../routes/mini_app_routes.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../../shared/presentation/helpers/ips_navigation.dart';
import '../../application/ips_contract_cubit.dart';

class ContractSuccessScreen extends StatelessWidget {
  const ContractSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final String contractId =
        context.select(
          (IpsContractCubit cubit) => cubit.state.contractRes?.contractId,
        ) ??
        '';

    return InvestXPageScaffold(
      hasAppBar: false,
      backgroundColor: InvestXDesignTokens.softSurface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            responsive.space(AppSpacing.xl),
            responsive.space(AppSpacing.xl),
            responsive.space(AppSpacing.xl),
            responsive.space(AppSpacing.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: responsive.dp(110),
                  height: responsive.dp(110),
                  decoration: const BoxDecoration(
                    color: InvestXDesignTokens.successStrong,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: responsive.dp(60),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: responsive.spacing.sectionSpacing),
              CustomText(
                l10n.secAcntCalculationTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                  color: InvestXDesignTokens.ink,
                ),
              ),
              if (contractId.isNotEmpty) ...<Widget>[
                SizedBox(height: responsive.spacing.inlineSpacing),
                CustomText(
                  '${l10n.ipsContractId}: $contractId',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: InvestXDesignTokens.muted,
                  ),
                ),
              ],
              SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
              InvestXReminderCard(
                title: l10n.ipsOverviewDashboardReminderTitle,
                message: l10n.ipsOverviewDashboardReminderBody,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InvestXBottomActionBar(
        child: InvestXPrimaryButton(
          label: l10n.commonGoHome,
          onPressed: () =>
              replaceIpsRoute(context, route: MiniAppRoutes.overview),
        ),
      ),
    );
  }
}
