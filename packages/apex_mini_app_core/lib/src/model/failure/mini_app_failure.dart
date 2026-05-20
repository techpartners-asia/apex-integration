/// Structured failure object shared across launch, payment, and host callbacks.
class MiniAppFailure {
  /// Machine-readable failure code.
  final String code;

  /// Human-readable failure message.
  final String message;

  /// Optional additional context that can be logged or inspected by the host.
  final Map<String, Object?> details;

  /// Creates a structured failure and validates its machine-readable code.
  MiniAppFailure({
    required String code,
    required this.message,
    this.details = const <String, Object?>{},
  }) : code = normalizeCode(code);

  /// Trims and validates a failure code.
  static String normalizeCode(String value) {
    final String normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'code',
        'MiniAppFailure.code must not be empty.',
      );
    }

    return normalized;
  }
}
