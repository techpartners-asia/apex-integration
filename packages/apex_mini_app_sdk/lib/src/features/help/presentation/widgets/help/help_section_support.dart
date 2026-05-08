part of '../help_sections.dart';

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
    _ => const _SocialMeta(
      icon: Icons.public_rounded,
      color: Color(0xFF64748B),
    ),
  };
}

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
  return Uri(scheme: 'mailto', path: value);
}

Uri? _telUri(String raw) {
  final String cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '').trim();
  if (cleaned.isEmpty) return null;
  return Uri(scheme: 'tel', path: cleaned);
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
