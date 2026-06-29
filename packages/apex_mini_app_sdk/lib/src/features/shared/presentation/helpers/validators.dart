import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Validator signature for text input values.
typedef StringValidator = String? Function(String? value);

/// Validator signature for non-string values such as selections.
typedef ValueValidator<T> = String? Function(T value);

/// Shared form validators used by SDK screens.
final class Validators {
  /// Combines string validators and returns the first error.
  static StringValidator combine(
    List<StringValidator> validators,
  ) {
    return (String? value) {
      for (final StringValidator validator in validators) {
        final String? error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  /// Combines value validators and returns the first error.
  static ValueValidator<T> combineValue<T>(
    List<ValueValidator<T>> validators,
  ) {
    return (T value) {
      for (final ValueValidator<T> validator in validators) {
        final String? error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  /// Requires a non-empty string.
  static StringValidator required(SdkLocalizations l10n) {
    return (String? value) =>
        (value?.trim().isEmpty ?? true) ? l10n.validationRequired : null;
  }

  /// Requires a minimum string length when a value is present.
  static StringValidator minLength(SdkLocalizations l10n, int count) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return null;
      }
      return normalized.length < count ? l10n.validationMinLength(count) : null;
    };
  }

  /// Requires a maximum string length when a value is present.
  static StringValidator maxLength(SdkLocalizations l10n, int count) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return null;
      }
      return normalized.length > count ? l10n.validationMaxLength(count) : null;
    };
  }

  /// Validates an email address with optional required behavior.
  static StringValidator email(
    SdkLocalizations l10n, {
    bool required = true,
  }) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return required ? l10n.validationRequired : null;
      }
      return normalized.isValidEmail ? null : l10n.validationInvalidEmail;
    };
  }

  /// Validates a numeric phone number with an exact length.
  static StringValidator phone(
    SdkLocalizations l10n, {
    bool required = true,
    int exactLength = 8,
  }) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return required ? l10n.validationRequired : null;
      }
      if (!RegExp(r'^\d+$').hasMatch(normalized)) {
        return l10n.validationInvalidPhone;
      }
      return normalized.length == exactLength
          ? null
          : l10n.validationInvalidPhone;
    };
  }

  /// Validates the local account-number digits entered after the MN prefix.
  static StringValidator iban(
    SdkLocalizations l10n, {
    bool required = true,
    List<int> validLengths = const [9, 10, 11, 12, 13, 14],
  }) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return required ? l10n.validationRequired : null;
      }
      if (!RegExp(r'^\d+$').hasMatch(normalized)) {
        return l10n.validationInvalidIban;
      }
      return validLengths.contains(normalized.length)
          ? null
          : l10n.validationInvalidIban;
    };
  }

  /// Requires a non-null selection value.
  static ValueValidator<T?> requiredSelection<T>(SdkLocalizations l10n) {
    return (T? value) =>
        value == null ? l10n.validationSelectionRequired : null;
  }

  /// Validates a numeric quantity against a minimum.
  static String? quantity(int value, SdkLocalizations l10n, {int min = 1}) {
    return value >= min ? null : l10n.validationMinQuantity;
  }
}
