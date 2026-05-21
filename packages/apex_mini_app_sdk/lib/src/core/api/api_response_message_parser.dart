/// Extracts readable backend messages from varied API response shapes.
final class ApiResponseMessageParser {
  const ApiResponseMessageParser._();

  /// Returns the first non-empty message found in [raw].
  static String? extract(Object? raw, {bool includeNested = true}) {
    return _extract(raw, includeNested: includeNested);
  }

  static String? _extract(
    Object? raw, {
    required bool includeNested,
    int depth = 0,
  }) {
    if (depth > 3) {
      return null;
    }

    if (raw is String) {
      return _normalize(raw);
    }

    if (raw is Iterable) {
      if (!includeNested && depth > 0) {
        return null;
      }
      for (final Object? item in raw) {
        final String? message = _extract(
          item,
          includeNested: includeNested,
          depth: depth + 1,
        );
        if (message != null) {
          return message;
        }
      }
      return null;
    }

    if (raw is Map) {
      final Map<String, Object?> json = raw.map(
        (Object? key, Object? value) => MapEntry(key.toString(), value),
      );

      final List<String> messageKeys = <String>[
        'responseDesc',
        'message',
        'errorMessage',
        'error_description',
        'error',
        'detail',
        if (depth == 0) 'title',
        if (includeNested) 'body',
        if (includeNested) 'errors',
      ];

      for (final String key in messageKeys) {
        final String? message = _extract(
          json[key],
          includeNested: includeNested,
          depth: depth + 1,
        );
        if (message != null) {
          return message;
        }
      }
    }

    return null;
  }

  static String? _normalize(String? raw) {
    final String value = raw?.trim() ?? '';
    if (value.isEmpty) {
      return null;
    }
    return value.length > 200 ? '${value.substring(0, 200)}...' : value;
  }
}
