import 'package:intl/intl.dart';

/// Date formatting helpers used by API requests and UI date labels.
final class DateTimeFormatter {
  /// Private constructor for static-only utility class.
  const DateTimeFormatter._();

  /// Formats [dt] as an API datetime string without timezone suffix.
  static String toDateTimeZoneStrFromDateTime(DateTime dt) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dt);
  }

  /// Formats [dt] as `yyyy-MM-dd`.
  static String toDateTime(DateTime dt) {
    return DateFormat("yyyy-MM-dd").format(dt);
  }

  /// Parses [dt] and formats it as `yyyy-MM-dd`, falling back to now.
  static String toDateTimeWithStr(String dt) {
    return DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.tryParse(dt) ?? DateTime.now());
  }

  /// Normalizes a raw backend date/date-time value into API datetime format.
  static String normalizeDateOnlyOrDateTime(String raw) {
    final String value = raw.trim();
    if (value.isEmpty) {
      return raw;
    }

    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return raw;
    }

    final DateTime local = parsed.isUtc ? parsed.toLocal() : parsed;
    return toDateTimeZoneStrFromDateTime(local);
  }
}
