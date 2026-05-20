import 'package:flutter/widgets.dart';

import '../../../l10n/sdk_localizations.dart';
import '../../shared/l10n/sdk_localizations_x.dart';
import 'string_extension.dart';

/// Localized string validators used by profile and onboarding forms.
extension StringValidationExtensions on String? {
  /// Validates an email address.
  String? validateEmail(SdkLocalizations l10n) =>
      (this == null || this!.trim().isEmpty || !this!.trim().isValidEmail)
      ? l10n.validationInvalidEmail
      : null;

  /// Validates an 8-digit Mongolian phone number.
  String? validatePhone(SdkLocalizations l10n) =>
      (this == null || !RegExp(r'^\d{8}$').hasMatch(this!.trim()))
      ? l10n.validationInvalidPhone
      : null;

  /// Validates a domestic registration number.
  String? validateRegister(SdkLocalizations l10n) =>
      (this == null ||
          !RegExp(
            r'^((?![ьъ])[A-zА-Яа-яӨөҮү]){2}[0-9]{8}$',
          ).hasMatch(this!.trim()))
      ? l10n.validationInvalidRegisterNo
      : null;

  /// Validates a foreign registration/passport-like value.
  String? validateForeignRegister(SdkLocalizations l10n) =>
      (this == null ||
          !RegExp(r'^[A-zА-Яа-яӨөҮү0-9]{8,13}$').hasMatch(this!.trim()))
      ? l10n.validationInvalidRegisterNo
      : null;

  /// Validates the alternate 7-digit registration input.
  String? validateOther(SdkLocalizations l10n) =>
      (this == null || !RegExp(r'^\d{7}$').hasMatch(this!.trim()))
      ? l10n.validationInvalidRegisterNo
      : null;

  /// Validates required non-empty text.
  String? validateEmpty(SdkLocalizations l10n) =>
      (this?.trim().isEmpty ?? true) ? l10n.validationRequired : null;

  /// Validates email using localization from [context].
  String? validateEmailWithContext(BuildContext context) =>
      validateEmail(context.l10n);

  /// Validates phone using localization from [context].
  String? validatePhoneWithContext(BuildContext context) =>
      validatePhone(context.l10n);

  /// Validates register number using localization from [context].
  String? validateRegisterWithContext(BuildContext context) =>
      validateRegister(context.l10n);

  /// Validates foreign register number using localization from [context].
  String? validateForeignRegisterWithContext(BuildContext context) =>
      validateForeignRegister(context.l10n);

  /// Validates alternate register input using localization from [context].
  String? validateOtherWithContext(BuildContext context) =>
      validateOther(context.l10n);

  /// Validates required text using localization from [context].
  String? validateEmptyWithContext(BuildContext context) =>
      validateEmpty(context.l10n);
}
