import 'package:flutter/material.dart';
import '../../theme/ds_theme_extensions.dart';

/// A standardized, accessible text input component for the Design System.
///
/// Includes a secure [DsTextField.password] constructor that disables keyboard
/// suggestions and autocorrect by default while providing a built-in visibility
/// toggle. All labels, helper texts, and error messages use defensive
/// constraints (`maxLines: 2`, [TextOverflow.ellipsis]) to prevent layout overflow.
class DsTextField extends StatefulWidget {
  const DsTextField({
    required this.label,
    super.key,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
  }) : _isPasswordField = false;

  /// Creates a security-hardened password input field with a visibility toggle,
  /// disabled keyboard suggestions, and disabled autocorrect.
  const DsTextField.password({
    required this.label,
    super.key,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
  })  : keyboardType = TextInputType.visiblePassword,
        suffixIcon = null,
        maxLines = 1,
        obscureText = true,
        enableSuggestions = false,
        autocorrect = false,
        _isPasswordField = true;

  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool _isPasswordField;

  @override
  State<DsTextField> createState() => _DsTextFieldState();
}

class _DsTextFieldState extends State<DsTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant DsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText && !widget._isPasswordField) {
      _isObscured = widget.obscureText;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final spacing = context.dsSpacing;
    final radius = context.dsRadius;
    final typography = context.dsTypography;

    final hasError = widget.errorText != null && widget.errorText!.trim().isNotEmpty;
    final hasHelper =
        !hasError && widget.helperText != null && widget.helperText!.trim().isNotEmpty;

    final borderColor = hasError ? colors.error : colors.border;
    final focusedBorderColor = hasError ? colors.error : colors.primary;

    final outlineBorder = OutlineInputBorder(
      borderRadius: radius.borderRadiusMd,
      borderSide: BorderSide(color: borderColor),
    );

    Widget? effectiveSuffixIcon = widget.suffixIcon;
    if (widget._isPasswordField) {
      effectiveSuffixIcon = IconButton(
        tooltip: _isObscured ? 'Mostrar senha' : 'Ocultar senha',
        onPressed: widget.enabled ? _togglePasswordVisibility : null,
        icon: Icon(
          _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: widget.enabled ? colors.textSecondary : colors.textDisabled,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: typography.label.copyWith(
            color: widget.enabled ? colors.textPrimary : colors.textDisabled,
          ),
        ),
        SizedBox(height: spacing.xs),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _isObscured,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          maxLines: _isObscured ? 1 : widget.maxLines,
          style: typography.bodyMedium.copyWith(
            color: widget.enabled ? colors.textPrimary : colors.textDisabled,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: widget.enabled ? colors.surface : colors.surfaceVariant,
            hintText: widget.hintText,
            hintStyle: typography.bodyMedium.copyWith(
              color: colors.textDisabled,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: effectiveSuffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.sm,
            ),
            border: outlineBorder,
            enabledBorder: outlineBorder,
            disabledBorder: OutlineInputBorder(
              borderRadius: radius.borderRadiusMd,
              borderSide: BorderSide(color: colors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius.borderRadiusMd,
              borderSide: BorderSide(color: focusedBorderColor, width: 1.8),
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: spacing.xxs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.error_outline,
                  size: 14.0,
                  color: colors.error,
                ),
              ),
              SizedBox(width: spacing.xxs),
              Expanded(
                child: Text(
                  widget.errorText!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.bodySmall.copyWith(
                    color: colors.error,
                  ),
                ),
              ),
            ],
          ),
        ] else if (hasHelper) ...[
          SizedBox(height: spacing.xxs),
          Text(
            widget.helperText!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: typography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
