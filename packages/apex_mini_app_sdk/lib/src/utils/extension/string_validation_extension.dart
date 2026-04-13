import 'package:flutter/widgets.dart';

import '../../../l10n/sdk_localizations.dart';
import '../../shared/l10n/sdk_localizations_x.dart';
import 'string_extension.dart';

extension StringValidationExtensions on String? {
  String? validateEmail(SdkLocalizations l10n) =>
      (this == null || this!.trim().isEmpty || !this!.trim().isValidEmail)
      ? l10n.validationInvalidEmail
      : null;

  String? validatePhone(SdkLocalizations l10n) =>
      (this == null || !RegExp(r'^\d{8}$').hasMatch(this!.trim()))
      ? l10n.validationInvalidPhone
      : null;

  String? validateRegister(SdkLocalizations l10n) =>
      (this == null ||
          !RegExp(
            r'^((?![ьъ])[A-zА-Яа-яӨөҮү]){2}[0-9]{8}$',
          ).hasMatch(this!.trim()))
      ? l10n.validationInvalidRegisterNo
      : null;

  String? validateForeignRegister(SdkLocalizations l10n) =>
      (this == null ||
          !RegExp(r'^[A-zА-Яа-яӨөҮү0-9]{8,13}$').hasMatch(this!.trim()))
      ? l10n.validationInvalidRegisterNo
      : null;

  String? validateOther(SdkLocalizations l10n) =>
      (this == null || !RegExp(r'^\d{7}$').hasMatch(this!.trim()))
      ? l10n.validationInvalidRegisterNo
      : null;

  String? validateEmpty(SdkLocalizations l10n) =>
      (this?.trim().isEmpty ?? true) ? l10n.validationRequired : null;

  String? validateEmailWithContext(BuildContext context) =>
      validateEmail(context.l10n);

  String? validatePhoneWithContext(BuildContext context) =>
      validatePhone(context.l10n);

  String? validateRegisterWithContext(BuildContext context) =>
      validateRegister(context.l10n);

  String? validateForeignRegisterWithContext(BuildContext context) =>
      validateForeignRegister(context.l10n);

  String? validateOtherWithContext(BuildContext context) =>
      validateOther(context.l10n);

  String? validateEmptyWithContext(BuildContext context) =>
      validateEmpty(context.l10n);
}
