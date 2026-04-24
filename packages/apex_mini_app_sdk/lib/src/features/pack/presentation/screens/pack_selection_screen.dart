import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PackSelectionScreen extends StatefulWidget {
  const PackSelectionScreen({super.key, this.questionnaireRes});

  final QuestionnaireRes? questionnaireRes;

  @override
  State<PackSelectionScreen> createState() => PackSelectionScreenState();
}

class PackSelectionScreenState extends State<PackSelectionScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsPackSelectionCubit, LoadableState<List<IpsPack>>>(
      builder: (BuildContext context, LoadableState<List<IpsPack>> state) {
        final l10n = context.l10n;
        final List<IpsPack> packs = state.data ?? const <IpsPack>[];
        if (currentPage >= packs.length && packs.isNotEmpty) {
          currentPage = packs.length - 1;
        }

        return CustomScaffold(
          appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: <Widget>[
                // if (widget.questionnaireRes != null) ...<Widget>[
                //   NoticeBanner(
                //     title: l10n.ipsQuestionnaireResTitle,
                //     message:
                //         '${l10n.ipsQuestionnaireScore}: ${widget.questionnaireRes!.score}'
                //         '${widget.questionnaireRes!.summary == null ? '' : '\n${widget.questionnaireRes!.summary!}'}',
                //     icon: Icons.shield_outlined,
                //   ),
                //   SizedBox(height: context.responsive.spacing.sectionSpacing),
                // ],
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
                    pageController: pageController,
                    currentPage: currentPage,
                    packs: packs,
                    questionnaireRes: widget.questionnaireRes,
                    onPageChanged: (int index) =>
                        setState(() => currentPage = index),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PackSelectionContent extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<IpsPack> packs;
  final QuestionnaireRes? questionnaireRes;
  final ValueChanged<int> onPageChanged;

  const PackSelectionContent({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.packs,
    required this.questionnaireRes,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    packs.sort((a, b) => b.isRecommended.compareTo(a.isRecommended));
    // final IpsPack selectedPack = packs.singleWhere((p) => p.isRecommended, orElse: () => packs.first); // packs[currentPage];
    IpsPack selectedPack = packs[currentPage];

    return Column(
      children: packs
          .map(
            (e) => SelectionPageTemplate(
              hasMargin: true,
              header: PackCard(pack: e),
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
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing.cardGap),
                    ...buildPackBenefits(context, e),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: MiniAppTypography.semiBold,
                        ),
                      ),
                    ),
                    onTap: () {
                      selectedPack = e;
                      launchIpsRoute(
                        context,
                        route: MiniAppRoutes.contract,
                        arguments: ContractPayload(
                          pack: selectedPack,
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
          child: FeatureBullet(label: point),
        ),
      )
      .toList(growable: false);
}
