import 'package:intl/intl.dart';

final class DateTimeFormatter {
  const DateTimeFormatter._();

  static String toDateTimeZoneStrFromDateTime(DateTime dt) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dt);
  }

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
