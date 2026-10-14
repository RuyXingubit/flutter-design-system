import 'package:flutter/material.dart';
import '../tokens/ds_color_tokens.dart';
import '../tokens/ds_radius_tokens.dart';
import '../tokens/ds_spacing_tokens.dart';
import '../tokens/ds_typography_tokens.dart';

/// Factory for building [ThemeData] pre-configured with all Design System
/// [ThemeExtension] tokens (`DsColorTokens`, `DsSpacingTokens`,
/// `DsRadiusTokens`, `DsTypographyTokens`).
abstract final class DsTheme {
  /// Builds the Light Mode [ThemeData] with optional White-Label overrides.
  static ThemeData light({
    DsColorTokens? colorsOverride,
    DsSpacingTokens? spacingOverride,
    DsRadiusTokens? radiusOverride,
    DsTypographyTokens? typographyOverride,
    String? fontFamily,
  }) {
    final colors = colorsOverride ?? DsColorTokens.light();
    return _buildTheme(
      brightness: Brightness.light,
      colors: colors,
      spacing: spacingOverride ?? const DsSpacingTokens.standard(),
      radius: radiusOverride ?? const DsRadiusTokens.standard(),
      typography: typographyOverride ??
          DsTypographyTokens.fromColors(
            textPrimary: colors.textPrimary,
            textSecondary: colors.textSecondary,
            fontFamily: fontFamily,
          ),
      fontFamily: fontFamily,
    );
  }

  /// Builds the Dark Mode [ThemeData] with optional White-Label overrides.
  static ThemeData dark({
    DsColorTokens? colorsOverride,
    DsSpacingTokens? spacingOverride,
    DsRadiusTokens? radiusOverride,
    DsTypographyTokens? typographyOverride,
    String? fontFamily,
  }) {
    final colors = colorsOverride ?? DsColorTokens.dark();
    return _buildTheme(
      brightness: Brightness.dark,
      colors: colors,
      spacing: spacingOverride ?? const DsSpacingTokens.standard(),
      radius: radiusOverride ?? const DsRadiusTokens.standard(),
      typography: typographyOverride ??
          DsTypographyTokens.fromColors(
            textPrimary: colors.textPrimary,
            textSecondary: colors.textSecondary,
            fontFamily: fontFamily,
          ),
      fontFamily: fontFamily,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required DsColorTokens colors,
    required DsSpacingTokens spacing,
    required DsRadiusTokens radius,
    required DsTypographyTokens typography,
    String? fontFamily,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.textOnPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.textPrimary,
      secondary: colors.secondary,
      onSecondary: colors.textOnPrimary,
      error: colors.error,
      onError: colors.textOnPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      dividerColor: colors.divider,
      textTheme: TextTheme(
        displaySmall: typography.display,
        headlineSmall: typography.headline,
        titleMedium: typography.title,
        bodyLarge: typography.bodyLarge,
        bodyMedium: typography.bodyMedium,
        bodySmall: typography.bodySmall,
        labelLarge: typography.label,
      ),
      extensions: <ThemeExtension<dynamic>>[
        colors,
        spacing,
        radius,
        typography,
      ],
    );
  }
}
