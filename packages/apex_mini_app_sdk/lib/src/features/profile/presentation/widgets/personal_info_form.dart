import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Profile form used when editing personal, employment, and bank details.
class ProfilePersonalInfoForm extends StatelessWidget {
  /// Controller for the last-name field.
  final TextEditingController lastNameController;

  /// Controller for the first-name field.
  final TextEditingController firstNameController;

  /// Controller for the email field.
  final TextEditingController emailController;

  /// Controller for the phone field.
  final TextEditingController phoneController;

  /// Controller for the residential address field.
  final TextEditingController addressController;

  /// Controller for the employment industry field.
  final TextEditingController industryController;

  /// Controller for the job-position field.
  final TextEditingController positionController;

  /// Controller for the IBAN field.
  final TextEditingController ibanController;

  /// Controller for the resolved bank account holder name.
  final TextEditingController accountHolderController;

  /// Currently selected settlement bank.
  final SecAcntBankOption? selectedBank;

  /// Read-only citizenship label.
  final String citizenship;

  /// Read-only country label.
  final String country;

  /// Whether the form is currently being saved.
  final bool isSaving;

  /// Whether the account holder lookup is in progress.
  final bool isResolvingAccountHolder;

  /// Optional lookup error displayed under the account holder field.
  final String? lookupErrorMessage;

  /// Whether to show required-field errors (true after first save attempt).
  final bool showRequiredErrors;

  /// Callback fired when the bank dropdown is tapped.
  final VoidCallback? onSelectBank;

  /// Creates the full profile personal-info form.
  const ProfilePersonalInfoForm({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.industryController,
    required this.positionController,
    required this.ibanController,
    required this.accountHolderController,
    required this.selectedBank,
    required this.citizenship,
    required this.country,
    required this.isSaving,
    required this.isResolvingAccountHolder,
    this.lookupErrorMessage,
    this.showRequiredErrors = false,
    this.onSelectBank,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    final bool showErr = showRequiredErrors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildRequiredTextField(
          context: context,
          label: 'Овог',
          controller: lastNameController,
          showError: showErr,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildRequiredTextField(
          context: context,
          label: 'Нэр',
          controller: firstNameController,
          showError: showErr,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildRequiredTextField(
          context: context,
          label: 'Цахим шуудан',
          controller: emailController,
          showError: showErr,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildRequiredTextField(
          context: context,
          label: 'Утасны дугаар',
          controller: phoneController,
          showError: showErr,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        const ProfileSectionTitle(title: 'Оршин суугаа хаяг'),
        SizedBox(height: responsive.dp(14)),
        ProfileDropdownField(
          label: 'Иргэншил',
          value: citizenship,
          errorText: showErr && citizenship.trim().isEmpty ? context.l10n.validationRequired : null,
        ),
        SizedBox(height: responsive.dp(14)),
        ProfileDropdownField(
          label: 'Оршин суугаа улс',
          value: country,
          errorText: showErr && country.trim().isEmpty ? context.l10n.validationRequired : null,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Оршин суугаа хаяг',
          controller: addressController,
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        const ProfileSectionTitle(title: 'Ажил эрхлэлт'),
        SizedBox(height: responsive.dp(14)),
        _buildRequiredTextField(
          context: context,
          label: 'Ажиллаж буй салбар',
          controller: industryController,
          showError: showErr,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildRequiredTextField(
          context: context,
          label: 'Эрхэлж буй ажил',
          controller: positionController,
          showError: showErr,
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        const ProfileSectionTitle(title: 'Банкны мэдээлэл'),
        SizedBox(height: responsive.dp(14)),
        ProfileDropdownField(
          label: '${l10n.commonBank}',
          value: selectedBank?.label ?? l10n.secAcntBankNotSelected,
          icon: Icons.account_balance,
          onTap: isSaving ? null : onSelectBank,
          errorText: showErr && selectedBank == null ? context.l10n.validationSelectionRequired : null,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildRequiredTextField(
          context: context,
          label: '${l10n.commonIban}',
          controller: ibanController,
          showError: showErr,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Данс эзэмшигчийн нэр',
          controller: accountHolderController,
          enabled: false,
        ),
        if (isResolvingAccountHolder)
          Padding(
            padding: EdgeInsets.only(top: responsive.dp(8)),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: responsive.dp(14),
                  height: responsive.dp(14),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: responsive.dp(8)),
                Expanded(
                  child: CustomText(
                    l10n.commonLoading,
                    variant: MiniAppTextVariant.caption1,
                    color: DesignTokens.muted,
                  ),
                ),
              ],
            ),
          ),
        if (lookupErrorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: responsive.dp(8)),
            child: NoticeBanner(
              title: context.l10n.errorsGenericTitle,
              message: lookupErrorMessage!,
            ),
          ),
      ],
    );
  }

  /// Builds a consistently styled field using the shared SDK input shell.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return CustomTextField(
      label: label,
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
    );
  }

  /// Builds a required field that shows a red border when [showError] is true and the field is empty.
  Widget _buildRequiredTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool showError,
    TextInputType? keyboardType,
  }) {
    return CustomTextField(
      label: label,
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: showError ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
      validator: (String? value) =>
          (value == null || value.trim().isEmpty) ? context.l10n.validationRequired : null,
    );
  }
}

/// Small section heading used within the profile form.
class ProfileSectionTitle extends StatelessWidget {
  /// Creates a section heading.
  const ProfileSectionTitle({super.key, required this.title});

  /// Text displayed in the heading.
  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      title,
      variant: MiniAppTextVariant.subtitle3,
    );
  }
}

/// Read-only field shell used for profile dropdown selections.
class ProfileDropdownField extends StatelessWidget {
  /// Floating label displayed above the value.
  final String label;

  /// Current value or placeholder.
  final String value;

  /// Tap handler that opens the relevant picker/sheet.
  final VoidCallback? onTap;

  /// Optional leading icon for the selected value.
  final IconData? icon;

  /// Optional validation error shown below the field.
  final String? errorText;

  /// Creates a dropdown-like profile field.
  const ProfileDropdownField({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.icon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final bool hasValue = value.trim().isNotEmpty;

    return FloatingLabelFieldShell(
      label: label,
      hasValue: hasValue,
      onTap: onTap,
      errorText: errorText,
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: responsive.dp(22),
        color: DesignTokens.muted,
      ),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(
              icon,
              size: responsive.dp(20),
              color: DesignTokens.teal,
            ),
            SizedBox(width: responsive.dp(10)),
          ],
          Expanded(
            child: CustomText(
              value,
              variant: hasValue
                  ? MiniAppTextVariant.body2
                  : MiniAppTextVariant.body2,
              color: hasValue ? DesignTokens.ink : DesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}
