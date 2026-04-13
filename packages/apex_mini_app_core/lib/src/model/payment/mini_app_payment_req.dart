class MiniAppPaymentReq {
  final String invoiceId;
  final double? amount;
  final String? currency;
  final String? description;
  final String? sourceRoute;
  final Map<String, Object?> metadata;

  MiniAppPaymentReq({
    required String invoiceId,
    this.amount,
    String? currency,
    String? description,
    String? sourceRoute,
    this.metadata = const <String, Object?>{},
  }) : invoiceId = normalizeRequired(invoiceId, 'invoiceId'),
       currency = normalizeOptional(currency),
       description = normalizeOptional(description),
       sourceRoute = normalizeOptional(sourceRoute) {
    final double? resolvedAmount = amount;
    if (resolvedAmount != null && resolvedAmount <= 0) {
      throw ArgumentError.value(
        resolvedAmount,
        'amount',
        'MiniAppPaymentReq.amount must be greater than zero when provided.',
      );
    }
  }

  static String normalizeRequired(String value, String fieldName) {
    final String normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        fieldName,
        'MiniAppPaymentReq.$fieldName must not be empty.',
      );
    }

    return normalized;
  }

  static String? normalizeOptional(String? value) {
    final String? normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
