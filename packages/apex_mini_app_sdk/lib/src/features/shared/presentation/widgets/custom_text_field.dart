import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

const Color _inputTextColor = DesignTokens.ink;
const Color _inputLabelColor = DesignTokens.ink;
const Color _inputHintColor = DesignTokens.muted;
const Color _inputDisabledTextColor = Color(0xFF9AA0AA);

/// Shared floating-label text field used by onboarding/profile forms.
///
/// The widget owns defensive text colors instead of inheriting host
/// `InputDecorationTheme` label colors, which keeps labels visible when the SDK
/// is embedded in hosts with aggressive global themes.
class CustomTextField extends StatefulWidget {
  /// Label displayed above the value when floating, or as placeholder text when
  /// the field is empty and no [hintText] is provided.
  final String label;

  /// Text controller owned by the caller.
  final TextEditingController controller;

  /// Optional focus node. If omitted, the widget creates and disposes one.
  final FocusNode? focusNode;

  /// Keyboard type passed to the inner `TextField`.
  final TextInputType? keyboardType;

  /// IME action passed to the inner `TextField`.
  final TextInputAction? textInputAction;

  /// Optional max character count.
  final int? maxLength;

  /// Minimum lines for multiline inputs.
  final int? minLines;

  /// Maximum lines for multiline inputs.
  final int? maxLines;

  /// Prefix shown only when the label is floating.
  final String? prefixText;

  /// Placeholder shown inside the value area when the label is floating.
  final String? hintText;

  /// Form validation callback.
  final String? Function(String?)? validator;

  /// Value change callback.
  final ValueChanged<String>? onChanged;

  /// Tap callback, useful for read-only fields that open pickers.
  final VoidCallback? onTap;

  /// Input formatters passed to the inner `TextField`.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation mode used by the wrapping `FormField`.
  final AutovalidateMode autovalidateMode;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether the field is visually enabled but read-only.
  final bool readOnly;

  /// Whether the value should be obscured.
  final bool obscureText;

  /// Whether to show a character counter below the field.
  final bool showCounter;

  /// Optional trailing icon/action.
  final Widget? suffixIcon;

  /// Creates a defensive floating-label text field.
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

/// Manages focus ownership and floating-label rebuilds for [CustomTextField].
class _CustomTextFieldState extends State<CustomTextField> {
  /// Effective focus node, either caller-owned or internally owned.
  late FocusNode _focusNode;

  /// Whether this state object must dispose [_focusNode].
  late bool _ownsFocusNode;

  /// Whether the field currently has user-visible text.
  bool get _hasValue => widget.controller.text.isNotEmpty;

  /// Whether a separate placeholder is available.
  bool get _hasHintText => widget.hintText?.trim().isNotEmpty ?? false;

  /// Whether the label should move to the compact floating position.
  bool get _isFloating => _focusNode.hasFocus || _hasValue || _hasHintText;

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

  /// Rebuilds when focus or controller text changes the floating label state.
  void _handleVisualStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Requests focus unless the field is disabled or read-only.
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

/// Internal H-design text-field shell with defensive label/hint styling.
class _HDesignTextField extends StatelessWidget {
  /// Floating/placeholder label.
  final String label;

  /// Text controller for the inner field.
  final TextEditingController controller;

  /// Focus node for visual state and keyboard focus.
  final FocusNode focusNode;

  /// Whether the label is in compact floating position.
  final bool isFloating;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether text should be obscured.
  final bool obscureText;

  /// Validation error text.
  final String? errorText;

  /// Keyboard type for the inner field.
  final TextInputType? keyboardType;

  /// IME action for the inner field.
  final TextInputAction? textInputAction;

  /// Optional max character count.
  final int? maxLength;

  /// Minimum line count.
  final int? minLines;

  /// Maximum line count.
  final int? maxLines;

  /// Prefix shown when the label is floating.
  final String? prefixText;

  /// Hint shown when the label is floating.
  final String? hintText;

  /// Input formatters applied to the inner field.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to show the character counter.
  final bool showCounter;

  /// Optional trailing icon/action.
  final Widget? suffixIcon;

  /// Tap callback for the shell and text field.
  final VoidCallback? onTap;

  /// Value change callback.
  final ValueChanged<String> onChanged;

  /// Creates the internal text-field shell.
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

