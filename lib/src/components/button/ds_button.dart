import 'package:flutter/material.dart';
import '../../theme/ds_theme_extensions.dart';
import '../../tokens/ds_color_tokens.dart';
import '../../tokens/ds_spacing_tokens.dart';

/// Visual variants supported by [DsButton].
enum DsButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

/// Standardized size options for [DsButton].
enum DsButtonSize {
  sm,
  md,
  lg,
}

/// A defensive, accessible button component for the Design System.
///
/// Built with anti-overflow constraints ([Flexible] + [TextOverflow.ellipsis]),
/// automatic double-tap protection when [isLoading] is `true`, and full support
/// for [DsColorTokens], [DsSpacingTokens], and [DsRadiusTokens].
class DsButton extends StatelessWidget {
  const DsButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = DsButtonVariant.primary,
    this.size = DsButtonSize.md,
    this.isLoading = false,
    this.isExpanded = false,
    this.leadingIcon,
    this.trailingIcon,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final DsButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String? semanticLabel;

  bool get _isInteractive => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final spacing = context.dsSpacing;
    final radius = context.dsRadius;
    final typography = context.dsTypography;

    final palette = _resolvePalette(colors, isEnabled: onPressed != null);
    final minHeight = _resolveMinHeight();
    final horizontalPadding = _resolveHorizontalPadding(spacing);
    final iconSize = _resolveIconSize();

    final textStyle = typography.label.copyWith(
      fontSize: size == DsButtonSize.sm ? 13.0 : (size == DsButtonSize.lg ? 16.0 : 14.0),
      color: palette.foreground,
    );

    final Widget buttonContent = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(palette.foreground),
            ),
          ),
          SizedBox(width: spacing.xs),
        ] else if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            size: iconSize,
            color: palette.foreground,
          ),
          SizedBox(width: spacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        if (!isLoading && trailingIcon != null) ...[
          SizedBox(width: spacing.xs),
          Icon(
            trailingIcon,
            size: iconSize,
            color: palette.foreground,
          ),
        ],
      ],
    );

    final Widget button = Semantics(
      button: true,
      enabled: _isInteractive,
      label: semanticLabel ?? label,
      excludeSemantics: semanticLabel != null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
          minWidth: isExpanded ? double.infinity : 0.0,
        ),
        child: Material(
          color: palette.background,
          shape: RoundedRectangleBorder(
            borderRadius: radius.borderRadiusMd,
            side: palette.border != null
                ? BorderSide(color: palette.border!)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _isInteractive ? onPressed : null,
            borderRadius: radius.borderRadiusMd,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: spacing.xs,
              ),
              child: buttonContent,
            ),
          ),
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }

  double _resolveMinHeight() {
    switch (size) {
      case DsButtonSize.sm:
        return 40.0;
      case DsButtonSize.md:
        return 48.0;
      case DsButtonSize.lg:
        return 54.0;
    }
  }

  double _resolveHorizontalPadding(DsSpacingTokens spacing) {
    switch (size) {
      case DsButtonSize.sm:
        return spacing.sm;
      case DsButtonSize.md:
        return spacing.md;
      case DsButtonSize.lg:
        return spacing.lg;
    }
  }

  double _resolveIconSize() {
    switch (size) {
      case DsButtonSize.sm:
        return 16.0;
      case DsButtonSize.md:
        return 18.0;
      case DsButtonSize.lg:
        return 20.0;
    }
  }

  _ButtonPalette _resolvePalette(
    DsColorTokens colors, {
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return _ButtonPalette(
        background: variant == DsButtonVariant.ghost
            ? Colors.transparent
            : colors.surfaceVariant,
        foreground: colors.textDisabled,
        border: variant == DsButtonVariant.outline ? colors.border : null,
      );
    }

    switch (variant) {
      case DsButtonVariant.primary:
        return _ButtonPalette(
          background: colors.primary,
          foreground: colors.textOnPrimary,
        );
      case DsButtonVariant.secondary:
        return _ButtonPalette(
          background: colors.secondary,
          foreground: colors.textOnPrimary,
        );
      case DsButtonVariant.outline:
        return _ButtonPalette(
          background: Colors.transparent,
          foreground: colors.primary,
          border: colors.border,
        );
      case DsButtonVariant.ghost:
        return _ButtonPalette(
          background: Colors.transparent,
          foreground: colors.primary,
        );
      case DsButtonVariant.danger:
        return _ButtonPalette(
          background: colors.error,
          foreground: colors.textOnPrimary,
        );
    }
  }
}

class _ButtonPalette {
  const _ButtonPalette({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}
