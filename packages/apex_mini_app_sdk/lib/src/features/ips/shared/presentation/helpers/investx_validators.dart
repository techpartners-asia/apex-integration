import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import '../../../../../utils/extension/string_extension.dart';

typedef InvestXStringValidator = String? Function(String? value);
typedef InvestXValueValidator<T> = String? Function(T value);

final class InvestXValidators {
  static InvestXStringValidator combine(
    List<InvestXStringValidator> validators,
  ) {
    return (String? value) {
      for (final InvestXStringValidator validator in validators) {
        final String? error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  static InvestXValueValidator<T> combineValue<T>(
    List<InvestXValueValidator<T>> validators,
  ) {
    return (T value) {
      for (final InvestXValueValidator<T> validator in validators) {
        final String? error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  static InvestXStringValidator required(SdkLocalizations l10n) {
    return (String? value) =>
        (value?.trim().isEmpty ?? true) ? l10n.validationRequired : null;
  }

  static InvestXStringValidator minLength(SdkLocalizations l10n, int count) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return null;
      }
      return normalized.length < count ? l10n.validationMinLength(count) : null;
    };
  }

  static InvestXStringValidator maxLength(SdkLocalizations l10n, int count) {
    return (String? value) {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        return null;
      }
      return normalized.length > count ? l10n.validationMaxLength(count) : null;
    };
  }

  static InvestXStringValidator email(
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

  static InvestXStringValidator phone(
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

  static InvestXStringValidator iban(
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

  static InvestXValueValidator<T?> requiredSelection<T>(SdkLocalizations l10n) {
    return (T? value) =>
        value == null ? l10n.validationSelectionRequired : null;
  }

  static String? quantity(int value, SdkLocalizations l10n, {int min = 1}) {
    return value >= min ? null : l10n.validationMinQuantity;
  }
}
