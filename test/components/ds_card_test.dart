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

  group('DsCard', () {
    testWidgets('renders child content and handles optional onTap interaction',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          DsCard(
            semanticLabel: 'Card interativo',
            onTap: () => tapped = true,
            child: const Text('Conteúdo do card'),
          ),
        ),
      );

      expect(find.text('Conteúdo do card'), findsOneWidget);

      await tester.tap(find.byType(DsCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('respects custom padding and borderless configuration',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsCard(
            hasBorder: false,
            padding: EdgeInsets.all(24.0),
            child: Text('Sem borda'),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(DsCard),
          matching: find.byType(Material),
        ),
      );
      final shape = material.shape! as RoundedRectangleBorder;
      expect(shape.side, BorderSide.none);
    });

    testWidgets('torture test: clips and contains child within narrow viewport',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 180,
            child: DsCard(
              child: Row(
                children: [
                  const Icon(Icons.layers_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Texto contido com segurança dentro do card ' * 3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          textScaler: const TextScaler.linear(2.0),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DsCard), findsOneWidget);
    });
  });
}
