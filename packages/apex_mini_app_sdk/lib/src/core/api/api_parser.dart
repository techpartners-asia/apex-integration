class ApiParser {
  const ApiParser._();

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

  static List<Map<String, Object?>> asObjectMapList(Object? value) {
    if (value is! List) {
      return const <Map<String, Object?>>[];
    }

    return value
        .map<Map<String, Object?>>((Object? item) => asObjectMap(item))
        .toList(growable: false);
  }

  static String? asNullableString(Object? value) {
    if (value == null) return null;
    final String text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? asNullableInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? asNullableDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

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

  static DateTime? asNullableDateTime(Object? value) {
    final String? text = asNullableString(value);
    if (text == null) return null;
    return DateTime.tryParse(text);
  }
}
