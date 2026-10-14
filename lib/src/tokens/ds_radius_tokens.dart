import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Border radius tokens for the Design System.
@immutable
class DsRadiusTokens extends ThemeExtension<DsRadiusTokens> {
  const DsRadiusTokens({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.full,
  });

  /// Standard radius scale.
  const DsRadiusTokens.standard()
      : none = 0.0,
        sm = 6.0,
        md = 10.0,
        lg = 16.0,
        full = 999.0;

  final double none;
  final double sm;
  final double md;
  final double lg;
  final double full;

  BorderRadius get borderRadiusNone => BorderRadius.circular(none);
  BorderRadius get borderRadiusSm => BorderRadius.circular(sm);
  BorderRadius get borderRadiusMd => BorderRadius.circular(md);
  BorderRadius get borderRadiusLg => BorderRadius.circular(lg);
  BorderRadius get borderRadiusFull => BorderRadius.circular(full);

  @override
  DsRadiusTokens copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? full,
  }) {
    return DsRadiusTokens(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      full: full ?? this.full,
    );
  }

  @override
  DsRadiusTokens lerp(ThemeExtension<DsRadiusTokens>? other, double t) {
    if (other is! DsRadiusTokens) {
      return this;
    }
    return DsRadiusTokens(
      none: lerpDouble(none, other.none, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DsRadiusTokens &&
        other.none == none &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.full == full;
  }

  @override
  int get hashCode => Object.hash(none, sm, md, lg, full);
}
