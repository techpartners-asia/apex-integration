import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:url_launcher/url_launcher.dart';
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
                      if (company.hasContactInfo) ...<Widget>[
                        /// Contact section
                        _ContactSection(l10n: l10n, company: company),
                        SizedBox(height: responsive.dp(10)),
                      ],

                      /// Social links section
                      if (company.hasSocialLinks) ...<Widget>[
                        _SocialLinksSection(links: company.socialLinks),
                        SizedBox(height: responsive.spacing.sectionSpacing),
                      ],

                      /// Location section
                      if (company.hasLocationInfo) _LocationSection(l10n: l10n, location: company.location!),
                      SizedBox(height: responsive.spacing.sectionSpacing * 2),
                    ],
                  ),
                ),
              ),
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

class _ContactSection extends StatelessWidget {
  final SdkLocalizations l10n;
  final BranchInfoEntity company;

  const _ContactSection({
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
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

class _ContactRowData {
  final String label;
  final String value;
  final Uri? launchUri;
  final Widget? trailing;

  const _ContactRowData({
    required this.label,
    required this.value,
    this.launchUri,
    this.trailing,
  });
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  final Uri? launchUri;
  final Widget? trailing;

  const _ContactRow({
    required this.label,
    required this.value,
    this.launchUri,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(18),
        vertical: responsive.dp(14),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  label,
                  variant: MiniAppTextVariant.caption,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DesignTokens.muted,
                  ),
                ),
                SizedBox(height: responsive.dp(4)),
                CustomText(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: MiniAppTypography.semiBold,
                  ),
                ),
              ],
            ),
          ),
          if (trailing case final Widget w) w,
        ],
      ),
    );

    if (launchUri == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _launchUri(context, launchUri!),
      child: content,
    );
  }
}

class _SocialLinksSection extends StatelessWidget {
  final List<SocialMediaEntity> links;

  const _SocialLinksSection({required this.links});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double spacing = responsive.dp(12);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: links.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _SocialChip(link: links[index]);
      },
    );
  }
}

class _SocialChip extends StatelessWidget {
  final SocialMediaEntity link;

  const _SocialChip({required this.link});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final _SocialMeta meta = _socialMeta(link.type ?? '');
    final String? iconUrl = _httpUrlOrNull(link.iconUrl);
    final Uri? linkUri = _webUri(link.link);

    final Widget content = AdaptiveCard(
      color: DesignTokens.white,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(14),
        vertical: responsive.dp(12),
      ),
      borderRadius: BorderRadius.circular(responsive.radius(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: CustomText(
              '@${link.displayLabel}',
              variant: MiniAppTextVariant.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: MiniAppTypography.semiBold,
                color: DesignTokens.ink,
              ),
            ),
          ),
          SizedBox(height: responsive.dp(10)),
          Container(
            width: responsive.dp(32),
            height: responsive.dp(32),
            decoration: BoxDecoration(
              color: meta.color,
              borderRadius: BorderRadius.circular(responsive.radius(8)),
            ),
            clipBehavior: Clip.antiAlias,
            child: iconUrl != null
                ? CachedNetworkImage(
                    imageUrl: iconUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Icon(
                      meta.icon,
                      color: Colors.white,
                      size: responsive.dp(16),
                    ),
                  )
                : Icon(
                    meta.icon,
                    color: Colors.white,
                    size: responsive.dp(16),
                  ),
          ),
        ],
      ),
    );

    if (linkUri == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(responsive.radius(14)),
      onTap: () => _launchUri(
        context,
        linkUri,
        mode: LaunchMode.externalApplication,
      ),
      child: content,
    );
  }
}

class _LocationSection extends StatelessWidget {
  final SdkLocalizations l10n;
  final LocationEntity location;

  const _LocationSection({required this.l10n, required this.location});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final String? workingHours = _buildWorkingHoursLabel(context, location);
    final String? imageUrl = location.images.map((FileEntity image) => _httpUrlOrNull(image.physicalPath)).whereType<String>().firstOrNull;
    final Uri? mapsUri = _googleMapsUri(location);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: responsive.dp(4)),
          child: CustomText(
            l10n.ipsHelpLocationTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
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
                            errorWidget: (_, _, _) => _LocationPlaceholder(),
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
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: MiniAppTypography.bold,
                            ),
                          ),
                        if (workingHours?.trim().isNotEmpty == true) ...<Widget>[
                          SizedBox(height: responsive.dp(4)),
                          CustomText(
                            workingHours!,
                            variant: MiniAppTextVariant.caption,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: DesignTokens.rose,
                              fontWeight: MiniAppTypography.semiBold,
                            ),
                          ),
                        ],
                        if (location.description?.trim().isNotEmpty == true) ...<Widget>[
                          SizedBox(height: responsive.dp(8)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: CustomText(
                                  location.description!,
                                  variant: MiniAppTextVariant.caption,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: DesignTokens.muted,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                              SizedBox(width: responsive.dp(8)),
                              CustomImage(path: Img.loc, width: responsive.dp(20), height: responsive.dp(20)),
                              // Icon(
                              //   mapsUri == null ? Icons.location_on_outlined : Icons.open_in_new_rounded,
                              //   color: DesignTokens.selectionBlue,
                              //   size: responsive.dp(20),
                              // ),
                            ],
                          ),
                        ],
                        // if (location.hasCoordinates) ...<Widget>[
                        //   SizedBox(height: responsive.dp(10)),
                        //   CustomText(
                        //     '${location.latitude}, ${location.longitude}',
                        //     variant: MiniAppTextVariant.caption,
                        //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        //       color: DesignTokens.muted,
                        //     ),
                        //   ),
                        // ],
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

