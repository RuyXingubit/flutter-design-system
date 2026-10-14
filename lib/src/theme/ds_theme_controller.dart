import 'package:flutter/material.dart';
import '../tokens/ds_color_tokens.dart';
import '../tokens/ds_radius_tokens.dart';
import '../tokens/ds_spacing_tokens.dart';
import 'ds_theme.dart';

/// Corner roundness styles selectable by the end-user at runtime.
enum DsCornerStyle {
  sharp,
  subtle,
  standard,
  rounded,
}

/// Visual spacing density selectable by the end-user at runtime.
enum DsVisualDensity {
  compact,
  standard,
  comfortable,
}

/// Pre-configured accessible brand color options for runtime user selection.
@immutable
class DsBrandColorOption {
  const DsBrandColorOption({
    required this.id,
    required this.label,
    required this.color,
  });

  final String id;
  final String label;
  final Color color;

  static const List<DsBrandColorOption> defaults = <DsBrandColorOption>[
    DsBrandColorOption(
      id: 'blue',
      label: 'Azul Padrão',
      color: Color(0xFF2563EB),
    ),
    DsBrandColorOption(
      id: 'emerald',
      label: 'Esmeralda',
      color: Color(0xFF059669),
    ),
    DsBrandColorOption(
      id: 'violet',
      label: 'Violeta',
      color: Color(0xFF7C3AED),
    ),
    DsBrandColorOption(
      id: 'amber',
      label: 'Âmbar',
      color: Color(0xFFD97706),
    ),
    DsBrandColorOption(
      id: 'rose',
      label: 'Rubi',
      color: Color(0xFFE11D48),
    ),
  ];
}

/// Serializable runtime configuration representing the user's visual choices.
///
/// Can be persisted to local storage (`SharedPreferences`, SQLite) or a user
/// profile endpoint via [toMap] and restored safely via [DsRuntimeConfig.fromMap].
@immutable
class DsRuntimeConfig {
  const DsRuntimeConfig({
    this.themeMode = ThemeMode.system,
    this.customPrimaryColor,
    this.cornerStyle = DsCornerStyle.standard,
    this.density = DsVisualDensity.standard,
  });

  /// Safely deserializes a [DsRuntimeConfig] from a JSON/storage map,
  /// falling back to defaults if any field is missing or invalid.
  factory DsRuntimeConfig.fromMap(Map<String, Object?> map) {
    final modeName = map['themeMode'];
    final themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == modeName,
      orElse: () => ThemeMode.system,
    );

    final cornerName = map['cornerStyle'];
    final cornerStyle = DsCornerStyle.values.firstWhere(
      (c) => c.name == cornerName,
      orElse: () => DsCornerStyle.standard,
    );

    final densityName = map['density'];
    final density = DsVisualDensity.values.firstWhere(
      (d) => d.name == densityName,
      orElse: () => DsVisualDensity.standard,
    );

    Color? primaryColor;
    final rawColor = map['customPrimaryColor'];
    if (rawColor is int && rawColor >= 0 && rawColor <= 0xFFFFFFFF) {
      primaryColor = Color(rawColor);
    }

    return DsRuntimeConfig(
      themeMode: themeMode,
      customPrimaryColor: primaryColor,
      cornerStyle: cornerStyle,
      density: density,
    );
  }

  final ThemeMode themeMode;
  final Color? customPrimaryColor;
  final DsCornerStyle cornerStyle;
  final DsVisualDensity density;

  DsRuntimeConfig copyWith({
    ThemeMode? themeMode,
    Color? customPrimaryColor,
    bool clearPrimaryColor = false,
    DsCornerStyle? cornerStyle,
    DsVisualDensity? density,
  }) {
    return DsRuntimeConfig(
      themeMode: themeMode ?? this.themeMode,
      customPrimaryColor: clearPrimaryColor
          ? null
          : (customPrimaryColor ?? this.customPrimaryColor),
      cornerStyle: cornerStyle ?? this.cornerStyle,
      density: density ?? this.density,
    );
  }

  /// Serializes this configuration into a primitive map suitable for JSON or
  /// key-value persistence.
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'themeMode': themeMode.name,
      'customPrimaryColor': customPrimaryColor?.toARGB32(),
      'cornerStyle': cornerStyle.name,
      'density': density.name,
    };
  }

  /// Resolves [DsRadiusTokens] according to the user's selected [cornerStyle].
  DsRadiusTokens resolveRadiusTokens() {
    switch (cornerStyle) {
      case DsCornerStyle.sharp:
        return const DsRadiusTokens(
          none: 0.0,
          sm: 0.0,
          md: 2.0,
          lg: 4.0,
          full: 999.0,
        );
      case DsCornerStyle.subtle:
        return const DsRadiusTokens(
          none: 0.0,
          sm: 4.0,
          md: 6.0,
          lg: 10.0,
          full: 999.0,
        );
      case DsCornerStyle.standard:
        return const DsRadiusTokens.standard();
      case DsCornerStyle.rounded:
        return const DsRadiusTokens(
          none: 0.0,
          sm: 10.0,
          md: 16.0,
          lg: 24.0,
          full: 999.0,
        );
    }
  }

  /// Resolves [DsSpacingTokens] according to the user's selected [density].
  DsSpacingTokens resolveSpacingTokens() {
    const base = DsSpacingTokens.standard();
    final factor = switch (density) {
      DsVisualDensity.compact => 0.75,
      DsVisualDensity.standard => 1.0,
      DsVisualDensity.comfortable => 1.25,
    };
    if (factor == 1.0) {
      return base;
    }
    return DsSpacingTokens(
      xxs: base.xxs * factor,
      xs: base.xs * factor,
      sm: base.sm * factor,
      md: base.md * factor,
      lg: base.lg * factor,
      xl: base.xl * factor,
      xxl: base.xxl * factor,
    );
  }

  /// Resolves Light or Dark [DsColorTokens] applying [customPrimaryColor] if set.
  DsColorTokens resolveColorTokens(
    Brightness brightness, {
    DsColorTokens? baseOverride,
  }) {
    final base = baseOverride ??
        (brightness == Brightness.dark
            ? DsColorTokens.dark()
            : DsColorTokens.light());

    final chosenPrimary = customPrimaryColor;
    if (chosenPrimary == null) {
      return base;
    }

    final containerColor = Color.lerp(
      chosenPrimary,
      brightness == Brightness.dark ? Colors.black : Colors.white,
      brightness == Brightness.dark ? 0.65 : 0.82,
    )!;

    return base.copyWith(
      primary: chosenPrimary,
      primaryContainer: containerColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DsRuntimeConfig &&
        other.themeMode == themeMode &&
        other.customPrimaryColor == customPrimaryColor &&
        other.cornerStyle == cornerStyle &&
        other.density == density;
  }

  @override
  int get hashCode => Object.hash(
        themeMode,
        customPrimaryColor,
        cornerStyle,
        density,
      );
}

