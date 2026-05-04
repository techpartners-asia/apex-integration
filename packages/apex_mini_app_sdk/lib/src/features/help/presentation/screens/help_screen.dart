import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return CustomScaffold(
      appBarTitle: l10n.ipsHelpTitle,
      showCloseButton: false,
      body: BlocBuilder<HelpCubit, LoadableState<BranchInfoEntity>>(
        builder: (BuildContext context, LoadableState<BranchInfoEntity> state) {
          if (state.isLoading || state.isInitial) {
            return const SkeletonLoader();
          }

          if (state.isFailure) {
            return Center(
              child: MiniAppEmptyState(
                title: l10n.ipsHelpTitle,
                message: state.errorMessage ?? l10n.errorsActionFailed,
                actionLabel: l10n.commonRetry,
                onAction: () => context.read<HelpCubit>().load(forceRefresh: true),
              ),
            );
          }

          final BranchInfoEntity? company = state.data;
          if (company == null || !company.hasAnyContent) {
            return Center(
              child: MiniAppEmptyState(
                title: l10n.ipsHelpTitle,
                message: l10n.commonNoData,
                actionLabel: l10n.commonRefresh,
                onAction: () => context.read<HelpCubit>().load(forceRefresh: true),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: responsive.spacing.financialCardSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: responsive.spacing.sectionSpacing),

                      /// Contact info "Email and Phone"
                      if (company.hasContactInfo) ...<Widget>[
                        HelpContactSection(l10n: l10n, company: company),
                        SizedBox(height: responsive.dp(10)),
                      ],

                      /// Social links
                      if (company.hasSocialLinks) ...<Widget>[
                        HelpSocialLinksSection(links: company.socialLinks),
                        // SizedBox(height: responsive.spacing.cardGap),
                      ],

                      /// Location
                      if (company.hasLocationInfo) HelpLocationSection(l10n: l10n, location: company.location!),
                      SizedBox(height: responsive.spacing.sectionSpacing * 2),
                    ],
                  ),
                ),
              ),

              /// Feedback button
              Padding(
                padding: EdgeInsets.all(context.responsive.dp(20)),
                child: PrimaryButton(
                  label: l10n.ipsFeedbackCreateButton,
                  onPressed: () {
                    launchIpsRoute(
                      context,
                      route: MiniAppRoutes.feedback,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