class _LocationPlaceholder extends StatelessWidget {
  const _LocationPlaceholder();

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Container(
      color: const Color(0xFFE8EBF2),
      child: Center(
        child: Icon(
          Icons.map_outlined,
          size: responsive.dp(48),
          color: DesignTokens.muted,
        ),
      ),
    );
  }
}

class _SocialMeta {
  final IconData icon;
  final Color color;

  const _SocialMeta({
    required this.icon,
    required this.color,
  });
}

_SocialMeta _socialMeta(String type) {
  return switch (type) {
    SocialMediaType.instagram => const _SocialMeta(
      icon: Icons.camera_alt_outlined,
      color: Color(0xFFE1306C),
    ),
    SocialMediaType.facebook => const _SocialMeta(
      icon: Icons.facebook_outlined,
      color: Color(0xFF1877F2),
    ),
    SocialMediaType.twitter => const _SocialMeta(
      icon: Icons.alternate_email_rounded,
      color: Color(0xFF111827),
    ),
    SocialMediaType.linkedin => const _SocialMeta(
      icon: Icons.work_outline,
      color: Color(0xFF0A66C2),
    ),
    SocialMediaType.youtube => const _SocialMeta(
      icon: Icons.play_circle_outline,
      color: Color(0xFFFF0000),
    ),
    SocialMediaType.tiktok => const _SocialMeta(
      icon: Icons.music_note_rounded,
      color: Color(0xFF111827),
    ),
    SocialMediaType.website => const _SocialMeta(
      icon: Icons.language_rounded,
      color: Color(0xFF0F766E),
    ),
    // TODO: Handle this case.
    String() => throw UnimplementedError(),
  };
}

String? _buildWorkingHoursLabel(BuildContext context, LocationEntity location) {
  final String? dayRange = _formatDayRange(context, location.startDay, location.endDay);
  final String? timeRange = _formatTimeRange(location.openTime, location.closeTime);

  if (dayRange == null && timeRange == null) return null;
  return <String>[
    if (dayRange case final String value) value,
    if (timeRange case final String value) value,
  ].join(' ');
}

String? _formatDayRange(BuildContext context, String? startDay, String? endDay) {
  if (startDay == null && endDay == null) return null;
  final String start = _dayLabel(context, startDay ?? endDay!);
  final String end = _dayLabel(context, endDay ?? startDay!);
  return start == end ? start : '$start - $end';
}

String? _formatTimeRange(String? openTime, String? closeTime) {
  final String? open = openTime?.trim().isNotEmpty == true ? openTime!.trim() : null;
  final String? close = closeTime?.trim().isNotEmpty == true ? closeTime!.trim() : null;
  if (open == null && close == null) return null;
  if (open != null && close != null) return '$open - $close';
  return open ?? close;
}

String _dayLabel(BuildContext context, String day) {
  final bool isMongolian = Localizations.localeOf(context).languageCode == 'mn';
  return switch (day) {
    DayOfWeekType.monday => isMongolian ? 'Даваа' : 'Mon',
    DayOfWeekType.tuesday => isMongolian ? 'Мягмар' : 'Tue',
    DayOfWeekType.wednesday => isMongolian ? 'Лхагва' : 'Wed',
    DayOfWeekType.thursday => isMongolian ? 'Пүрэв' : 'Thu',
    DayOfWeekType.friday => isMongolian ? 'Баасан' : 'Fri',
    DayOfWeekType.saturday => isMongolian ? 'Бямба' : 'Sat',
    DayOfWeekType.sunday => isMongolian ? 'Ням' : 'Sun',
    String() => throw UnimplementedError(),
  };
}

String? _httpUrlOrNull(String? raw) {
  final String? value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  final Uri? uri = Uri.tryParse(value);
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
    return null;
  }
  return value;
}

Uri? _mailtoUri(String raw) {
  final String value = raw.trim();
  if (value.isEmpty) return null;
  return Uri(
    scheme: 'mailto',
    path: value,
  );
}

Uri? _telUri(String raw) {
  final String cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '').trim();
  if (cleaned.isEmpty) return null;
  return Uri(
    scheme: 'tel',
    path: cleaned,
  );
}

Uri? _webUri(String? raw) {
  final String? value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  final Uri? parsed = Uri.tryParse(value);
  if (parsed == null) return null;
  if (parsed.hasScheme) return parsed;
  return Uri.tryParse('https://$value');
}

Uri? _googleMapsUri(LocationEntity location) {
  if (location.hasCoordinates) {
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
    );
  }

  final String query = <String>[
    if (location.title?.trim().isNotEmpty == true) location.title!.trim(),
    if (location.description?.trim().isNotEmpty == true) location.description!.trim(),
  ].join(', ');

  if (query.isEmpty) return null;

  return Uri.https(
    'www.google.com',
    '/maps/search/',
    <String, String>{
      'api': '1',
      'query': query,
    },
  );
}

Future<void> _launchUri(
  BuildContext context,
  Uri uri, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  final String message = context.l10n.errorsActionFailed;
  final bool canLaunch = await canLaunchUrl(uri);
  if (!context.mounted) {
    return;
  }
  if (!canLaunch) {
    MiniAppToast.showError(context, message: message);
    return;
  }

  final bool launched = await launchUrl(uri, mode: mode);
  if (!context.mounted) {
    return;
  }
  if (!launched) {
    MiniAppToast.showError(context, message: message);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
