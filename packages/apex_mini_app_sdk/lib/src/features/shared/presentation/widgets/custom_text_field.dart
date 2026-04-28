import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/design_tokens.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final String? prefixText;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool showCounter;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.prefixText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.showCounter = false,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;

  bool get _hasValue => widget.controller.text.isNotEmpty;

  bool get _isFloating => _focusNode.hasFocus || _hasValue;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleVisualStateChanged);
    widget.controller.addListener(_handleVisualStateChanged);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleVisualStateChanged);
      widget.controller.addListener(_handleVisualStateChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleVisualStateChanged);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleVisualStateChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleVisualStateChanged);
    _focusNode.removeListener(_handleVisualStateChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleVisualStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _focusField() {
    if (!widget.enabled || widget.readOnly) return;
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      builder: (FormFieldState<String> field) {
        return _HDesignTextField(
          label: widget.label,
          controller: widget.controller,
          focusNode: _focusNode,
          isFloating: _isFloating,
          errorText: field.errorText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          prefixText: widget.prefixText,
          hintText: widget.hintText,
          inputFormatters: widget.inputFormatters,
          showCounter: widget.showCounter,
          suffixIcon: widget.suffixIcon,
          onTap: () {
            _focusField();
            widget.onTap?.call();
          },
          onChanged: (String value) {
            field.didChange(value);
            widget.onChanged?.call(value);
          },
        );
      },
    );
  }
}

class _HDesignTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFloating;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final String? prefixText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String> onChanged;

  const _HDesignTextField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.isFloating,
    required this.enabled,
    required this.readOnly,
    required this.obscureText,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.prefixText,
    this.hintText,
    this.inputFormatters,
    this.showCounter = false,
    this.suffixIcon,
    this.onTap,
  });

  bool get _hasError => errorText != null && errorText!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final int effectiveMinLines = math.max(1, minLines ?? 1);
    final int effectiveMaxLines = obscureText ? 1 : math.max(1, maxLines ?? 1);
    final bool isMultiline = effectiveMinLines > 1 || effectiveMaxLines > 1;
    final double fieldHeight = isMultiline
        ? math.max(
            responsive.dp(112),
            responsive.dp(54 + effectiveMinLines * 26),
          )
        : responsive.dp(54);
    final BorderRadius borderRadius = BorderRadius.circular(
      responsive.radiusLg,
    );
    final Color borderColor = _hasError
        ? DesignTokens.danger
        : focusNode.hasFocus
        ? DesignTokens.rose
        : Colors.transparent;
    final Color fillColor = enabled ? Colors.white : Colors.white.withValues(alpha: 0.62);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            height: fieldHeight,
            padding: EdgeInsets.symmetric(horizontal: responsive.dp(18)),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor,
                width: borderColor == Colors.transparent ? 0 : 1,
              ),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: suffixIcon == null ? 0 : responsive.dp(44),
                  top: isFloating ? responsive.dp(5) : 0,
                  height: isFloating ? responsive.dp(20) : fieldHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutCubic,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (isFloating ? MiniAppTypography.caption2 : MiniAppTypography.body2).copyWith(
                        color: DesignTokens.muted,
                        height: 1.1,
                      ),
                      child: Text(isFloating ? label : (hintText ?? label)),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: isFloating ? responsive.dp(10) : 0,
                  right: suffixIcon == null ? 0 : responsive.dp(40),
                  child: Align(
                    alignment: isMultiline ? Alignment.topLeft : Alignment.centerLeft,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      enabled: enabled,
                      readOnly: readOnly,
                      obscureText: obscureText,
                      keyboardType: keyboardType ?? (isMultiline ? TextInputType.multiline : TextInputType.text),
                      textInputAction: textInputAction,
                      minLines: obscureText ? 1 : effectiveMinLines,
                      maxLines: obscureText ? 1 : effectiveMaxLines,
                      maxLength: maxLength,
                      inputFormatters: inputFormatters,
                      onChanged: onChanged,
                      onTap: onTap,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      style: MiniAppTypography.body2.copyWith(
                        color: DesignTokens.ink,
                        height: 1.2,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        isCollapsed: true,
                        counterText: '',
                        hintText: isFloating ? hintText : null,
                        hintStyle: MiniAppTypography.body1.copyWith(
                          color: DesignTokens.muted.withValues(alpha: 0.72),
                        ),
                        prefixText: isFloating ? prefixText : null,
                        prefixStyle: MiniAppTypography.body2.copyWith(
                          color: DesignTokens.ink,
                        ),
                      ),
                    ),
                  ),
                ),
                if (suffixIcon != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(child: suffixIcon),
                  ),
              ],
            ),
          ),
        ),
        if (_hasError)
          Padding(
            padding: EdgeInsets.only(
              left: responsive.dp(18),
              top: responsive.dp(6),
            ),
            child: CustomText(
              errorText!,
              variant: MiniAppTextVariant.caption1,
              color: DesignTokens.danger,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (showCounter && maxLength != null)
          Padding(
            padding: EdgeInsets.only(
              right: responsive.dp(4),
              top: responsive.dp(6),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                '${controller.text.length}/$maxLength',
                variant: MiniAppTextVariant.caption1,
                color: DesignTokens.muted,
              ),
            ),
          ),
      ],
    );
  }
}

class FloatingLabelFieldShell extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool hasValue;
  final bool isFocused;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onTap;
  final Widget child;
  final Widget? trailing;
  final double? minHeight;

  const FloatingLabelFieldShell({
    super.key,
    required this.label,
    required this.hasValue,
    required this.child,
    this.placeholder,
    this.isFocused = false,
    this.enabled = true,
    this.errorText,
    this.onTap,
    this.trailing,
    this.minHeight,
  });

  bool get _isFloating => isFocused || hasValue;

  bool get _hasError => errorText != null && errorText!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double fieldHeight = minHeight ?? responsive.dp(54);
    final BorderRadius borderRadius = BorderRadius.circular(
      responsive.radiusLg,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            height: fieldHeight,
            padding: EdgeInsets.symmetric(horizontal: responsive.dp(18)),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.62),
              borderRadius: borderRadius,
              border: Border.all(
                color: _hasError ? DesignTokens.danger : Colors.transparent,
                width: _hasError ? 1 : 0,
              ),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: trailing == null ? 0 : responsive.dp(38),
                  top: _isFloating ? responsive.dp(5) : 0,
                  height: _isFloating ? responsive.dp(20) : fieldHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutCubic,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (_isFloating ? MiniAppTypography.caption2 : MiniAppTypography.body2).copyWith(
                        color: DesignTokens.muted,
                        height: 1.1,
                      ),
                      child: CustomText(_isFloating ? label : (placeholder ?? label), variant: MiniAppTextVariant.caption2),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: _isFloating ? responsive.dp(20) : 0,
                  right: trailing == null ? 0 : responsive.dp(38),
                  child: Opacity(
                    opacity: _isFloating ? 1 : 0,
                    child: Align(alignment: Alignment.centerLeft, child: child),
                  ),
                ),
                if (trailing != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(child: trailing),
                  ),
              ],
            ),
          ),
        ),
        if (_hasError)
          Padding(
            padding: EdgeInsets.only(
              left: responsive.dp(18),
              top: responsive.dp(6),
            ),
            child: CustomText(
              errorText!,
              variant: MiniAppTextVariant.caption1,
              color: DesignTokens.danger,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
