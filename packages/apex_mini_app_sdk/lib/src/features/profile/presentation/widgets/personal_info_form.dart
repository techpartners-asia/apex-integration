import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ProfilePersonalInfoForm extends StatelessWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController industryController;
  final TextEditingController positionController;
  final TextEditingController ibanController;
  final TextEditingController accountHolderController;
  final SecAcntBankOption? selectedBank;
  final String citizenship;
  final String country;
  final bool isSaving;
  final bool isResolvingAccountHolder;
  final String? lookupErrorMessage;
  final VoidCallback? onSelectBank;

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
    this.onSelectBank,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildTextField(
          label: 'Овог',
          controller: lastNameController,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Нэр',
          controller: firstNameController,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Цахим шуудан',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Утасны дугаар',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        const ProfileSectionTitle(title: 'Оршин суугаа хаяг'),
        SizedBox(height: responsive.dp(14)),
        ProfileDropdownField(
          label: 'Иргэншил',
          value: citizenship,
        ),
        SizedBox(height: responsive.dp(14)),
        ProfileDropdownField(
          label: 'Оршин суугаа улс',
          value: country,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Оршин суугаа хаяг',
          controller: addressController,
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        const ProfileSectionTitle(title: 'Ажил эрхлэлт'),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Ажиллаж буй салбар',
          controller: industryController,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: 'Эрхэлж буй ажил',
          controller: positionController,
        ),
        SizedBox(height: responsive.spacing.sectionSpacing),
        const ProfileSectionTitle(title: 'Банкны мэдээлэл'),
        SizedBox(height: responsive.dp(14)),
        ProfileDropdownField(
          label: l10n.commonBank,
          value: selectedBank?.label ?? l10n.secAcntBankNotSelected,
          icon: Icons.account_balance,
          onTap: isSaving ? null : onSelectBank,
        ),
        SizedBox(height: responsive.dp(14)),
        _buildTextField(
          label: l10n.commonIban,
          controller: ibanController,
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
}

class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      title,
      variant: MiniAppTextVariant.subtitle3,
    );
  }
}

class ProfileDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? icon;

  const ProfileDropdownField({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final bool hasValue = value.trim().isNotEmpty;

    return FloatingLabelFieldShell(
      label: label,
      hasValue: hasValue,
      onTap: onTap,
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
