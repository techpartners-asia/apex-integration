import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class StatementsScreen extends StatelessWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsStatementsCubit, LoadableState<IpsStatementsViewData>>(
      builder: (BuildContext context, LoadableState<IpsStatementsViewData> state) {
        final l10n = context.l10n;
        final responsive = context.responsive;

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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const StatementFilterSheet(),
    );
  }
}

class _StatementsBody extends StatelessWidget {
  final SdkLocalizations l10n;
  final PortfolioStatementsData statements;

  const _StatementsBody({required this.l10n, required this.statements});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppRefreshContainer(
      onRefresh: context.read<IpsStatementsCubit>().load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.spacing.financialCardSpacing,
          vertical: responsive.spacing.sectionSpacing,
        ),
        children: <Widget>[
          if (statements.summary.trim().isNotEmpty) ...<Widget>[
            _StatementSummaryCard(
              l10n: l10n,
              statements: statements,
            ),
            SizedBox(height: responsive.spacing.sectionSpacing),
          ],
          if (!statements.hasEntries)
            MiniAppEmptyState(
              title: l10n.ipsStatementTitle,
              message: l10n.commonNoData,
            )
          else
            SectionCard(
              children: statements.entries
                  .map(
                    (PortfolioStatementEntry entry) => StatementListItem(
                      title: entry.description,
                      subtitle: _statementSubtitle(entry),
                      trailing: _formatStatementAmount(
                        entry.amount,
                        statements.currency,
                        positive: entry.isCredit,
                      ),
                      statusLabel: entry.isCredit ? l10n.ipsStatementTypeIncome : l10n.ipsStatementTypeExpense,
                      positive: entry.isCredit,
                      showDivider: entry != statements.entries.last,
                    ),
                  )
                  .toList(growable: false),
            ),
          SizedBox(height: responsive.spacing.sectionSpacing * 2),
        ],
      ),
    );
  }

  String _statementSubtitle(PortfolioStatementEntry entry) {
    if (entry.postedAt != null) {
      return formatIpsDate(entry.postedAt!);
    }
    if (entry.postedAtText?.trim().isNotEmpty == true) {
      return entry.postedAtText!.trim();
    }
    if (entry.referenceNo?.trim().isNotEmpty == true) {
      return entry.referenceNo!.trim();
    }
    return '-';
  }

  String _formatStatementAmount(
    double amount,
    String currency, {
    required bool positive,
  }) {
    final String sign = positive ? '+' : '-';
    return '$sign${formatIpsPaymentAmount(amount.abs(), currency)}';
  }
}

class _StatementSummaryCard extends StatelessWidget {
  final SdkLocalizations l10n;
  final PortfolioStatementsData statements;

  const _StatementSummaryCard({required this.l10n, required this.statements});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SectionCard(
      title: l10n.ipsStatementSummary,
      subtitle: statements.summary,
      children: <Widget>[
        IpsDetailRow(
          label: '${l10n.ipsStatementFilterDateTitle}:',
          value: '${statements.startDate} - ${statements.endDate}',
        ),
        IpsDetailRow(
          label: '${l10n.ipsStatementBeginBalance}:',
          value: formatIpsPaymentAmount(
            statements.beginBalance ?? 0,
            statements.currency,
          ),
        ),
        IpsDetailRow(
          label: '${l10n.ipsStatementEndBalance}:',
          value: formatIpsPaymentAmount(
            statements.endBalance ?? 0,
            statements.currency,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: responsive.spacing.inlineSpacing * 0.5),
          child: CustomText(
            l10n.ipsStatementEntriesCount(statements.totalCount),
            variant: MiniAppTextVariant.caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: DesignTokens.muted,
            ),
          ),
        ),
      ],
    );
  }
}
