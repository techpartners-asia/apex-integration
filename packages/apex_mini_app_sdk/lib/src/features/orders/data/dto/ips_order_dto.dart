import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Backend transaction side constants used by IPS order payloads.
class CaspoTransactionType {
  /// All transaction types.
  static const String all = 'A';

  /// Buy transaction.
  static const String buy = 'B';

  /// Sell transaction.
  static const String sell = 'S';
}

/// DTO for an IPS order row returned by the order list endpoint.
class IpsOrderDto {
  /// String id derived from the backend order number.
  final String id;

  /// Display title for the order.
  final String title;

  /// Normalized order status.
  final IpsOrderStatus status;

  /// Amount or quantity value returned by the backend.
  final double amount;

  /// Parsed order creation date.
  final DateTime createdAt;

  /// Package code attached to this order.
  final String? packCode;

  /// Package name attached to this order.
  final String? packName;

  /// Package quantity.
  final int? packQty;

  /// User registration number attached to the order.
  final String? registerCode;

  /// Parsed expiration date, if present.
  final DateTime? expiresAt;

  /// Raw buy/sell side value.
  final String buySell;

  /// Creates an IPS order DTO.
  const IpsOrderDto({
    required this.id,
    required this.title,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.buySell,
    this.packCode,
    this.packName,
    this.packQty,
    this.registerCode,
    this.expiresAt,
  });

  /// Parses a single order row.
  factory IpsOrderDto.fromJson(Map<String, Object?> json) {
    final int orderNo = ApiParser.asNullableInt(json['orderNo']) ?? 0;
    final String statusText =
        ApiParser.asNullableString(json['status']) ?? 'PENDING';

    return IpsOrderDto(
      id: orderNo.toString(),
      title:
          ApiParser.asNullableString(json['packName']) ??
          ApiParser.asNullableString(json['packCode']) ??
          IpsDefaults.orderTitleFallback,
      buySell:
          ApiParser.asNullableString(json['buySell']) ??
          CaspoTransactionType.buy,
      status: mapOrderStatus(statusText),
      amount: ApiParser.asNullableDouble(json['packQty']) ?? 0,
      createdAt:
          ApiParser.asNullableDateTime(json['orderDate']) ?? DateTime.now(),
      packCode: ApiParser.asNullableString(json['packCode']),
      packName: ApiParser.asNullableString(json['packName']),
      packQty: ApiParser.asNullableInt(json['packQty']),
      registerCode: ApiParser.asNullableString(json['registerCode']),
      expiresAt: ApiParser.asNullableDateTime(json['expireDate']),
    );
  }

  /// Parses and validates the order-list response.
  static List<IpsOrderDto> listFromResponse(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message:
            ApiParser.asNullableString(json['responseDesc']) ??
            'IPS order list req failed.',
      );
    }

    return ApiParser.asObjectMapList(
      json['responseData'],
    ).map(IpsOrderDto.fromJson).toList(growable: false);
  }

  /// Converts this DTO to the domain order model.
  IpsOrder toDomain() {
    return IpsOrder(
      id: id,
      orderNo: int.tryParse(id.split(':').first.trim()) ?? 0,
      title: title,
      status: status,
      amount: amount,
      createdAt: createdAt,
      packCode: packCode,
      packName: packName,
      packQty: packQty,
      registerCode: registerCode,
      expiresAt: expiresAt,
      buySell: buySell,
    );
  }

  /// Maps raw backend status text into a UI order status.
  static IpsOrderStatus mapOrderStatus(String raw) {
    final String normalized = raw.trim().toLowerCase();
    switch (normalized) {
      case 'c':
        return IpsOrderStatus.cancelled;
      case 'd':
      case 's':
        return IpsOrderStatus.completed;
      case 'di':
        return IpsOrderStatus.allocated;
      case 'f':
        return IpsOrderStatus.failed;
      case 'n':
        return IpsOrderStatus.pending;
      case 'p':
        return IpsOrderStatus.confirmed;
    }

    if (normalized.contains('cancel')) return IpsOrderStatus.cancelled;
    if (normalized.contains('fail') || normalized.contains('reject')) {
      return IpsOrderStatus.failed;
    }
    if (normalized.contains('done') ||
        normalized.contains('success') ||
        normalized.contains('complete')) {
      return IpsOrderStatus.completed;
    }

    return IpsOrderStatus.pending;
  }
}