  /// Whether validation produced an error message.
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
    final Color fillColor = enabled
        ? Colors.white
        : Colors.white.withValues(alpha: 0.62);
    final Color labelColor = !enabled
        ? _inputDisabledTextColor
        : _hasError
        ? DesignTokens.danger
        : isFloating
        ? _inputLabelColor
        : _inputHintColor;
    final Color valueColor = enabled
        ? _inputTextColor
        : _inputDisabledTextColor;
    final Color hintColor = enabled
        ? _inputHintColor.withValues(alpha: 0.78)
        : _inputDisabledTextColor;
    final TextStyle valueStyle = MiniAppTypography.body2.copyWith(
      color: valueColor,
      height: 1.2,
    );
    final double floatingInputTop = isFloating
        ? (isMultiline ? responsive.dp(24) : responsive.dp(10))
        : 0;

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
                      style:
                          (isFloating
                                  ? MiniAppTypography.caption2
                                  : MiniAppTypography.body2)
                              .copyWith(
                                color: labelColor,
                                height: 1.1,
                              ),
                      child: Text(isFloating ? label : (hintText ?? label)),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: floatingInputTop,
                  right: suffixIcon == null ? 0 : responsive.dp(40),
                  child: Align(
                    alignment: isMultiline
                        ? Alignment.topLeft
                        : Alignment.centerLeft,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      enabled: enabled,
                      readOnly: readOnly,
                      obscureText: obscureText,
                      keyboardType:
                          keyboardType ??
                          (isMultiline
                              ? TextInputType.multiline
                              : TextInputType.text),
                      textInputAction: textInputAction,
                      minLines: obscureText ? 1 : effectiveMinLines,
                      maxLines: obscureText ? 1 : effectiveMaxLines,
                      maxLength: maxLength,
                      inputFormatters: inputFormatters,
                      onChanged: onChanged,
                      onTap: onTap,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      textAlignVertical: isMultiline
                          ? TextAlignVertical.top
                          : TextAlignVertical.center,
                      style: valueStyle,
                      strutStyle: StrutStyle.fromTextStyle(
                        valueStyle,
                        forceStrutHeight: true,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        fillColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        isDense: true,
                        isCollapsed: true,
                        counterText: '',
                        hintText: isFloating ? hintText : null,
                        hintStyle: MiniAppTypography.body1.copyWith(
                          color: hintColor,
                        ),
                        prefixText: isFloating ? prefixText : null,
                        prefixStyle: valueStyle,
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

/// Floating-label shell for non-text inputs such as dropdowns and bank pickers.
///
/// It matches [CustomTextField] spacing, color, error, and label behavior while
/// allowing the caller to provide an arbitrary child widget for the value area.
class FloatingLabelFieldShell extends StatelessWidget {
  /// Label displayed in compact floating state.
  final String label;

  /// Placeholder shown before a value is selected.
  final String? placeholder;

  /// Whether the wrapped control has a selected value.
  final bool hasValue;

  /// Whether the wrapped control is currently focused.
  final bool isFocused;

  /// Whether the control is enabled.
  final bool enabled;

  /// Optional validation error.
  final String? errorText;

  /// Tap callback for opening picker/dropdown UI.
  final VoidCallback? onTap;

  /// Value/content widget rendered inside the shell.
  final Widget child;

  /// Optional trailing icon.
  final Widget? trailing;

  /// Optional field height override.
  final double? minHeight;

  /// Creates a floating-label shell for non-text controls.
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

  /// Whether a placeholder should force the compact label layout.
  bool get _hasPlaceholder => placeholder?.trim().isNotEmpty ?? false;

  /// Whether the label should be drawn in the compact top position.
  bool get _isFloating => isFocused || hasValue || _hasPlaceholder;

  /// Whether validation produced an error message.
  bool get _hasError => errorText != null && errorText!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double fieldHeight = minHeight ?? responsive.dp(54);
    final BorderRadius borderRadius = BorderRadius.circular(
      responsive.radiusLg,
    );
    final Color labelColor = !enabled
        ? _inputDisabledTextColor
        : _hasError
        ? DesignTokens.danger
        : _isFloating
        ? _inputLabelColor
        : _inputHintColor;

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
              color: enabled
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.62),
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
                      style:
                          (_isFloating
                                  ? MiniAppTypography.caption2
                                  : MiniAppTypography.body2)
                              .copyWith(
                                color: labelColor,
                                height: 1.1,
                              ),
                      child: Text(
                        _isFloating ? label : (placeholder ?? label),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: _isFloating ? responsive.dp(20) : 0,
                  right: trailing == null ? 0 : responsive.dp(38),
                  child: Opacity(
                    opacity: _isFloating ? 1 : 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: child,
                    ),
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
