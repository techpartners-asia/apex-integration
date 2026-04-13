import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? prefixText;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final bool enabled;

  const InvestXTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLength,
    this.prefixText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: textTheme.labelLarge?.copyWith(
          color: InvestXDesignTokens.muted,
          fontWeight: MiniAppTypography.regular,
        ),
        prefixStyle: textTheme.bodyLarge?.copyWith(
          color: InvestXDesignTokens.ink,
          fontWeight: MiniAppTypography.semiBold,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        border: _buildInvestXInputBorder(context),
        enabledBorder: _buildInvestXInputBorder(context),
        focusedBorder: _buildInvestXInputBorder(
          context,
          color: InvestXDesignTokens.rose,
          width: 1,
        ),
        errorBorder: _buildInvestXInputBorder(
          context,
          // color: InvestXDesignTokens.danger,
          width: 1,
        ),
        focusedErrorBorder: _buildInvestXInputBorder(
          context,
          color: InvestXDesignTokens.danger,
          width: 1,
        ),
        errorMaxLines: 2,
        errorStyle: textTheme.bodySmall?.copyWith(
          color: InvestXDesignTokens.danger,
          height: 1.35,
        ),
      ),
      // style: textTheme.bodyMedium?.copyWith(
      //   color: InvestXDesignTokens.ink,
      //   fontWeight: MiniAppTypography.semiBold,
      // ),
    );
  }
}

OutlineInputBorder _buildInvestXInputBorder(
  BuildContext context, {
  Color color = Colors.transparent,
  double width = 0,
}) {
  final responsive = context.responsive;
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(responsive.radiusMd),
    borderSide: BorderSide(color: color, width: width),
  );
}
