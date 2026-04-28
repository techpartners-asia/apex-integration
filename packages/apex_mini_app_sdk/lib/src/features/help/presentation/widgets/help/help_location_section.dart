part of '../help_sections.dart';

class HelpLocationSection extends StatelessWidget {
  final SdkLocalizations l10n;
  final LocationEntity location;

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
        .map((FileEntity image) => _httpUrlOrNull(image.physicalPath))
        .whereType<String>()
        .firstOrNull;
    final Uri? mapsUri = _googleMapsUri(location);

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
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(responsive.radius(20)),
            onTap: mapsUri == null
                ? null
                : () => _launchUri(
                    context,
                    mapsUri,
                    mode: LaunchMode.externalApplication,
                  ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(responsive.radius(20)),
                border: Border.all(color: DesignTokens.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: responsive.dp(160),
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) =>
                                const _LocationPlaceholder(),
                          )
                        : const _LocationPlaceholder(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(responsive.dp(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (location.title?.trim().isNotEmpty == true)
                          CustomText(
                            location.title!,
                            variant: MiniAppTextVariant.subtitle3,
                          ),
                        if (workingHours?.trim().isNotEmpty ==
                            true) ...<Widget>[
                          SizedBox(height: responsive.dp(4)),
                          CustomText(
                            workingHours!,
                            variant: MiniAppTextVariant.subtitle3,
                            color: DesignTokens.rose,
                          ),
                        ],
                        if (location.description?.trim().isNotEmpty ==
                            true) ...<Widget>[
                          SizedBox(height: responsive.dp(8)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: CustomText(
                                  location.description!,
                                  variant: MiniAppTextVariant.caption1,
                                  color: DesignTokens.muted,
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
