import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsColorTokens', () {
    test('light() and dark() palettes have distinct semantic values', () {
      final light = DsColorTokens.light();
      final dark = DsColorTokens.dark();

      expect(light, isNot(equals(dark)));
      expect(light.background, const Color(0xFFF8FAFC));
      expect(dark.background, const Color(0xFF0B0F19));
      expect(light.hashCode, isNot(equals(dark.hashCode)));
    });

    test('copyWith overrides specified colors and preserves others', () {
      final base = DsColorTokens.light();
      const customPrimary = Color(0xFF7C3AED);
      final updated = base.copyWith(primary: customPrimary);

      expect(updated.primary, customPrimary);
      expect(updated.background, base.background);
      expect(updated.surface, base.surface);
      expect(updated.error, base.error);
    });

    test('lerp interpolates between light and dark palettes accurately', () {
      final light = DsColorTokens.light();
      final dark = DsColorTokens.dark();

      expect(light.lerp(null, 0.5), equals(light));
      expect(light.lerp(dark, 0.0), equals(light));
      expect(light.lerp(dark, 1.0), equals(dark));

      final mid = light.lerp(dark, 0.5);
      expect(
        mid.primary,
        Color.lerp(light.primary, dark.primary, 0.5),
      );
    });
  });

  group('DsSpacingTokens', () {
    test('standard() follows 4px grid scale', () {
      const spacing = DsSpacingTokens.standard();

      expect(spacing.xxs, 4.0);
      expect(spacing.xs, 8.0);
      expect(spacing.sm, 12.0);
      expect(spacing.md, 16.0);
      expect(spacing.lg, 24.0);
      expect(spacing.xl, 32.0);
      expect(spacing.xxl, 48.0);
    });

    test('copyWith and lerp work as expected', () {
      const base = DsSpacingTokens.standard();
      final doubled = base.copyWith(md: 32.0);

      expect(doubled.md, 32.0);
      expect(doubled.sm, base.sm);
      expect(base.lerp(null, 0.5), equals(base));

      final mid = base.lerp(doubled, 0.5);
      expect(mid.md, 24.0);
      expect(mid.hashCode, isNot(equals(base.hashCode)));
    });
  });

  group('DsRadiusTokens', () {
    test('standard() provides expected values and BorderRadius getters', () {
      const radius = DsRadiusTokens.standard();

      expect(radius.none, 0.0);
      expect(radius.sm, 6.0);
      expect(radius.md, 10.0);
      expect(radius.lg, 16.0);
      expect(radius.full, 999.0);

      expect(radius.borderRadiusNone, BorderRadius.circular(0.0));
      expect(radius.borderRadiusSm, BorderRadius.circular(6.0));
      expect(radius.borderRadiusMd, BorderRadius.circular(10.0));
      expect(radius.borderRadiusLg, BorderRadius.circular(16.0));
      expect(radius.borderRadiusFull, BorderRadius.circular(999.0));
    });

    test('copyWith and lerp interpolate radius values', () {
      const base = DsRadiusTokens.standard();
      final custom = base.copyWith(md: 20.0);

      expect(base.lerp(null, 0.5), equals(base));
      final mid = base.lerp(custom, 0.5);
      expect(mid.md, 15.0);
    });
  });

  group('DsTypographyTokens', () {
    test('fromColors binds textPrimary and textSecondary to styles', () {
      final lightColors = DsColorTokens.light();
      final typography = DsTypographyTokens.fromColors(
        textPrimary: lightColors.textPrimary,
        textSecondary: lightColors.textSecondary,
        fontFamily: 'Roboto',
      );

      expect(typography.display.color, lightColors.textPrimary);
      expect(typography.bodySmall.color, lightColors.textSecondary);
      expect(typography.label.fontFamily, 'Roboto');
    });

    test('copyWith and lerp interpolate TextStyles', () {
      final light = DsTypographyTokens.fromColors(
        textPrimary: DsColorTokens.light().textPrimary,
        textSecondary: DsColorTokens.light().textSecondary,
      );
      final dark = DsTypographyTokens.fromColors(
        textPrimary: DsColorTokens.dark().textPrimary,
        textSecondary: DsColorTokens.dark().textSecondary,
      );

      expect(light.lerp(null, 0.5), equals(light));
      expect(light.copyWith(title: dark.title).title, equals(dark.title));

      final mid = light.lerp(dark, 0.5);
      expect(
        mid.display.color,
        Color.lerp(light.display.color, dark.display.color, 0.5),
      );
    });
  });

  group('DsBreakpoints', () {
    test('fromWidth classifies compact, medium, and expanded boundaries', () {
      expect(DsBreakpoints.fromWidth(320), DsWindowSize.compact);
      expect(DsBreakpoints.fromWidth(599.9), DsWindowSize.compact);
      expect(DsBreakpoints.fromWidth(600.0), DsWindowSize.medium);
      expect(DsBreakpoints.fromWidth(1023.9), DsWindowSize.medium);
      expect(DsBreakpoints.fromWidth(1024.0), DsWindowSize.expanded);
      expect(DsBreakpoints.fromWidth(1440.0), DsWindowSize.expanded);
    });
  });

  group('DsTheme & BuildContext Extensions', () {
    testWidgets('provides DsTheme tokens via BuildContext extensions',
        (tester) async {
      const customBrandColor = Color(0xFF059669);
      late DsColorTokens resolvedColors;
      late DsSpacingTokens resolvedSpacing;
      late DsRadiusTokens resolvedRadius;
      late DsTypographyTokens resolvedTypography;
      late DsWindowSize resolvedWindowSize;

      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: DsTheme.light(
            colorsOverride: DsColorTokens.light().copyWith(
              primary: customBrandColor,
            ),
          ),
          home: Builder(
            builder: (context) {
              resolvedColors = context.dsColors;
              resolvedSpacing = context.dsSpacing;
              resolvedRadius = context.dsRadius;
              resolvedTypography = context.dsTypography;
              resolvedWindowSize = context.dsWindowSize;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedColors.primary, customBrandColor);
      expect(resolvedSpacing.md, 16.0);
      expect(resolvedRadius.md, 10.0);
      expect(resolvedTypography.bodyMedium.fontSize, 14.0);
      expect(resolvedWindowSize, DsWindowSize.compact);
    });

    testWidgets('gracefully falls back when used outside DsTheme',
        (tester) async {
      late DsColorTokens fallbackColors;
      late DsSpacingTokens fallbackSpacing;
      late DsRadiusTokens fallbackRadius;
      late DsTypographyTokens fallbackTypography;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              fallbackColors = context.dsColors;
              fallbackSpacing = context.dsSpacing;
              fallbackRadius = context.dsRadius;
              fallbackTypography = context.dsTypography;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(fallbackColors, equals(DsColorTokens.dark()));
      expect(fallbackSpacing, equals(const DsSpacingTokens.standard()));
      expect(fallbackRadius, equals(const DsRadiusTokens.standard()));
      expect(
        fallbackTypography.display.color,
        equals(DsColorTokens.dark().textPrimary),
      );
    });
  });
}
