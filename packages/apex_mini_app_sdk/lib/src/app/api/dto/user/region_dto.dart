part of '../user_entity_dto.dart';

class RegionDto {
  final String? alpha2;
  final String? createdAt;
  final int? id;
  final String? name;
  final String? updatedAt;

  const RegionDto({
    this.alpha2,
    this.createdAt,
    this.id,
    this.name,
    this.updatedAt,
  });

  factory RegionDto.fromJson(Map<String, Object?> json) {
    return RegionDto(
      alpha2: ApiParser.asNullableString(json['alpha2']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      id: ApiParser.asNullableInt(json['id']),
      name: ApiParser.asNullableString(json['name']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  RegionDto copyWith({
    String? alpha2,
    String? createdAt,
    int? id,
    String? name,
    String? updatedAt,
  }) {
    return RegionDto(
      alpha2: alpha2 ?? this.alpha2,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
