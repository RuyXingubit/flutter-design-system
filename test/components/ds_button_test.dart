import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TextScaler? textScaler}) {
    return MaterialApp(
      theme: DsTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: textScaler ?? TextScaler.noScaling,
        ),
        child: Scaffold(
          body: Center(child: child),
        ),
      ),
    );
  }

  group('DsButton', () {
    testWidgets('executes onPressed when enabled and clicked', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            label: 'Confirmar',
            onPressed: () => tapCount++,
          ),
        ),
      );

      await tester.tap(find.text('Confirmar'));
      await tester.pump();

      expect(tapCount, 1);
    });

    testWidgets('blocks taps and shows progress indicator when isLoading is true',
        (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            label: 'Salvando',
            isLoading: true,
            onPressed: () => tapCount++,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(DsButton));
      await tester.pump();

      expect(tapCount, 0);
    });

    testWidgets('renders all variants and sizes without errors', (tester) async {
      for (final variant in DsButtonVariant.values) {
        for (final size in DsButtonSize.values) {
          await tester.pumpWidget(
            wrapWithTheme(
              DsButton(
                label: '${variant.name}-${size.name}',
                variant: variant,
                size: size,
                leadingIcon: Icons.add,
                trailingIcon: Icons.arrow_forward,
                onPressed: () {},
              ),
            ),
          );
          expect(find.text('${variant.name}-${size.name}'), findsOneWidget);
        }
      }
    });

    testWidgets('torture test: never overflows with long text and 2.0x TextScaler',
        (tester) async {
      final longLabel = 'Botão com texto extremamente longo ' * 6;

      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 160,
            child: DsButton(
              label: longLabel,
              leadingIcon: Icons.lock_outline,
              trailingIcon: Icons.chevron_right,
              isExpanded: true,
              onPressed: () {},
            ),
          ),
          textScaler: const TextScaler.linear(2.0),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DsButton), findsOneWidget);
    });
  });
}
