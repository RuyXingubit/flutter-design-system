import 'package:flutter/material.dart';

/// Semantic color tokens for the Design System.
///
/// Implements [ThemeExtension] so any consumer project can access colors via
/// `context.dsColors`, animate smoothly between Light and Dark themes using
/// [lerp], or override brand colors for White-Label customization via [copyWith].
@immutable
class DsColorTokens extends ThemeExtension<DsColorTokens> {
  const DsColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.error,
    required this.border,
    required this.divider,
  });

  /// Default Light Mode color palette.
  factory DsColorTokens.light() {
    return const DsColorTokens(
      background: Color(0xFFF8FAFC),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFF1F5F9),
      textPrimary: Color(0xFF0F172A),
      textSecondary: Color(0xFF475569),
      textDisabled: Color(0xFF94A3B8),
      textOnPrimary: Color(0xFFFFFFFF),
      primary: Color(0xFF2563EB),
      primaryContainer: Color(0xFFDBEAFE),
      secondary: Color(0xFF0F766E),
      success: Color(0xFF15803D),
      warning: Color(0xFFB45309),
      error: Color(0xFFB91C1C),
      border: Color(0xFFCBD5E1),
      divider: Color(0xFFE2E8F0),
    );
  }

  /// Default Dark Mode color palette.
  factory DsColorTokens.dark() {
    return const DsColorTokens(
      background: Color(0xFF0B0F19),
      surface: Color(0xFF111827),
      surfaceVariant: Color(0xFF1E293B),
      textPrimary: Color(0xFFF8FAFC),
      textSecondary: Color(0xFF94A3B8),
      textDisabled: Color(0xFF475569),
      textOnPrimary: Color(0xFFFFFFFF),
      primary: Color(0xFF3B82F6),
      primaryContainer: Color(0xFF1E3A8A),
      secondary: Color(0xFF14B8A6),
      success: Color(0xFF22C55E),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      border: Color(0xFF334155),
      divider: Color(0xFF1E293B),
    );
  }

  final Color background;
  final Color surface;
  final Color surfaceVariant;

  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textOnPrimary;

  final Color primary;
  final Color primaryContainer;
  final Color secondary;

  final Color success;
  final Color warning;
  final Color error;

  final Color border;
  final Color divider;

  @override
  DsColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? primary,
    Color? primaryContainer,
    Color? secondary,
    Color? success,
    Color? warning,
    Color? error,
    Color? border,
    Color? divider,
  }) {
    return DsColorTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      border: border ?? this.border,
      divider: divider ?? this.divider,
    );
  }

  @override
  DsColorTokens lerp(ThemeExtension<DsColorTokens>? other, double t) {
    if (other is! DsColorTokens) {
      return this;
    }
    return DsColorTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DsColorTokens &&
        other.background == background &&
        other.surface == surface &&
        other.surfaceVariant == surfaceVariant &&
        other.textPrimary == textPrimary &&
        other.textSecondary == textSecondary &&
        other.textDisabled == textDisabled &&
        other.textOnPrimary == textOnPrimary &&
        other.primary == primary &&
        other.primaryContainer == primaryContainer &&
        other.secondary == secondary &&
        other.success == success &&
        other.warning == warning &&
        other.error == error &&
        other.border == border &&
        other.divider == divider;
  }

  @override
  int get hashCode => Object.hash(
        background,
        surface,
        surfaceVariant,
        textPrimary,
        textSecondary,
        textDisabled,
        textOnPrimary,
        primary,
        primaryContainer,
        secondary,
        success,
        warning,
        error,
        border,
        divider,
      );
}
