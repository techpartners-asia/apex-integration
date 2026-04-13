import '../../../../../core/exception/api_exception.dart';
import '../../../../../core/api/api_parser.dart';
import '../../domain/models/ips_models.dart';
import '../../constants/ips_defaults.dart';

class CaspoTransactionType {
  static const String all = 'A';
  static const String buy = 'B';
  static const String sell = 'S';
}

class IpsOrderDto {
  final String id;
  final String title;
  final IpsOrderStatus status;
  final double amount;
  final DateTime createdAt;
  final String? packCode;
  final int? packQty;
  final String? registerCode;
  final DateTime? expiresAt;
  final String buySell;

  const IpsOrderDto({
    required this.id,
    required this.title,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.buySell,
    this.packCode,
    this.packQty,
    this.registerCode,
    this.expiresAt,
  });

  factory IpsOrderDto.fromJson(Map<String, Object?> json) {
    final int orderNo = ApiParser.asNullableInt(json['orderNo']) ?? 0;
    final String statusText = ApiParser.asNullableString(json['status']) ?? 'PENDING';

    return IpsOrderDto(
      id: orderNo.toString(),
      title: ApiParser.asNullableString(json['packCode']) ?? IpsDefaults.orderTitleFallback,
      buySell: ApiParser.asNullableString(json['buySell']) ?? CaspoTransactionType.buy,
      status: mapOrderStatus(statusText),
      amount: ApiParser.asNullableDouble(json['packQty']) ?? 0,
      createdAt: ApiParser.asNullableDateTime(json['orderDate']) ?? DateTime.now(),
      packCode: ApiParser.asNullableString(json['packCode']),
      packQty: ApiParser.asNullableInt(json['packQty']),
      registerCode: ApiParser.asNullableString(json['registerCode']),
      expiresAt: ApiParser.asNullableDateTime(json['expireDate']),
    );
  }

  static List<IpsOrderDto> listFromResponse(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: ApiParser.asNullableString(json['responseDesc']) ?? 'IPS order list req failed.',
      );
    }

    return ApiParser.asObjectMapList(
      json['responseData'],
    ).map(IpsOrderDto.fromJson).toList(growable: false);
  }

  IpsOrder toDomain() {
    return IpsOrder(
      id: id,
      orderNo: int.tryParse(id.split(':').first.trim()) ?? 0,
      title: title,
      status: status,
      amount: amount,
      createdAt: createdAt,
      packCode: packCode,
      packQty: packQty,
      registerCode: registerCode,
      expiresAt: expiresAt,
      buySell: buySell,
    );
  }

  static IpsOrderStatus mapOrderStatus(String raw) {
    final String normalized = raw.trim().toLowerCase();
    if (normalized.contains('cancel')) {
      return IpsOrderStatus.cancelled;
    }

    if (normalized.contains('fail') || normalized.contains('reject')) {
      return IpsOrderStatus.failed;
    }

    if (normalized.contains('done') || normalized.contains('success') || normalized.contains('complete')) {
      return IpsOrderStatus.completed;
    }

    return IpsOrderStatus.pending;
  }
}
