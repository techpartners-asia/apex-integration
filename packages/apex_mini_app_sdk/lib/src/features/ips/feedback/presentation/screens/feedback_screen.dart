import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/feedback_cubit.dart';
import '../../application/feedback_state.dart';
import '../../domain/feedback_entity.dart';
import 'create_feedback_screen.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<FeedbackCubit, FeedbackState>(
      listener: (BuildContext context, FeedbackState state) {
        if (state.errorMessage != null && state.items.isNotEmpty) {
          MiniAppToast.showError(
            context,
            message: state.errorMessage!,
          );
          context.read<FeedbackCubit>().clearFeedback();
        }
      },
      builder: (BuildContext context, FeedbackState state) {
        return InvestXPageScaffold(
          appBarTitle: l10n.ipsFeedbackTitle,
          showCloseButton: false,
          body: _buildBody(context, state, l10n),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    FeedbackState state,
    SdkLocalizations l10n,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const InvestXSkeletonLoader();
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return Center(
        child: MiniAppEmptyState(
          title: l10n.ipsFeedbackTitle,
          message: state.errorMessage!,
          actionLabel: l10n.commonRetry,
          onAction: () => context.read<FeedbackCubit>().refresh(),
        ),
      );
    }

    if (state.items.isEmpty) {
      return _FeedbackEmptyState(
        onCreatePressed: () => _openCreateFeedback(context),
      );
    }

    return _FeedbackListState(
      state: state,
      onCreatePressed: () => _openCreateFeedback(context),
      onLoadMore: () => context.read<FeedbackCubit>().loadNextPage(),
    );
  }

  void _openCreateFeedback(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<FeedbackCubit>.value(
          value: context.read<FeedbackCubit>(),
          child: const CreateFeedbackScreen(),
        ),
      ),
    );
  }
}

class _FeedbackEmptyState extends StatelessWidget {
  const _FeedbackEmptyState({required this.onCreatePressed});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing.financialCardSpacing,
      ),
      child: Column(
        children: <Widget>[
          const Spacer(flex: 2),
          Icon(
            Icons.markunread_mailbox_outlined,
            size: responsive.dp(72),
            color: InvestXDesignTokens.rose.withValues(alpha: 0.7),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing),
          CustomText(
            l10n.ipsFeedbackEmptyTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
          ),
          SizedBox(height: responsive.spacing.inlineSpacing),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.dp(32)),
            child: CustomText(
              l10n.ipsFeedbackEmptyBody,
              textAlign: TextAlign.center,
              variant: MiniAppTextVariant.bodySmall,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: InvestXDesignTokens.muted,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: responsive.spacing.sectionSpacing * 1.5),
          InvestXPrimaryButton(
            label: l10n.ipsFeedbackCreateButton,
            onPressed: onCreatePressed,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _FeedbackListState extends StatelessWidget {
  const _FeedbackListState({
    required this.state,
    required this.onCreatePressed,
    required this.onLoadMore,
  });

  final FeedbackState state;
  final VoidCallback onCreatePressed;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;
    final List<FeedbackEntity> items = state.items;

    return Column(
      children: <Widget>[
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - responsive.dp(120)) {
                onLoadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacing.financialCardSpacing,
                vertical: responsive.spacing.sectionSpacing,
              ),
              itemCount: items.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => SizedBox(height: responsive.spacing.cardGap),
              itemBuilder: (BuildContext context, int index) {
                if (index >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                return _FeedbackListTile(item: items[index]);
              },
            ),
          ),
        ),
        InvestXBottomActionBar(
          child: InvestXPrimaryButton(
            label: l10n.ipsFeedbackCreateButton,
            onPressed: onCreatePressed,
          ),
        ),
      ],
    );
  }
}

class _FeedbackListTile extends StatelessWidget {
  const _FeedbackListTile({required this.item});

  final FeedbackEntity item;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InvestXSectionCard(
      padding: EdgeInsets.all(responsive.dp(16)),
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: responsive.dp(18),
              color: InvestXDesignTokens.muted,
            ),
            SizedBox(width: responsive.dp(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomText(
                          item.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: MiniAppTypography.semiBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: responsive.dp(8)),
                      _FeedbackStatusChip(status: item.status),
                    ],
                  ),
                  SizedBox(height: responsive.dp(6)),
                  CustomText(
                    item.description,
                    variant: MiniAppTextVariant.bodySmall,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: InvestXDesignTokens.muted,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: responsive.dp(8)),
                  Wrap(
                    spacing: responsive.dp(8),
                    runSpacing: responsive.dp(4),
                    children: <Widget>[
                      CustomText(
                        _formatFeedbackTimestamp(item.createdAt),
                        variant: MiniAppTextVariant.caption,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: InvestXDesignTokens.muted,
                        ),
                      ),
                      if (item.updatedAt.trim().isNotEmpty && item.updatedAt != item.createdAt)
                        CustomText(
                          '• ${_formatFeedbackTimestamp(item.updatedAt)}',
                          variant: MiniAppTextVariant.caption,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: InvestXDesignTokens.muted,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _formatFeedbackTimestamp(String raw) {
  final String text = raw.trim();
  if (text.isEmpty) return raw;

  final DateTime? parsed = DateTime.tryParse(text);
  if (parsed == null) return raw;

  return DateFormat('yyyy-MM-dd HH:mm').format(parsed.toLocal());
}

class _FeedbackStatusChip extends StatelessWidget {
  final String status;

  const _FeedbackStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    final (String label, Color bg, Color fg) = switch (status) {
      FeedbackStatus.resolved => (
        l10n.ipsFeedbackStatusResolved,
        InvestXDesignTokens.success.withValues(alpha: 0.12),
        InvestXDesignTokens.success,
      ),
      FeedbackStatus.closed => (
        l10n.ipsFeedbackStatusClosed,
        InvestXDesignTokens.muted.withValues(alpha: 0.12),
        InvestXDesignTokens.muted,
      ),
      FeedbackStatus.pending => (
        l10n.ipsFeedbackStatusReviewing,
        InvestXDesignTokens.selectionBlue.withValues(alpha: 0.12),
        InvestXDesignTokens.selectionBlue,
      ),
      String() => throw UnimplementedError(),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(10),
        vertical: responsive.dp(4),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(responsive.radius(12)),
      ),
      child: CustomText(
        label,
        variant: MiniAppTextVariant.caption,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: MiniAppTypography.semiBold,
          fontSize: responsive.dp(11),
        ),
      ),
    );
  }
}
