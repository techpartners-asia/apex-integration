import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Displays the service terms HTML fetched from the backend.
class TermsOfServiceScreen extends StatelessWidget {
  /// Creates the terms of service screen.
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CustomScaffold(
      appBarTitle: l10n.ipsOverviewProfileMenuTerms,
      showBackButton: true,
      backgroundColor: DesignTokens.softSurface,
      appBarBackgroundColor: DesignTokens.softSurface,
      appBarShowBottomBorder: false,
      body: BlocBuilder<TermsOfServiceCubit, LoadableState<String>>(
        builder: (BuildContext context, LoadableState<String> state) {
          if (state.isLoading || state.isInitial) {
            return const SkeletonLoader();
          }

          if (state.isFailure) {
            return Center(
              child: MiniAppEmptyState(
                title: l10n.ipsOverviewProfileMenuTerms,
                message: state.errorMessage ?? l10n.errorsActionFailed,
                actionLabel: l10n.commonRetry,
                onAction: () => context.read<TermsOfServiceCubit>().load(),
              ),
            );
          }

          final responsive = context.responsive;
          return SingleChildScrollView(
            padding: EdgeInsets.all(responsive.space(AppSpacing.lg)),
            child: MiniAppGlassCard(
              padding: EdgeInsets.all(responsive.space(AppSpacing.lg)),
              child: SelectionArea(
                child: Html(
                  data: sanitizeAgreementHtml(state.data ?? ''),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
