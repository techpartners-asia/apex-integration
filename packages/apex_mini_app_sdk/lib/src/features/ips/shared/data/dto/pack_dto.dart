import '../../../../../core/api/api_parser.dart';
import '../../domain/models/ips_models.dart';

class PackDto {
  final int isRecommended;
  final String packCode;
  final String name;
  final String? name2;
  final String? packDesc;
  final double bondPercent;
  final double stockPercent;
  final double assetPercent;

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

  static List<PackDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(raw).map(PackDto.fromJson).toList(growable: false);
  }

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
