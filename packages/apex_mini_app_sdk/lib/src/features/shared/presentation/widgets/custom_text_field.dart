import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/design_tokens.dart';

class CustomTextField extends StatelessWidget {
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

  const CustomTextField({
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
          color: DesignTokens.muted,
          fontWeight: MiniAppTypography.regular,
        ),
        prefixStyle: textTheme.bodyLarge?.copyWith(
          color: DesignTokens.ink,
          fontWeight: MiniAppTypography.semiBold,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        border: _buildInputBorder(context),
        enabledBorder: _buildInputBorder(context),
        focusedBorder: _buildInputBorder(
          context,
          color: DesignTokens.rose,
          width: 1,
        ),
        errorBorder: _buildInputBorder(
          context,
          // color: DesignTokens.danger,
          width: 1,
        ),
        focusedErrorBorder: _buildInputBorder(
          context,
          color: DesignTokens.danger,
          width: 1,
        ),
        errorMaxLines: 2,
        errorStyle: textTheme.bodySmall?.copyWith(
          color: DesignTokens.danger,
          height: 1.35,
        ),
      ),
      // style: textTheme.bodyMedium?.copyWith(
      //   color: DesignTokens.ink,
      //   fontWeight: MiniAppTypography.semiBold,
      // ),
    );
  }
}

OutlineInputBorder _buildInputBorder(
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
