import 'package:flutter/material.dart';

/// Semantic typography tokens for the Design System.
@immutable
class DsTypographyTokens extends ThemeExtension<DsTypographyTokens> {
  const DsTypographyTokens({
    required this.display,
    required this.headline,
    required this.title,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.label,
  });

  /// Creates the default typography scale bound to the given text colors.
  factory DsTypographyTokens.fromColors({
    required Color textPrimary,
    required Color textSecondary,
    String? fontFamily,
  }) {
    return DsTypographyTokens(
      display: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.5,
        color: textPrimary,
      ),
      headline: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.25,
        color: textPrimary,
      ),
      title: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: textSecondary,
      ),
      label: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
    );
  }

  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle label;

  @override
  DsTypographyTokens copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? label,
  }) {
    return DsTypographyTokens(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
    );
  }

  @override
  DsTypographyTokens lerp(ThemeExtension<DsTypographyTokens>? other, double t) {
    if (other is! DsTypographyTokens) {
      return this;
    }
    return DsTypographyTokens(
      display: TextStyle.lerp(display, other.display, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DsTypographyTokens &&
        other.display == display &&
        other.headline == headline &&
        other.title == title &&
        other.bodyLarge == bodyLarge &&
        other.bodyMedium == bodyMedium &&
        other.bodySmall == bodySmall &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(
        display,
        headline,
        title,
        bodyLarge,
        bodyMedium,
        bodySmall,
        label,
      );
}
