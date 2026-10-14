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
          body: child,
        ),
      ),
    );
  }

  group('DsStateView', () {
    testWidgets('empty constructor renders title, description, and action button',
        (tester) async {
      var actionTriggered = false;

      await tester.pumpWidget(
        wrapWithTheme(
          DsStateView.empty(
            title: 'Nenhum registro disponível',
            description: 'Aguardando integração com o endpoint.',
            actionLabel: 'Recarregar',
            onAction: () => actionTriggered = true,
          ),
        ),
      );

      expect(find.text('Nenhum registro disponível'), findsOneWidget);
      expect(find.text('Aguardando integração com o endpoint.'), findsOneWidget);

      await tester.tap(find.text('Recarregar'));
      await tester.pump();

      expect(actionTriggered, isTrue);
    });

    testWidgets('loading constructor displays progress indicator',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsStateView.loading(
            title: 'Sincronizando módulos...',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sincronizando módulos...'), findsOneWidget);
    });

    testWidgets('error constructor renders error icon and danger action button',
        (tester) async {
      var retried = false;

      await tester.pumpWidget(
        wrapWithTheme(
          DsStateView.error(
            title: 'Falha na comunicação',
            description: 'Não foi possível estabelecer conexão.',
            actionLabel: 'Tentar novamente',
            onAction: () => retried = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets(
        'torture test: never overflows in tiny box (180x140) with 2.0x TextScaler',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: SizedBox(
              width: 180,
              height: 140,
              child: DsStateView.error(
                title: 'Título extenso para validação de limites de tela ' * 3,
                description:
                    'Descrição longa em container verticalmente e horizontalmente restrito ' *
                        3,
                actionLabel: 'Executar ação de recuperação longa',
                onAction: () {},
              ),
            ),
          ),
          textScaler: const TextScaler.linear(2.0),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DsStateView), findsOneWidget);
    });
  });
}
