import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireResultView extends StatelessWidget {
  final QuestionnaireRes res;

  const QuestionnaireResultView({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    res.showRecomended = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GradientHeroCard(
          title: l10n.ipsQuestionnaireResTitle,
          subtitle: res.summary ?? l10n.ipsQuestionnaireSubtitle,
          body: Wrap(
            spacing: responsive.spacing.inlineSpacing,
            runSpacing: responsive.spacing.inlineSpacing,
            children: <Widget>[
              IpsStatusChip(
                label: '${l10n.ipsQuestionnaireScore}: ${res.score}',
                icon: Icons.fact_check_outlined,
                color: Colors.white,
              ),
              if (res.customerCode case final String code
                  when code.trim().isNotEmpty)
                IpsStatusChip(
                  label: code,
                  icon: Icons.badge_outlined,
                  color: Colors.white,
                ),
            ],
          ),
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        IpsSummaryCard(
          title: l10n.ipsQuestionnaireResTitle,
          subtitle: res.summary ?? l10n.ipsQuestionnaireSubtitle,
          primaryValue: res.score.toString(),
          icon: Icons.shield_outlined,
          trendLabel: l10n.ipsPackRecommendedBadge,
          trendTone: IpsTrendTone.positive,
          metrics: <IpsMetricTile>[
            if (res.customerCode case final String code
                when code.trim().isNotEmpty)
              IpsMetricTile(
                label: l10n.ipsQuestionnaireCustomerCode,
                value: code,
                icon: Icons.badge_outlined,
              ),
          ],
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        PrimaryButton(
          label: l10n.ipsQuestionnaireViewPacks,
          onPressed: () => launchIpsRoute(
            context,
            route: MiniAppRoutes.packs,
            arguments: res,
          ),
        ),
      ],
    );
  }
}
