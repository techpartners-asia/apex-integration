part of '../help_sections.dart';

/// Renders tappable email and phone contact rows on the Help screen.
class HelpContactSection extends StatelessWidget {
  /// Localized labels for contact rows.
  final SdkLocalizations l10n;

  /// Company payload that supplies email and phone values.
  final BranchInfoEntity company;

  /// Creates a contact section for the supplied company data.
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
            width: responsive.dp(15),
            height: responsive.dp(15),
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
            child: _ContactRow(
              label: e.label,
              value: e.value,
              launchUri: e.launchUri,
              trailing: e.trailing,
            ),
          ),
        ),
      ],
    );
  }
}
