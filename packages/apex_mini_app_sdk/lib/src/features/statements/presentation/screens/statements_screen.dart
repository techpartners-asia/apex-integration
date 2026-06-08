import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Portfolio statement list screen with filtering and refresh support.
class StatementsScreen extends StatelessWidget {
  /// Creates the statements screen.
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      IpsStatementsCubit,
      LoadableState<IpsStatementsViewData>
    >(
      listenWhen:
          (
            LoadableState<IpsStatementsViewData> previous,
            LoadableState<IpsStatementsViewData> current,
          ) {
            return current.isSuccess &&
                (current.errorMessage?.trim().isNotEmpty ?? false);
          },
      listener:
          (BuildContext context, LoadableState<IpsStatementsViewData> state) {
            final String? message = state.errorMessage?.trim();
            if (message == null || message.isEmpty) {
              return;
            }
            MiniAppToast.showError(context, message: message);
          },
      builder:
          (BuildContext context, LoadableState<IpsStatementsViewData> state) {
            final l10n = context.l10n;

            if (state.isInitial || state.isLoading) {
              return CustomScaffold(
                appBarTitle: l10n.ipsStatementTitle,
                showCloseButton: false,
                children: <Widget>[
                  MiniAppLoadingState(
                    title: l10n.commonLoading,
                    message: l10n.ipsStatementsLoading,
                  ),
                ],
              );
            }

            if (state.isFailure) {
              return CustomScaffold(
                appBarTitle: l10n.ipsStatementTitle,
                showCloseButton: false,
                children: <Widget>[
                  MiniAppErrorState(
                    title: l10n.errorsGenericTitle,
                    message: state.errorMessage ?? l10n.errorsActionFailed,
                    retryLabel: l10n.commonRetry,
                    onRetry: context.read<IpsStatementsCubit>().load,
                  ),
                ],
              );
            }

            final PortfolioStatementsData? statements = state.data?.statements;
            if (statements == null) {
              return CustomScaffold(
                appBarTitle: l10n.ipsStatementTitle,
                showCloseButton: false,
                children: <Widget>[
                  MiniAppEmptyState(
                    title: l10n.ipsStatementTitle,
                    message: l10n.commonNoData,
                  ),
                ],
              );
            }

            return CustomScaffold(
              appBarTitle: l10n.ipsStatementTitle,
              showCloseButton: false,
              trailing: Row(
                children: <Widget>[
                  // MiniAppAdaptiveIconButton(
                  //   img: Img.download,
                  //   onPressed: () {},
                  // ),
                  // SizedBox(width: responsive.dp(AppSpacing.md)),
                  MiniAppAdaptiveIconButton(
                    img: Img.filter,
                    onPressed: () => _showFilterSheet(context),
                  ),
                ],
              ),
              body: _StatementsBody(
                l10n: l10n,
                statements: statements,
              ),
            );
          },
    );
  }

  /// Opens the statement filter sheet using the current cubit filter state.
  void _showFilterSheet(BuildContext context) {
    final IpsStatementsCubit cubit = context.read<IpsStatementsCubit>();
    final IpsStatementFilter initialFilter =
        cubit.state.data?.filter ?? const IpsStatementFilter();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatementFilterSheet(
        initialFilter: initialFilter,
        onApply: cubit.applyFilter,
        onClear: cubit.clearFilter,
      ),
    );
  }
}

/// Renders the loaded statement list or empty state.
class _StatementsBody extends StatelessWidget {
  /// Localized labels.
  final SdkLocalizations l10n;

  /// Statement data to render.
  final PortfolioStatementsData statements;

  /// Creates the statements body.
  const _StatementsBody({required this.l10n, required this.statements});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppRefreshContainer(
      onRefresh: context.read<IpsStatementsCubit>().load,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing.financialCardSpacing,
        vertical: responsive.spacing.sectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // if (statements.summary.trim().isNotEmpty) ...<Widget>[
          //   _StatementSummaryCard(
          //     l10n: l10n,
          //     statements: statements,
          //   ),
          //   SizedBox(height: responsive.spacing.sectionSpacing),
          // ],
          if (!statements.hasStmtList)
            MiniAppEmptyState(
              title: l10n.ipsStatementTitle,
              message: l10n.commonNoData,
            )
          else
            // SectionCard(children: _buildStatementItems(statements)),
            Column(children: _buildStatementItems(context, statements)),
          SizedBox(height: responsive.spacing.sectionSpacing * 2),
        ],
      ),
    );
  }

  /// Builds one card per statement row.
  List<Widget> _buildStatementItems(
    BuildContext context,
    PortfolioStatementsData statements,
  ) {
    final MiniAppResponsiveData responsive = context.responsive;

    return List<Widget>.generate(
      statements.stmtList.length,
      (int index) {
        final MgBkrCasaAcntStatementResDataDto stmt =
            statements.stmtList[index];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: MiniAppGlassCard(
            radius: responsive.radius(AppRadius.lg),
            padding: EdgeInsets.all(AppSpacing.md),
            child: StatementListItem(
              title: stmt.description,
              subtitle: _statementSubtitle(stmt),
              trailing: _formatStatementAmount(
                stmt.amount,
                statements.currency,
                positive: stmt.isCredit,
              ),
              statusLabel: stmt.isCredit
                  ? l10n.ipsStatementTypeIncome
                  : l10n.ipsStatementTypeExpense,
              positive: stmt.isCredit,
              showDivider: false,
            ),
          ),
        );
      },
      growable: false,
    );
  }

  /// Resolves the best subtitle for a statement row.
  String _statementSubtitle(MgBkrCasaAcntStatementResDataDto stmt) {
    final DateTime? txnDate = ApiParser.asNullableDateTime(stmt.txnDate);
    if (txnDate != null) {
      return formatIpsDate(txnDate);
    }
    if (stmt.txnDate?.trim().isNotEmpty == true) {
      return stmt.txnDate!.trim();
    }
    if (stmt.description.trim().isNotEmpty == true) {
      return stmt.description.trim();
    }
    if (stmt.jrNo?.trim().isNotEmpty == true) {
      return stmt.jrNo!.trim();
    }
    return '-';
  }

  /// Formats a signed statement amount.
  String _formatStatementAmount(
    double amount,
    String currency, {
    required bool positive,
  }) {
    final String sign = positive ? '+' : '-';
    return '$sign${formatIpsPaymentAmount(amount.abs(), currency)}';
  }
}
