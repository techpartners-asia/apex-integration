import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// DTO for an investment pack returned by the pack API.
class PackDto {
  /// Backend recommendation flag.
  final int isRecommended;

  /// Backend pack code.
  final String packCode;

  /// Primary pack name.
  final String name;

  /// Secondary/localized pack name.
  final String? name2;

  /// Pack description.
  final String? packDesc;

  /// Bond allocation percentage.
  final double bondPercent;

  /// Stock allocation percentage.
  final double stockPercent;

  /// Asset/cash allocation percentage.
  final double assetPercent;

  /// Creates an investment package DTO.
  const PackDto({
    required this.isRecommended,
    required this.packCode,
    required this.name,
    this.name2,
    this.packDesc,
    required this.bondPercent,
    required this.stockPercent,
    required this.assetPercent,
  });

  /// Parses a pack row with safe numeric defaults.
  factory PackDto.fromJson(Map<String, dynamic> json) {
    return PackDto(
      isRecommended: json['isRecommended'] ?? 0,
      packCode: ApiParser.asNullableString(json['packCode']) ?? '',
      name: ApiParser.asNullableString(json['name']) ?? '',
      name2: ApiParser.asNullableString(json['name2']),
      packDesc: ApiParser.asNullableString(json['packDesc']),
      bondPercent: ApiParser.asNullableDouble(json['bondPercent']) ?? 0,
      stockPercent: ApiParser.asNullableDouble(json['stockPercent']) ?? 0,
      assetPercent: ApiParser.asNullableDouble(json['assetPercent']) ?? 0,
    );
  }

  /// Parses a raw list response into pack DTOs.
  static List<PackDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(
      raw,
    ).map(PackDto.fromJson).toList(growable: false);
  }

  /// Converts this DTO to the domain pack model.
  IpsPack toDomain() {
    return IpsPack(
      packCode: packCode,
      name: name,
      name2: name2,
      packDesc: packDesc,
      isRecommended: isRecommended,
      bondPercent: bondPercent,
      stockPercent: stockPercent,
      assetPercent: assetPercent,
    );
  }
}
