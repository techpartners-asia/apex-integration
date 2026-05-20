part of '../help_sections.dart';

/// View data for one support contact row.
class _ContactRowData {
  /// Row label, such as phone or email.
  final String label;

  /// Visible contact value.
  final String value;

  /// Optional URI launched when the row is tapped.
  final Uri? launchUri;

  /// Optional trailing widget, for example a chevron or icon.
  final Widget? trailing;

  /// Creates support contact row data.
  const _ContactRowData({
    required this.label,
    required this.value,
    this.launchUri,
    this.trailing,
  });
}

/// Tappable support row for phone, email, or address-like values.
class _ContactRow extends StatelessWidget {
  /// Row label.
  final String label;

  /// Row value.
  final String value;

  /// Optional launch target.
  final Uri? launchUri;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Creates a support contact row.
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
                  variant: MiniAppTextVariant.caption1,
                  color: DesignTokens.muted,
                ),
                SizedBox(height: responsive.dp(4)),
                CustomText(
                  value,
                  variant: MiniAppTextVariant.subtitle2,
                ),
              ],
            ),
          ),
          if (trailing case final Widget w) w,
        ],
      ),
    );

    if (launchUri == null) return content;

    return Material(
      color: DesignTokens.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _launchUri(context, launchUri!),
        child: content,
      ),
    );
  }
}

/// Social media chip that opens the configured external profile.
class _SocialChip extends StatelessWidget {
  /// Social media entity from company info.
  final SocialMediaEntity link;

  /// Creates a social link chip.
  const _SocialChip({required this.link});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final _SocialMeta meta = _socialMeta(link.type ?? '');
    final String? iconUrl = _httpUrlOrNull(link.iconUrl);
    final Uri? linkUri = _webUri(link.link);

    final Widget content = AdaptiveCard(
      color: linkUri == null ? DesignTokens.white : Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(14),
        vertical: responsive.dp(12),
      ),
      borderRadius: BorderRadius.circular(responsive.radius(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: CustomText(
              '@${link.displayLabel}',
              variant: MiniAppTextVariant.subtitle3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: DesignTokens.ink,
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

    return Material(
      color: DesignTokens.white,
      borderRadius: BorderRadius.circular(responsive.radius(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.radius(14)),
        onTap: () => _launchUri(
          context,
          linkUri,
          mode: LaunchMode.externalApplication,
        ),
        child: content,
      ),
    );
  }
}

/// Neutral map placeholder shown when no map image/component is available.
class _LocationPlaceholder extends StatelessWidget {
  /// Creates the location placeholder.
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

/// Visual metadata for a social link type.
class _SocialMeta {
  /// Fallback icon for the social network.
  final IconData icon;

  /// Brand-like fallback color for the icon container.
  final Color color;

  /// Creates social-link visual metadata.
  const _SocialMeta({
    required this.icon,
    required this.color,
  });
}

/// Resolves a social-network type into fallback icon/color metadata.
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
    _ => const _SocialMeta(
      icon: Icons.public_rounded,
      color: Color(0xFF64748B),
    ),
  };
}

/// Builds the combined weekday/time label for a branch location.
String? _buildWorkingHoursLabel(BuildContext context, LocationEntity location) {
  final String? dayRange = _formatDayRange(
    context,
    location.startDay,
    location.endDay,
  );
  final String? timeRange = _formatTimeRange(
    location.openTime,
    location.closeTime,
  );

  if (dayRange == null && timeRange == null) return null;
  return <String>[
    if (dayRange case final String value) value,
    if (timeRange case final String value) value,
  ].join(' ');
}

/// Formats a localized day range from backend weekday constants.
String? _formatDayRange(
  BuildContext context,
  String? startDay,
  String? endDay,
) {
  if (startDay == null && endDay == null) return null;
  final String start = _dayLabel(context, startDay ?? endDay!);
  final String end = _dayLabel(context, endDay ?? startDay!);
  return start == end ? start : '$start - $end';
}

/// Formats an open/close time range without dangling separators.
String? _formatTimeRange(String? openTime, String? closeTime) {
  final String? open = openTime?.trim().isNotEmpty == true
      ? openTime!.trim()
      : null;
  final String? close = closeTime?.trim().isNotEmpty == true
      ? closeTime!.trim()
      : null;
  if (open == null && close == null) return null;
  if (open != null && close != null) return '$open - $close';
  return open ?? close;
}

/// Localizes a backend weekday constant.
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
    _ => day.trim().isEmpty ? '-' : day.trim(),
  };
}

/// Returns a usable HTTP(S) URL string or null.
String? _httpUrlOrNull(String? raw) {
  final String? value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  final Uri? uri = Uri.tryParse(value);
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
    return null;
  }
  return value;
}

/// Builds a mailto URI for a non-empty email value.
Uri? _mailtoUri(String raw) {
  final String value = raw.trim();
  if (value.isEmpty) return null;
  return Uri(scheme: 'mailto', path: value);
}

/// Builds a tel URI after removing visual phone separators.
Uri? _telUri(String raw) {
  final String cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '').trim();
  if (cleaned.isEmpty) return null;
  return Uri(scheme: 'tel', path: cleaned);
}

/// Builds an external web URI, adding HTTPS when the scheme is omitted.
Uri? _webUri(String? raw) {
  final String? value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  final Uri? parsed = Uri.tryParse(value);
  if (parsed == null) return null;
  if (parsed.hasScheme) return parsed;
  return Uri.tryParse('https://$value');
}

/// Builds a Google Maps search URI from coordinates or text address.
Uri? _googleMapsUri(LocationEntity location) {
  if (location.hasCoordinates) {
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
    );
  }

  final String query = <String>[
    if (location.title?.trim().isNotEmpty == true) location.title!.trim(),
    if (location.description?.trim().isNotEmpty == true)
      location.description!.trim(),
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

/// Launches an external URI and shows an SDK toast if launch fails.
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

/// Local first-or-null helper used by help-section list building.
extension<T> on Iterable<T> {
  /// Returns the first item, or null for an empty iterable.
  T? get firstOrNull => isEmpty ? null : first;
}
