import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntPersonalInfoStep extends StatelessWidget {
  final TextEditingController mobileController;
  final TextEditingController secondaryMobileController;
  final TextEditingController emailController;
  final TextEditingController ibanController;
  final SecAcntBankOption? selectedBank;
  final VoidCallback onSelectBank;
  final bool isShortFlow;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? mobileValidator;
  final String? Function(String?)? secondaryMobileValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? ibanValidator;
  final String? bankErrorText;

  const SecAcntPersonalInfoStep({
    super.key,
    required this.mobileController,
    required this.secondaryMobileController,
    required this.emailController,
    required this.ibanController,
    required this.selectedBank,
    required this.onSelectBank,
    required this.isShortFlow,
    required this.autovalidateMode,
    this.mobileValidator,
    this.secondaryMobileValidator,
    this.emailValidator,
    this.ibanValidator,
    this.bankErrorText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final List<Widget> fields = <Widget>[
      if (!isShortFlow)
        CustomTextField(
          label: l10n.internalAuthFieldPhone,
          controller: mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 8,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          autovalidateMode: autovalidateMode,
          validator: mobileValidator,
        ),
      if (!isShortFlow) SizedBox(height: responsive.dp(16)),
      if (!isShortFlow)
        CustomTextField(
          label: l10n.secAcntFieldSecondaryPhone,
          controller: secondaryMobileController,
          keyboardType: TextInputType.phone,
          maxLength: 8,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          autovalidateMode: autovalidateMode,
          validator: secondaryMobileValidator,
        ),
      if (!isShortFlow) SizedBox(height: responsive.dp(16)),
      if (!isShortFlow)
        CustomTextField(
          label: l10n.internalAuthFieldEmail,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: autovalidateMode,
          validator: emailValidator,
        ),
      if (!isShortFlow) SizedBox(height: responsive.dp(16)),
      BankSelectorField(
        label: l10n.commonBank,
        value: selectedBank?.label ?? l10n.commonSelect,
        onTap: onSelectBank,
        hasValue: selectedBank != null,
        selectedValue: selectedBank,
        errorText: bankErrorText,
      ),
      SizedBox(height: responsive.dp(16)),
      CustomTextField(
        label: l10n.commonIban,
        controller: ibanController,
        keyboardType: TextInputType.number,
        maxLength: 18,
        prefixText: 'MN ',
        onChanged: (String value) {
          if (value.length >= 18) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        autovalidateMode: autovalidateMode,
        validator: ibanValidator,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          l10n.internalAuthSectionPersonalInformation,
          variant: MiniAppTextVariant.h8,
          color: DesignTokens.ink,
        ),
        SizedBox(height: responsive.dp(8)),
        CustomText(
          l10n.secAcntPersonalInformationSubtitle,
          variant: MiniAppTextVariant.body3,
          color: DesignTokens.muted,
        ),
        SizedBox(height: responsive.dp(24)),
        ...fields,
      ],
    );
  }
}
