/// Safe JSON parsing helpers used by DTOs.
class ApiParser {
  const ApiParser._();

  /// Converts maps with any key type into `Map<String, Object?>`.
  static Map<String, Object?> asObjectMap(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (Object? key, Object? mapValue) => MapEntry(key.toString(), mapValue),
      );
    }

    return const <String, Object?>{};
  }

  /// Converts a list of raw objects into a list of object maps.
  static List<Map<String, Object?>> asObjectMapList(Object? value) {
    if (value is! List) {
      return const <Map<String, Object?>>[];
    }

    return value
        .map<Map<String, Object?>>((Object? item) => asObjectMap(item))
        .toList(growable: false);
  }

  /// Converts [value] to a trimmed string, returning null for blank values.
  static String? asNullableString(Object? value) {
    if (value == null) return null;
    final String text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  /// Converts [value] to int when possible.
  static int? asNullableInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  /// Converts [value] to double when possible.
  static double? asNullableDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  /// Parses backend truthy/falsey values into a boolean flag.
  static bool asFlag(Object? value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final String normalized = value.toString().trim().toLowerCase();
    if (normalized == 'true' || normalized == 'yes') return true;
    if (normalized == 'false' || normalized == 'no') return false;
    final int? numeric = int.tryParse(normalized);
    if (numeric != null) return numeric != 0;
    return defaultValue;
  }

  /// Parses [value] as ISO-like date/time when possible.
  static DateTime? asNullableDateTime(Object? value) {
    final String? text = asNullableString(value);
    if (text == null) return null;
    return DateTime.tryParse(text);
  }
}
