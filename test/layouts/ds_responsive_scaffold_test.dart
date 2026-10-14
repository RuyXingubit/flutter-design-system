import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sampleDestinations = <DsNavigationItem>[
    DsNavigationItem(
      label: 'Tokens',
      icon: Icons.palette_outlined,
      selectedIcon: Icons.palette,
    ),
    DsNavigationItem(
      label: 'Componentes',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
    ),
    DsNavigationItem(
      label: 'Layouts',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
  ];

  group('DsResponsiveScaffold', () {
    testWidgets(
        'adapts automatically across compact, medium, and expanded breakpoints',
        (tester) async {
      addTearDown(tester.view.reset);
      var selectedIndex = 0;

      Widget buildScaffold() {
        return MaterialApp(
          theme: DsTheme.light(),
          home: StatefulBuilder(
            builder: (context, setState) {
              return DsResponsiveScaffold(
                title: 'Catálogo Técnico',
                destinations: sampleDestinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => selectedIndex = index);
                },
                body: const Center(
                  child: Text('Conteúdo Principal'),
                ),
              );
            },
          ),
        );
      }

      // 1. Compact (< 600px) -> Bottom NavigationBar
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(buildScaffold());

      expect(
        find.byKey(const ValueKey<String>('ds_compact_navigation_bar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('ds_medium_navigation_rail')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('ds_expanded_sidebar')),
        findsNothing,
      );

      // 2. Medium (600px - 1023px) -> NavigationRail
      tester.view.physicalSize = const Size(800, 1024);
      await tester.pumpWidget(buildScaffold());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('ds_compact_navigation_bar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('ds_medium_navigation_rail')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('ds_expanded_sidebar')),
        findsNothing,
      );

      // 3. Expanded (>= 1024px) -> Desktop Sidebar
      tester.view.physicalSize = const Size(1440, 900);
      await tester.pumpWidget(buildScaffold());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('ds_compact_navigation_bar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('ds_medium_navigation_rail')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('ds_expanded_sidebar')),
        findsOneWidget,
      );

      // Tap second destination in desktop sidebar
      await tester.tap(find.text('Componentes'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);
    });

    testWidgets('renders clean scaffold without navigation when destinations is empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DsTheme.light(),
          home: const DsResponsiveScaffold(
            title: 'Tela Única',
            body: Center(child: Text('Corpo Simples')),
          ),
        ),
      );

      expect(find.text('Corpo Simples'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets(
        'torture test: never overflows with long labels and 2.0x TextScaler across all breakpoints',
        (tester) async {
      addTearDown(tester.view.reset);
      final longDestinations = <DsNavigationItem>[
        DsNavigationItem(
          label: 'Item de navegação extremamente longo ' * 3,
          icon: Icons.folder_outlined,
        ),
        DsNavigationItem(
          label: 'Segunda seção com rótulo gigante ' * 3,
          icon: Icons.settings_outlined,
        ),
      ];

      for (final width in <double>[320.0, 768.0, 1280.0]) {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            theme: DsTheme.light(),
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(width, 800),
                textScaler: const TextScaler.linear(2.0),
              ),
              child: DsResponsiveScaffold(
                title: 'Título de página muito extenso para teste ' * 3,
                destinations: longDestinations,
                selectedIndex: 0,
                onDestinationSelected: (_) {},
                body: const DsStateView.empty(
                  title: 'Área principal pronta',
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      }
    });
  });
}
