import 'package:flutter/material.dart';
import '../foundations/ds_breakpoints.dart';
import '../tokens/ds_color_tokens.dart';
import '../tokens/ds_radius_tokens.dart';
import '../tokens/ds_spacing_tokens.dart';
import '../tokens/ds_typography_tokens.dart';
import 'ds_theme_controller.dart';

/// Ergonomic [BuildContext] getters for accessing Design System tokens,
/// responsive window size, and runtime theme controller with safe fallbacks.
extension DsThemeBuildContextExtension on BuildContext {
  /// Returns the active [DsColorTokens] from the ambient [Theme].
  DsColorTokens get dsColors {
    final theme = Theme.of(this);
    final extension = theme.extension<DsColorTokens>();
    if (extension != null) {
      return extension;
    }
    return theme.brightness == Brightness.dark
        ? DsColorTokens.dark()
        : DsColorTokens.light();
  }

  /// Returns the active [DsSpacingTokens] from the ambient [Theme].
  DsSpacingTokens get dsSpacing {
    return Theme.of(this).extension<DsSpacingTokens>() ??
        const DsSpacingTokens.standard();
  }

  /// Returns the active [DsRadiusTokens] from the ambient [Theme].
  DsRadiusTokens get dsRadius {
    return Theme.of(this).extension<DsRadiusTokens>() ??
        const DsRadiusTokens.standard();
  }

  /// Returns the active [DsTypographyTokens] from the ambient [Theme].
  DsTypographyTokens get dsTypography {
    final extension = Theme.of(this).extension<DsTypographyTokens>();
    if (extension != null) {
      return extension;
    }
    final colors = dsColors;
    return DsTypographyTokens.fromColors(
      textPrimary: colors.textPrimary,
      textSecondary: colors.textSecondary,
    );
  }

  /// Returns the semantic [DsWindowSize] (`compact`, `medium`, `expanded`)
  /// for the current viewport width.
  DsWindowSize get dsWindowSize => DsBreakpoints.of(this);

  /// Returns the nearest [DsThemeController] from [DsThemeScope] for runtime
  /// user customization.
  DsThemeController get dsThemeController => DsThemeScope.of(this);

  /// Returns the nearest [DsThemeController] from [DsThemeScope], or `null`
  /// if no [DsThemeScope] is mounted above this context.
  DsThemeController? get maybeDsThemeController => DsThemeScope.maybeOf(this);
}
