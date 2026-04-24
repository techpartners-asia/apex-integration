import 'package:mini_app_sdk/mini_app_sdk.dart';

typedef StringValidator = String? Function(String? value);
typedef ValueValidator<T> = String? Function(T value);

final class Validators {
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

  static StringValidator required(SdkLocalizations l10n) {
    return (String? value) =>
        (value?.trim().isEmpty ?? true) ? l10n.validationRequired : null;
  }

  static StringValidator minLength(SdkLocalizations l10n, int count) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return null;
      }
      return normalized.length < count ? l10n.validationMinLength(count) : null;
    };
  }

  static StringValidator maxLength(SdkLocalizations l10n, int count) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return null;
      }
      return normalized.length > count ? l10n.validationMaxLength(count) : null;
    };
  }

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

  static StringValidator iban(
    SdkLocalizations l10n, {
    bool required = true,
    int exactLength = 18,
  }) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return required ? l10n.validationRequired : null;
      }
      if (!RegExp(r'^\d+$').hasMatch(normalized)) {
        return l10n.validationInvalidIban;
      }
      return normalized.length == exactLength
          ? null
          : l10n.validationInvalidIban;
    };
  }

  static ValueValidator<T?> requiredSelection<T>(SdkLocalizations l10n) {
    return (T? value) =>
        value == null ? l10n.validationSelectionRequired : null;
  }

  static String? quantity(int value, SdkLocalizations l10n, {int min = 1}) {
    return value >= min ? null : l10n.validationMinQuantity;
  }
}
