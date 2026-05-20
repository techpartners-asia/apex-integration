import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for company/help information.
class CompanyInfoResponseDto {
  /// Parsed branch/company info entity.
  final BranchInfoEntity entity;

  /// Creates a company info response DTO.
  const CompanyInfoResponseDto({required this.entity});

  /// Parses and validates company information response.
  factory CompanyInfoResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Failed to load company info.',
    );

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);
    final Map<String, Object?> source = body.isNotEmpty ? body : json;
    final Map<String, Object?> locationJson = _resolveLocationJson(source);
    final List<SocialMediaEntity> socialLinks = _resolveSocialLinks(
      source,
      source,
    );

    return CompanyInfoResponseDto(
      entity: BranchInfoEntity(
        id: ApiParser.asNullableInt(source['id']) ?? 0,
        email: ApiParser.asNullableString(source['email']) ?? '',
        phone: ApiParser.asNullableString(source['phone']) ?? '',
        location: locationJson.isEmpty
            ? null
            : LocationEntity.fromJson(locationJson),
        socialLinks: socialLinks,
        createdAt: ApiParser.asNullableString(source['created_at']) ?? '',
        updatedAt: ApiParser.asNullableString(source['updated_at']) ?? '',
        message:
            ApiActionResultParser.messageOf(json) ??
            ApiParser.asNullableString(source['message']),
      ),
    );
  }
}

Map<String, Object?> _resolveLocationJson(Map<String, Object?> source) {
  final Object? rawLocations = source['locations'];
  if (rawLocations is List) {
    final List<Map<String, Object?>> items = ApiParser.asObjectMapList(
      rawLocations,
    );
    if (items.isNotEmpty) return items.first;
  }

  return ApiParser.asObjectMap(rawLocations);
}

List<SocialMediaEntity> _resolveSocialLinks(
  Map<String, Object?> source,
  Map<String, Object?> json,
) {
  final Object? rawLinks = json['social_links'];

  return ApiParser.asObjectMapList(
    rawLinks,
  ).map(SocialMediaEntity.fromJson).toList(growable: false);
}
