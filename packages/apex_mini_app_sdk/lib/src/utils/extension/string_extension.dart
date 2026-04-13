import 'package:email_validator/email_validator.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty =>
      this == null || this!.trim().isEmpty || this == 'NULL' || this == 'null';

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool get hasUpperCase => this?.contains(RegExp(r'[A-Z]')) ?? false;

  bool get hasDigit => this?.contains(RegExp(r'\d')) ?? false;

  // bool get capitalized => (this?.isEmpty ?? true) ? '' : '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  bool get passLowLength => (this?.length ?? 0) >= 7;

  String formatAccountNo() {
    final str = this ?? '';
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i += 4) {
      buffer.write(
        ' ${str.substring(i, i + 4 > str.length ? str.length : i + 4)}',
      );
    }

    return buffer.toString().trim();
  }

  bool get isValidEmail => this != null && EmailValidator.validate(this!);

  bool get isValidUrl => Uri.tryParse(this ?? '')?.isAbsolute ?? false;
}
