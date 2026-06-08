import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen where the user chooses an investment pack.
class PackSelectionScreen extends StatelessWidget {
  /// Creates the pack selection screen.
  const PackSelectionScreen({super.key, this.questionnaireRes});

  /// Optional questionnaire result used to filter recommended packs.
  final QuestionnaireRes? questionnaireRes;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsPackSelectionCubit, LoadableState<List<IpsPack>>>(
      builder: (BuildContext context, LoadableState<List<IpsPack>> state) {
        final l10n = context.l10n;
        final List<IpsPack> packs = state.data ?? const <IpsPack>[];

        return CustomScaffold(
          appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: <Widget>[
                if (state.isLoading && packs.isNotEmpty) ...<Widget>[
                  MiniAppLoadingState(
                    title: l10n.commonLoading,
                    message: l10n.ipsPackLoading,
                  ),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),
                ],
                if ((state.isInitial || state.isLoading) && packs.isEmpty)
                  MiniAppLoadingState(
                    title: l10n.commonLoading,
                    message: l10n.ipsPackLoading,
                  )
                else if (state.isFailure)
                  MiniAppErrorState(
                    title: l10n.errorsGenericTitle,
                    message: state.errorMessage ?? l10n.errorsActionFailed,
                    retryLabel: l10n.commonRetry,
                    onRetry: context.read<IpsPackSelectionCubit>().load,
                  )
                else if (packs.isEmpty)
                  MiniAppEmptyState(
                    title: l10n.ipsPackTitle,
                    message: l10n.ipsPackNoPacks,
                  )
                else
                  PackSelectionContent(
                    packs: questionnaireRes!.showRecomended
                        ? packs.where((el) => el.isRecommended == 1).toList()
                        : packs,
                    questionnaireRes: questionnaireRes,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Loaded pack-selection content.
class PackSelectionContent extends StatelessWidget {
  /// Available packs.
  final List<IpsPack> packs;

  /// Optional questionnaire result passed forward into contract flow.
  final QuestionnaireRes? questionnaireRes;

  /// Creates loaded pack-selection content.
  const PackSelectionContent({
    super.key,
    required this.packs,
    required this.questionnaireRes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final List<IpsPack> sortedPacks = List<IpsPack>.of(packs)
      ..sort((IpsPack a, IpsPack b) {
        return b.isRecommended.compareTo(a.isRecommended);
      });

    return Column(
      children: sortedPacks
          .map(
            (IpsPack pack) => SelectionPageTemplate(
              hasMargin: true,
              header: PackCard(pack: pack),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomImage(
                          path: Img.trophyBlue,
                          width: responsive.dp(20),
                          height: responsive.dp(20),
                        ),
                        SizedBox(width: responsive.spacing.inlineSpacing),
                        CustomText(
                          l10n.ipsPackRecommendedBadge,
                          variant: MiniAppTextVariant.subtitle3,
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing.cardGap),
                    ...buildPackBenefits(context, pack),
                  ],
                ),
              ),

              actionBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        gradient: DesignTokens.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CustomText(
                        l10n.ipsPackChoosePack,
                        variant: MiniAppTextVariant.buttonSmall,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      // final IpsDependencies dependencies = context.read<IpsDependencies>();
                      // final SdkLocalizations l10n = context.l10n;
                      //
                      // final IpsRechargeState? result = await showIpsRechargeBottomSheet(
                      //   context,
                      //   dependencies: dependencies,
                      //   l10n: l10n,
                      // );

                      // if (!context.mounted || result == null) return;

                      // final MiniAppPaymentStatus? status = result.paymentRes?.status;
                      // final bool didSucceed = status == MiniAppPaymentStatus.success || status == MiniAppPaymentStatus.paid;
                      // if (!didSucceed) return;

                      await replaceIpsRoute(
                        context,
                        route: MiniAppRoutes.contract,
                        arguments: ContractPayload(
                          pack: pack,
                          res: questionnaireRes,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Builds benefit bullets based on the pack allocation mix.
List<Widget> buildPackBenefits(BuildContext context, IpsPack pack) {
  final l10n = context.l10n;
  final List<String> points = <String>[
    if (pack.bondPercent >= pack.stockPercent) l10n.ipsPackBenefitStableYield,
    if (pack.stockPercent > 0) l10n.ipsPackBenefitStockGrowth,
    if (pack.assetPercent > 0) l10n.ipsPackBenefitBalancedStructure,
    if (pack.bondPercent == 0 && pack.assetPercent == 0)
      l10n.ipsPackBenefitGrowthFocused,
  ];

  return points
      .map(
        (String point) => Padding(
          padding: EdgeInsets.only(
            bottom: context.responsive.spacing.inlineSpacing * 0.75,
          ),
          child: FeatureBullet(
            label: point,
            textVariant: MiniAppTextVariant.body3,
            fontWeight: FontWeight.w400,
          ),
        ),
      )
      .toList(growable: false);
}
