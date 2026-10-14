import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsRuntimeConfig & DsThemeController', () {
    test('serializes and deserializes via toMap and fromMap accurately', () {
      const original = DsRuntimeConfig(
        themeMode: ThemeMode.dark,
        customPrimaryColor: Color(0xFF059669),
        cornerStyle: DsCornerStyle.rounded,
        density: DsVisualDensity.comfortable,
      );

      final map = original.toMap();
      final restored = DsRuntimeConfig.fromMap(map);

      expect(restored, equals(original));
      expect(restored.hashCode, equals(original.hashCode));
    });

    test('fromMap safely falls back to defaults on invalid or corrupted data',
        () {
      final restored = DsRuntimeConfig.fromMap(const <String, Object?>{
        'themeMode': 'invalid_mode',
        'customPrimaryColor': -999,
        'cornerStyle': 12345,
        'density': null,
      });

      expect(restored, equals(const DsRuntimeConfig()));
    });

    test('DsThemeController notifies listeners and invokes onConfigChanged',
        () {
      DsRuntimeConfig? persistedConfig;
      final controller = DsThemeController(
        onConfigChanged: (config) => persistedConfig = config,
      );

      controller.setThemeMode(ThemeMode.dark);
      expect(controller.themeMode, ThemeMode.dark);
      expect(persistedConfig?.themeMode, ThemeMode.dark);

      controller.setPrimaryColor(const Color(0xFF7C3AED));
      expect(
        controller.lightTheme.extension<DsColorTokens>()?.primary,
        const Color(0xFF7C3AED),
      );

      controller.setCornerStyle(DsCornerStyle.sharp);
      expect(
        controller.lightTheme.extension<DsRadiusTokens>()?.md,
        2.0,
      );

      controller.setDensity(DsVisualDensity.compact);
      expect(
        controller.lightTheme.extension<DsSpacingTokens>()?.md,
        12.0,
      );

      controller.resetToDefaults();
      expect(controller.config, equals(const DsRuntimeConfig()));
    });
  });

  group('DsThemeSettingsPanel & DsThemeScope', () {
    testWidgets(
        'allows end-user to change theme mode, color, corners, and density at runtime',
        (tester) async {
      final controller = DsThemeController();

      await tester.pumpWidget(
        DsThemeScope(
          controller: controller,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return MaterialApp(
                themeMode: controller.themeMode,
                theme: controller.lightTheme,
                darkTheme: controller.darkTheme,
                home: const Scaffold(
                  body: SingleChildScrollView(
                    child: DsThemeSettingsPanel(),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Select Dark Mode
      await tester.tap(find.text('Escuro'));
      await tester.pumpAndSettle();
      expect(controller.themeMode, ThemeMode.dark);

      // Select Esmeralda brand color
      await tester.tap(find.text('Esmeralda'));
      await tester.pumpAndSettle();
      expect(controller.config.customPrimaryColor, const Color(0xFF059669));

      // Select Arredondado corner style
      await tester.tap(find.text('Arredondado'));
      await tester.pumpAndSettle();
      expect(controller.config.cornerStyle, DsCornerStyle.rounded);

      // Select Confortável density
      await tester.tap(find.text('Confortável'));
      await tester.pumpAndSettle();
      expect(controller.config.density, DsVisualDensity.comfortable);

      // Reset to defaults
      await tester.tap(find.text('Restaurar Padrão'));
      await tester.pumpAndSettle();
      expect(controller.config, equals(const DsRuntimeConfig()));
    });

    testWidgets(
        'torture test: DsThemeSettingsPanel never overflows in 180px width with 2.0x TextScaler',
        (tester) async {
      final controller = DsThemeController();

      await tester.pumpWidget(
        DsThemeScope(
          controller: controller,
          child: MaterialApp(
            theme: controller.lightTheme,
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2.0),
              ),
              child: const Scaffold(
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: 180,
                    child: DsThemeSettingsPanel(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DsThemeSettingsPanel), findsOneWidget);
    });
  });
}
