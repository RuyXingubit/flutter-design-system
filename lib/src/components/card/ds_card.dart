import 'package:flutter/material.dart';
import '../../theme/ds_theme_extensions.dart';

/// A standardized surface container for the Design System.
///
/// Uses [DsColorTokens], [DsSpacingTokens], and [DsRadiusTokens] from the ambient
/// theme, clips its child with [Clip.antiAlias], and supports optional
/// interactive tap handling.
class DsCard extends StatelessWidget {
  const DsCard({
    required this.child,
    super.key,
    this.padding,
    this.onTap,
    this.hasBorder = true,
    this.backgroundColor,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool hasBorder;
  final Color? backgroundColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final spacing = context.dsSpacing;
    final radius = context.dsRadius;

    final effectivePadding = padding ?? EdgeInsets.all(spacing.md);
    final effectiveBorderRadius = radius.borderRadiusLg;

    Widget content = Padding(
      padding: effectivePadding,
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: content,
      );
    }

    final Widget card = Material(
      color: backgroundColor ?? colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: hasBorder
            ? BorderSide(color: colors.border)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (semanticLabel != null || onTap != null) {
      return Semantics(
        container: true,
        button: onTap != null,
        label: semanticLabel,
        child: card,
      );
    }

    return card;
  }
}
