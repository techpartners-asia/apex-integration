part of '../user_entity_dto.dart';

/// Region/country metadata nested in a user profile payload.
class RegionDto {
  /// ISO alpha-2 region code.
  final String? alpha2;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Region identifier.
  final int? id;

  /// Human-readable region name.
  final String? name;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Creates a user region DTO.
  const RegionDto({
    this.alpha2,
    this.createdAt,
    this.id,
    this.name,
    this.updatedAt,
  });

  /// Parses region metadata from backend JSON.
  factory RegionDto.fromJson(Map<String, Object?> json) {
    return RegionDto(
      alpha2: ApiParser.asNullableString(json['alpha2']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      id: ApiParser.asNullableInt(json['id']),
      name: ApiParser.asNullableString(json['name']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  /// Returns a copy with selected fields replaced.
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
