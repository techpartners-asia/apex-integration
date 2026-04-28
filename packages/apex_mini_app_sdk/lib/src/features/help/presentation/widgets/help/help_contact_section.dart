part of '../help_sections.dart';

class HelpContactSection extends StatelessWidget {
  final SdkLocalizations l10n;
  final BranchInfoEntity company;

  const HelpContactSection({
    super.key,
    required this.l10n,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final List<_ContactRowData> rows = <_ContactRowData>[
      if (company.email?.trim().isNotEmpty == true)
        _ContactRowData(
          label: l10n.ipsHelpEmail,
          value: company.email!,
          launchUri: _mailtoUri(company.email!),
          trailing: CustomImage(
            path: Img.view,
            width: responsive.dp(18),
            height: responsive.dp(18),
          ),
        ),
      if (company.phone?.trim().isNotEmpty == true)
        _ContactRowData(
          label: l10n.ipsHelpPhone,
          value: company.phone!,
          launchUri: _telUri(company.phone!),
          trailing: CustomImage(
            path: Img.call,
            width: responsive.dp(18),
            height: responsive.dp(18),
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: responsive.dp(4)),
          child: CustomText(
            l10n.ipsHelpContactTitle,
            variant: MiniAppTextVariant.subtitle2,
          ),
        ),
        ...rows.map(
          (e) => Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: AdaptiveCard(
              color: DesignTokens.white,
              child: _ContactRow(
                label: e.label,
                value: e.value,
                launchUri: e.launchUri,
                trailing: e.trailing,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