/// Reactive controller allowing end-users to customize the Design System
/// appearance at runtime (`ThemeMode`, brand color, corner style, spacing density).
class DsThemeController extends ChangeNotifier {
  DsThemeController({
    DsRuntimeConfig initialConfig = const DsRuntimeConfig(),
    this.baseLightColors,
    this.baseDarkColors,
    this.fontFamily,
    this.onConfigChanged,
  }) : _config = initialConfig;

  DsRuntimeConfig _config;
  final DsColorTokens? baseLightColors;
  final DsColorTokens? baseDarkColors;
  final String? fontFamily;

  /// Optional callback invoked whenever the user changes a runtime preference,
  /// allowing the host app to persist `config.toMap()`.
  final ValueChanged<DsRuntimeConfig>? onConfigChanged;

  DsRuntimeConfig get config => _config;
  ThemeMode get themeMode => _config.themeMode;

  /// Builds the active Light [ThemeData] reflecting the current [config].
  ThemeData get lightTheme => DsTheme.light(
        colorsOverride: _config.resolveColorTokens(
          Brightness.light,
          baseOverride: baseLightColors,
        ),
        spacingOverride: _config.resolveSpacingTokens(),
        radiusOverride: _config.resolveRadiusTokens(),
        fontFamily: fontFamily,
      );

  /// Builds the active Dark [ThemeData] reflecting the current [config].
  ThemeData get darkTheme => DsTheme.dark(
        colorsOverride: _config.resolveColorTokens(
          Brightness.dark,
          baseOverride: baseDarkColors,
        ),
        spacingOverride: _config.resolveSpacingTokens(),
        radiusOverride: _config.resolveRadiusTokens(),
        fontFamily: fontFamily,
      );

  void updateConfig(DsRuntimeConfig newConfig) {
    if (_config == newConfig) return;
    _config = newConfig;
    notifyListeners();
    onConfigChanged?.call(_config);
  }

  void setThemeMode(ThemeMode mode) {
    updateConfig(_config.copyWith(themeMode: mode));
  }

  void setPrimaryColor(Color? color) {
    updateConfig(
      _config.copyWith(
        customPrimaryColor: color,
        clearPrimaryColor: color == null,
      ),
    );
  }

  void setCornerStyle(DsCornerStyle cornerStyle) {
    updateConfig(_config.copyWith(cornerStyle: cornerStyle));
  }

  void setDensity(DsVisualDensity density) {
    updateConfig(_config.copyWith(density: density));
  }

  void resetToDefaults() {
    updateConfig(const DsRuntimeConfig());
  }
}

/// Provides a [DsThemeController] down the widget tree so any screen or
/// settings panel can read and update runtime theme preferences.
class DsThemeScope extends InheritedNotifier<DsThemeController> {
  const DsThemeScope({
    required DsThemeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Returns the nearest [DsThemeController] in the widget tree, or `null` if
  /// no [DsThemeScope] is present.
  static DsThemeController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DsThemeScope>()
        ?.notifier;
  }

  /// Returns the nearest [DsThemeController] in the widget tree.
  static DsThemeController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'No DsThemeScope found in context. Wrap your MaterialApp with DsThemeScope.',
    );
    return controller!;
  }
}
