import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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

    return CustomScaffold(
      hasAppBar: false,
      backgroundColor: DesignTokens.softSurface,
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
                    color: DesignTokens.successStrong,
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
                variant: MiniAppTextVariant.h8,
                textAlign: TextAlign.center,
                color: DesignTokens.ink,
              ),
              if (contractId.isNotEmpty) ...<Widget>[
                SizedBox(height: responsive.spacing.inlineSpacing),
                CustomText(
                  '${l10n.ipsContractId}: $contractId',
                  variant: MiniAppTextVariant.caption1,
                  textAlign: TextAlign.center,
                  color: DesignTokens.muted,
                ),
              ],
              SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
              ReminderCard(
                title: l10n.ipsOverviewDashboardReminderTitle,
                message: l10n.ipsOverviewDashboardReminderBody,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: l10n.commonGoHome,
          onPressed: () =>
              replaceIpsRoute(context, route: MiniAppRoutes.overview),
        ),
      ),
    );
  }
}
