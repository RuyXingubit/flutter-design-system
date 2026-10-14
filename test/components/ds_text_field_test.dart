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

  group('DsTextField', () {
    testWidgets('displays label, helperText, and handles text input',
        (tester) async {
      String? typedValue;

      await tester.pumpWidget(
        wrapWithTheme(
          DsTextField(
            label: 'E-mail corporativo',
            hintText: 'nome@empresa.com',
            helperText: 'Utilize seu endereço institucional',
            onChanged: (value) => typedValue = value,
          ),
        ),
      );

      expect(find.text('E-mail corporativo'), findsOneWidget);
      expect(find.text('Utilize seu endereço institucional'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'dev@empresa.com');
      expect(typedValue, 'dev@empresa.com');
    });

    testWidgets('prioritizes errorText over helperText when error is present',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTextField(
            label: 'Identificador',
            helperText: 'Texto auxiliar que deve ser ocultado no erro',
            errorText: 'Campo obrigatório não preenchido',
          ),
        ),
      );

      expect(find.text('Campo obrigatório não preenchido'), findsOneWidget);
      expect(
        find.text('Texto auxiliar que deve ser ocultado no erro'),
        findsNothing,
      );
    });

    testWidgets(
        'password constructor enforces security flags and toggles visibility',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTextField.password(
            label: 'Senha de acesso',
          ),
        ),
      );

      TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
      expect(textField.enableSuggestions, isFalse);
      expect(textField.autocorrect, isFalse);

      // Tap visibility toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
    });

    testWidgets('torture test: never overflows with long label, error, and 2.0x TextScaler',
        (tester) async {
      final longLabel = 'Rótulo de campo muito extenso para testar limites ' * 4;
      final longError = 'Mensagem detalhada de validação em tela estreita ' * 4;

      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 180,
            child: DsTextField(
              label: longLabel,
              errorText: longError,
              prefixIcon: const Icon(Icons.key),
            ),
          ),
          textScaler: const TextScaler.linear(2.0),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DsTextField), findsOneWidget);
    });
  });
}
