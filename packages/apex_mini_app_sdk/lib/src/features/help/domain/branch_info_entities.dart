import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Canonical social-media type values returned by the company info endpoint.
class SocialMediaType {
  /// Facebook profile link type.
  static const String facebook = 'facebook';

  /// Instagram profile link type.
  static const String instagram = 'instagram';

  /// X profile link type.
  static const String x = 'x';

  /// Legacy Twitter profile link type.
  static const String twitter = 'twitter';

  /// LinkedIn profile link type.
  static const String linkedin = 'linkedin';

  /// YouTube profile link type.
  static const String youtube = 'youtube';

  /// TikTok profile link type.
  static const String tiktok = 'tiktok';

  /// Generic website link type.
  static const String website = 'website';
}

/// Canonical weekday values used by branch schedule payloads.
class DayOfWeekType {
  /// Monday schedule key.
  static const String monday = 'monday';

  /// Tuesday schedule key.
  static const String tuesday = 'tuesday';

  /// Wednesday schedule key.
  static const String wednesday = 'wednesday';

  /// Thursday schedule key.
  static const String thursday = 'thursday';

  /// Friday schedule key.
  static const String friday = 'friday';

  /// Saturday schedule key.
  static const String saturday = 'saturday';

  /// Sunday schedule key.
  static const String sunday = 'sunday';
}

/// A link displayed on the Help screen for one company social channel.
class SocialMediaEntity {
  /// Backend identifier for the social media row.
  final int? id;

  /// Company identifier that owns the social link.
  final int? companyId;

  /// Human-readable label for the link.
  final String? name;

  /// URL or deep link launched when the user taps the social chip.
  final String? link;

  /// Optional icon URL supplied by the backend.
  final String? iconUrl;

  /// Channel type, normally one of [SocialMediaType].
  final String? type;

  /// Backend creation timestamp.
  final String? createdAt;

  /// Backend update timestamp.
  final String? updatedAt;

  /// Creates a social-media link entity.
  const SocialMediaEntity({
    this.id,
    this.companyId,
    this.name,
    this.link,
    this.iconUrl,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses a social link using tolerant conversions for older payloads.
  factory SocialMediaEntity.fromJson(Map<String, Object?> json) {
    return SocialMediaEntity(
      id: ApiParser.asNullableInt(json['id']),
      companyId: ApiParser.asNullableInt(json['company_id']),
      name: ApiParser.asNullableString(json['name']),
      link: ApiParser.asNullableString(json['link']),
      iconUrl: ApiParser.asNullableString(json['icon_url']),
      type: ApiParser.asNullableString(json['type']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  /// Best label for display, falling back to the link when no name exists.
  String get displayLabel {
    return name?.trim().isNotEmpty == true
        ? name!.trim()
        : link?.trim().isNotEmpty == true
        ? link!.trim()
        : '';
  }
}

/// Branch location, schedule, map coordinates, and gallery data.
class LocationEntity {
  /// Backend identifier for the location row.
  final int? id;

  /// Company identifier that owns this location.
  final int? companyId;

  /// Public branch title.
  final String? title;

  /// Address or location description shown on Help.
  final String? description;

  /// First schedule day, if the backend provides one.
  final String? startDay;

  /// Last schedule day, if the backend provides one.
  final String? endDay;

  /// Opening time for the branch.
  final String? openTime;

  /// Closing time for the branch.
  final String? closeTime;

  /// Latitude used for external map launches.
  final double? latitude;

  /// Longitude used for external map launches.
  final double? longitude;

  /// Optional branch images displayed above the address card.
  final List<FileEntity> images;

  /// Backend creation timestamp.
  final String? createdAt;

  /// Backend update timestamp.
  final String? updatedAt;

  /// Creates a branch location entity.
  const LocationEntity({
    this.id,
    this.companyId,
    this.title,
    this.description,
    this.startDay,
    this.endDay,
    this.openTime,
    this.closeTime,
    this.latitude,
    this.longitude,
    this.images = const <FileEntity>[],
    this.createdAt,
    this.updatedAt,
  });

  /// Parses the location payload, accepting both legacy and camel-case keys.
  factory LocationEntity.fromJson(Map<String, Object?> json) {
    return LocationEntity(
      id: ApiParser.asNullableInt(json['id']),
      companyId: ApiParser.asNullableInt(json['company_id']),
      title: ApiParser.asNullableString(json['title']),
      description: ApiParser.asNullableString(json['description']),
      startDay:
          ApiParser.asNullableString(json['StartDay']) ??
          ApiParser.asNullableString(json['startDay']),
      endDay:
          ApiParser.asNullableString(json['EndDay']) ??
          ApiParser.asNullableString(json['endDay']),
      openTime:
          ApiParser.asNullableString(json['OpenTime']) ??
          ApiParser.asNullableString(json['openTime']),
      closeTime:
          ApiParser.asNullableString(json['CloseTime']) ??
          ApiParser.asNullableString(json['closeTime']),
      latitude: ApiParser.asNullableDouble(json['latitude']),
      longitude: ApiParser.asNullableDouble(json['longitude']),
      images: ApiParser.asObjectMapList(
        json['images'],
      ).map(FileEntity.fromJson).toList(growable: false),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  /// Whether this location can be opened in a map app.
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Whether any schedule field is present enough to render working hours.
  bool get hasSchedule =>
      startDay != null ||
      endDay != null ||
      openTime?.trim().isNotEmpty == true ||
      closeTime?.trim().isNotEmpty == true;
}

/// Support/contact payload shown on the Help tab.
class BranchInfoEntity {
  /// Backend company identifier.
  final int? id;

  /// Contact email address.
  final String? email;

  /// Contact phone number.
  final String? phone;

  /// Primary branch location.
  final LocationEntity? location;

  /// Social links displayed as quick chips.
  final List<SocialMediaEntity> socialLinks;

  /// Backend creation timestamp.
  final String? createdAt;

  /// Backend update timestamp.
  final String? updatedAt;

  /// Optional backend message.
  final String? message;

  /// Creates the Help/support branch info aggregate.
  const BranchInfoEntity({
    this.id,
    this.email,
    this.phone,
    this.location,
    this.socialLinks = const <SocialMediaEntity>[],
    this.createdAt,
    this.updatedAt,
    this.message,
  });

  /// Whether the Help screen can show the contact section.
  bool get hasContactInfo =>
      email?.trim().isNotEmpty == true || phone?.trim().isNotEmpty == true;

  /// Whether the Help screen can show the location section.
  bool get hasLocationInfo =>
      location != null &&
      ((location!.title?.trim().isNotEmpty == true) ||
          (location!.description?.trim().isNotEmpty == true) ||
          location!.hasSchedule ||
          location!.images.isNotEmpty ||
          location!.hasCoordinates);

  /// Whether the Help screen can show social link chips.
  bool get hasSocialLinks => socialLinks.isNotEmpty;

  /// Whether the payload contains any user-visible support content.
  bool get hasAnyContent => hasContactInfo || hasLocationInfo || hasSocialLinks;
}
