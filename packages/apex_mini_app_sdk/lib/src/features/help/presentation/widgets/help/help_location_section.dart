part of '../help_sections.dart';

/// Renders the branch image, address, schedule, and map action.
class HelpLocationSection extends StatelessWidget {
  /// Localized labels for the location section.
  final SdkLocalizations l10n;

  /// Location payload to display.
  final LocationEntity location;

  /// Creates a branch location card.
  const HelpLocationSection({
    super.key,
    required this.l10n,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final String? workingHours = _buildWorkingHoursLabel(context, location);
    final String? imageUrl = location.images
        .map((FileEntity image) => image.physicalPath)
        .whereType<String>()
        .firstOrNull;
    final Uri? mapsUri = _googleMapsUri(location);
    final double radius = responsive.radius(20);
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    final Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: SizedBox(
              height: responsive.dp(160),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl:
                          '${StaticApiConfig.techInvestXStorageUrl}$imageUrl',
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const _LocationPlaceholder(),
                    )
                  : const _LocationPlaceholder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(responsive.dp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (location.title?.trim().isNotEmpty == true)
                CustomText(
                  location.title!,
                  variant: MiniAppTextVariant.subtitle2,
                ),
              if (workingHours?.trim().isNotEmpty == true) ...<Widget>[
                SizedBox(height: responsive.dp(4)),
                CustomText(
                  workingHours!,
                  variant: MiniAppTextVariant.body3,
                  color: DesignTokens.muted,
                ),
              ],
              if (location.description?.trim().isNotEmpty == true) ...<Widget>[
                SizedBox(height: responsive.dp(15)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: CustomText(
                        location.description!,
                        variant: MiniAppTextVariant.body3,
                      ),
                    ),
                    SizedBox(width: responsive.dp(8)),
                    CustomImage(
                      path: Img.loc,
                      width: responsive.dp(20),
                      height: responsive.dp(20),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: responsive.dp(4)),
          child: CustomText(
            l10n.ipsHelpLocationTitle,
            variant: MiniAppTextVariant.subtitle2,
          ),
        ),
        SizedBox(height: responsive.spacing.cardGap),
        MiniAppGlassCard(
          radius: radius,
          padding: EdgeInsets.zero,
          child: mapsUri == null
              ? cardContent
              : Material(
                  color: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  child: InkWell(
                    borderRadius: borderRadius,
                    splashColor: DesignTokens.ink.withValues(alpha: 0.05),
                    highlightColor: DesignTokens.ink.withValues(alpha: 0.03),
                    onTap: () => _launchUri(
                      context,
                      mapsUri,
                      mode: LaunchMode.externalApplication,
                    ),
                    child: cardContent,
                  ),
                ),
        ),
      ],
    );
  }
}
