import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// 4px-grid spacing tokens for the Design System.
@immutable
class DsSpacingTokens extends ThemeExtension<DsSpacingTokens> {
  const DsSpacingTokens({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  /// Default 4px-grid spacing scale.
  const DsSpacingTokens.standard()
      : xxs = 4.0,
        xs = 8.0,
        sm = 12.0,
        md = 16.0,
        lg = 24.0,
        xl = 32.0,
        xxl = 48.0;

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  DsSpacingTokens copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return DsSpacingTokens(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  DsSpacingTokens lerp(ThemeExtension<DsSpacingTokens>? other, double t) {
    if (other is! DsSpacingTokens) {
      return this;
    }
    return DsSpacingTokens(
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DsSpacingTokens &&
        other.xxs == xxs &&
        other.xs == xs &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.xl == xl &&
        other.xxl == xxl;
  }

  @override
  int get hashCode => Object.hash(xxs, xs, sm, md, lg, xl, xxl);
}
