class MiniAppFailure {
  final String code;
  final String message;
  final Map<String, Object?> details;

  MiniAppFailure({
    required String code,
    required this.message,
    this.details = const <String, Object?>{},
  }) : code = normalizeCode(code);

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
