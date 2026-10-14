import 'package:ds_showcase/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'DsShowcaseApp navigates across Tokens, Componentes, Estados & Layout, and Runtime Config',
      (tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const DsShowcaseApp());
    await tester.pumpAndSettle();

    // Starts on Tokens tab
    expect(find.text('DsColorTokens'), findsOneWidget);
    expect(find.text('DsSpacingTokens (Grid 4px)'), findsOneWidget);

    // Toggle Dark Mode and White-Label override
    await tester.tap(find.byKey(const ValueKey<String>('toggle_theme_button')));
    await tester.pumpAndSettle();

    await tester
        .tap(find.byKey(const ValueKey<String>('toggle_whitelabel_button')));
    await tester.pumpAndSettle();

    // Navigate to Componentes tab
    await tester.tap(find.text('Componentes'));
    await tester.pumpAndSettle();
    expect(find.text('DsButton — Variantes e Tamanhos'), findsOneWidget);
    expect(find.text('DsTextField — Inputs e Segurança'), findsOneWidget);

    // Navigate to Estados & Layout tab
    await tester.tap(find.text('Estados & Layout'));
    await tester.pumpAndSettle();
    expect(find.text('DsStateView — Estados Técnicos Reais'), findsOneWidget);

    // Navigate to Runtime Config tab
    await tester.tap(find.text('Runtime Config'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'DsThemeSettingsPanel — Personalização pelo Usuário em Runtime',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('DsShowcaseApp renders without overflow on compact 320px screen',
      (tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const DsShowcaseApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
