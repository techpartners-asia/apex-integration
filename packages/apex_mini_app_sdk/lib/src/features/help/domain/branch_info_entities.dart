import 'package:mini_app_sdk/mini_app_sdk.dart';

class SocialMediaType {
  static const String facebook = 'facebook';
  static const String instagram = 'instagram';
  static const String x = 'x';
  static const String twitter = 'twitter';
  static const String linkedin = 'linkedin';
  static const String youtube = 'youtube';
  static const String tiktok = 'tiktok';
  static const String website = 'website';
}

class DayOfWeekType {
  static const String monday = 'monday';
  static const String tuesday = 'tuesday';
  static const String wednesday = 'wednesday';
  static const String thursday = 'thursday';
  static const String friday = 'friday';
  static const String saturday = 'saturday';
  static const String sunday = 'sunday';
}

class SocialMediaEntity {
  final int? id;
  final int? companyId;
  final String? name;
  final String? link;
  final String? iconUrl;
  final String? type;
  final String? createdAt;
  final String? updatedAt;

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

  String get displayLabel {
    return name?.trim().isNotEmpty == true
        ? name!.trim()
        : link?.trim().isNotEmpty == true
        ? link!.trim()
        : '';
  }
}

class LocationEntity {
  final int? id;
  final int? companyId;
  final String? title;
  final String? description;
  final String? startDay;
  final String? endDay;
  final String? openTime;
  final String? closeTime;
  final double? latitude;
  final double? longitude;
  final List<FileEntity> images;
  final String? createdAt;
  final String? updatedAt;

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

  factory LocationEntity.fromJson(Map<String, Object?> json) {
    return LocationEntity(
      id: ApiParser.asNullableInt(json['id']),
      companyId: ApiParser.asNullableInt(json['company_id']),
      title: ApiParser.asNullableString(json['title']),
      description: ApiParser.asNullableString(json['description']),
      startDay: ApiParser.asNullableString(json['StartDay']),
      endDay: ApiParser.asNullableString(json['endDay']),
      openTime: ApiParser.asNullableString(json['openTime']),
      closeTime: ApiParser.asNullableString(json['closeTime']),
      latitude: ApiParser.asNullableDouble(json['latitude']),
      longitude: ApiParser.asNullableDouble(json['longitude']),
      images: ApiParser.asObjectMapList(json['images']).map(FileEntity.fromJson).toList(growable: false),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get hasSchedule => startDay != null || endDay != null || openTime?.trim().isNotEmpty == true || closeTime?.trim().isNotEmpty == true;
}

class BranchInfoEntity {
  final int? id;
  final String? email;
  final String? phone;
  final LocationEntity? location;
  final List<SocialMediaEntity> socialLinks;
  final String? createdAt;
  final String? updatedAt;
  final String? message;

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

  bool get hasContactInfo => email?.trim().isNotEmpty == true || phone?.trim().isNotEmpty == true;

  bool get hasLocationInfo => location != null && ((location!.title?.trim().isNotEmpty == true) || (location!.description?.trim().isNotEmpty == true) || location!.hasSchedule || location!.images.isNotEmpty || location!.hasCoordinates);

  bool get hasSocialLinks => socialLinks.isNotEmpty;

  bool get hasAnyContent => hasContactInfo || hasLocationInfo || hasSocialLinks;
}
