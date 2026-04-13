import '../../../core/api/api_action_result_parser.dart';
import '../../../core/api/api_parser.dart';
import '../../../features/ips/help/domain/company_info_entities.dart';

class CompanyInfoResponseDto {
  final CompaniesEntity entity;

  const CompanyInfoResponseDto({required this.entity});

  factory CompanyInfoResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(json, fallbackErrorMessage: 'Failed to load company info.');

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);
    final Map<String, Object?> source = body.isNotEmpty ? body : json;
    final Map<String, Object?> locationJson = _resolveLocationJson(source);
    final Map<String, Object?> nestedCompanyJson = ApiParser.asObjectMap(locationJson['company']);

    final List<SocialMediaEntity> socialLinks = _resolveSocialLinks(source, locationJson, nestedCompanyJson);

    return CompanyInfoResponseDto(
      entity: CompaniesEntity(
        id: ApiParser.asNullableInt(source['id']) ?? ApiParser.asNullableInt(nestedCompanyJson['id']),
        email: ApiParser.asNullableString(source['email']) ?? ApiParser.asNullableString(nestedCompanyJson['email']),
        phone: ApiParser.asNullableString(source['phone']) ?? ApiParser.asNullableString(nestedCompanyJson['phone']),
        location: locationJson.isEmpty ? null : LocationEntity.fromJson(locationJson),
        socialLinks: socialLinks,
        createdAt: ApiParser.asNullableString(source['created_at']) ?? ApiParser.asNullableString(nestedCompanyJson['created_at']),
        updatedAt: ApiParser.asNullableString(source['updated_at']) ?? ApiParser.asNullableString(nestedCompanyJson['updated_at']),
        message: ApiActionResultParser.messageOf(json) ?? ApiParser.asNullableString(source['message']),
      ),
    );
  }
}

Map<String, Object?> _resolveLocationJson(Map<String, Object?> source) {
  final Object? rawLocations = source['locations'];
  if (rawLocations is List) {
    final List<Map<String, Object?>> items = ApiParser.asObjectMapList(rawLocations);
    if (items.isNotEmpty) return items.first;
  }

  return ApiParser.asObjectMap(rawLocations);
}

List<SocialMediaEntity> _resolveSocialLinks(
  Map<String, Object?> source,
  Map<String, Object?> locationJson,
  Map<String, Object?> nestedCompanyJson,
) {
  final Object? rawLinks = nestedCompanyJson['socialLinks'] ?? nestedCompanyJson['SocialLinks'] ?? source['socialLinks'] ?? source['SocialLinks'] ?? locationJson['socialLinks'] ?? locationJson['SocialLinks'];

  return ApiParser.asObjectMapList(rawLinks).map(SocialMediaEntity.fromJson).toList(growable: false);
}
