import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';

void main() {
  runApp(const DsShowcaseApp());
}

/// Interactive Technical Catalog for the Flutter Design System.
///
/// Inspects live [ThemeExtension] tokens, component variants, security flags,
/// neutral state views, and responsive breakpoints without any fake business data.
class DsShowcaseApp extends StatefulWidget {
  const DsShowcaseApp({super.key});

  @override
  State<DsShowcaseApp> createState() => _DsShowcaseAppState();
}

class _DsShowcaseAppState extends State<DsShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _useWhiteLabelOverride = false;
  int _selectedSectionIndex = 0;

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleWhiteLabel() {
    setState(() {
      _useWhiteLabelOverride = !_useWhiteLabelOverride;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightColors = _useWhiteLabelOverride
        ? DsColorTokens.light().copyWith(
            primary: const Color(0xFF059669),
            primaryContainer: const Color(0xFFD1FAE5),
          )
        : DsColorTokens.light();

    final darkColors = _useWhiteLabelOverride
        ? DsColorTokens.dark().copyWith(
            primary: const Color(0xFF10B981),
            primaryContainer: const Color(0xFF064E3B),
          )
        : DsColorTokens.dark();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Design System — Catálogo Técnico',
      themeMode: _themeMode,
      theme: DsTheme.light(colorsOverride: lightColors),
      darkTheme: DsTheme.dark(colorsOverride: darkColors),
      home: _ShowcaseShell(
        selectedIndex: _selectedSectionIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedSectionIndex = index);
        },
        isDarkMode: _themeMode == ThemeMode.dark,
        useWhiteLabelOverride: _useWhiteLabelOverride,
        onToggleThemeMode: _toggleThemeMode,
        onToggleWhiteLabel: _toggleWhiteLabel,
      ),
    );
  }
}

class _ShowcaseShell extends StatelessWidget {
  const _ShowcaseShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isDarkMode,
    required this.useWhiteLabelOverride,
    required this.onToggleThemeMode,
    required this.onToggleWhiteLabel,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isDarkMode;
  final bool useWhiteLabelOverride;
  final VoidCallback onToggleThemeMode;
  final VoidCallback onToggleWhiteLabel;

  static const _destinations = <DsNavigationItem>[
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
      label: 'Estados & Layout',
      icon: Icons.dashboard_customize_outlined,
      selectedIcon: Icons.dashboard_customize,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final windowSize = context.dsWindowSize;
    final colors = context.dsColors;
    final typography = context.dsTypography;

    return DsResponsiveScaffold(
      title: 'Design System (${windowSize.name})',
      destinations: _destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      sidebarHeader: Row(
        children: [
          Icon(Icons.layers, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'flutter_design_system',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.label,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          key: const ValueKey<String>('toggle_whitelabel_button'),
          tooltip: useWhiteLabelOverride
              ? 'Restaurar paleta padrão'
              : 'Testar override White-Label',
          onPressed: onToggleWhiteLabel,
          icon: Icon(
            useWhiteLabelOverride
                ? Icons.color_lens
                : Icons.color_lens_outlined,
            color: colors.primary,
          ),
        ),
        IconButton(
          key: const ValueKey<String>('toggle_theme_button'),
          tooltip: isDarkMode ? 'Ativar Light Mode' : 'Ativar Dark Mode',
          onPressed: onToggleThemeMode,
          icon: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        ),
      ],
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          _TokensCatalogSection(),
          _ComponentsCatalogSection(),
          _StatesAndLayoutCatalogSection(),
        ],
      ),
    );
  }
}

class _TokensCatalogSection extends StatelessWidget {
  const _TokensCatalogSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final spacing = context.dsSpacing;
    final radius = context.dsRadius;
    final typography = context.dsTypography;

    final colorEntries = <(String, Color)>[
      ('primary', colors.primary),
      ('primaryContainer', colors.primaryContainer),
      ('secondary', colors.secondary),
      ('surface', colors.surface),
      ('surfaceVariant', colors.surfaceVariant),
      ('background', colors.background),
      ('textPrimary', colors.textPrimary),
      ('textSecondary', colors.textSecondary),
      ('success', colors.success),
      ('warning', colors.warning),
      ('error', colors.error),
      ('border', colors.border),
    ];

    final spacingEntries = <(String, double)>[
      ('xxs', spacing.xxs),
      ('xs', spacing.xs),
      ('sm', spacing.sm),
      ('md', spacing.md),
      ('lg', spacing.lg),
      ('xl', spacing.xl),
      ('xxl', spacing.xxl),
    ];

    final radiusEntries = <(String, double)>[
      ('none', radius.none),
      ('sm', radius.sm),
      ('md', radius.md),
      ('lg', radius.lg),
      ('full', radius.full),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'DsColorTokens',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.sm,
            children: [
              for (final (name, color) in colorEntries)
                SizedBox(
                  width: 150,
                  child: DsCard(
                    padding: EdgeInsets.all(spacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: radius.borderRadiusSm,
                            border: Border.all(color: colors.border),
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: typography.label,
                        ),
                        Text(
                          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: typography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.xl),
          Text(
            'DsSpacingTokens (Grid 4px)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (name, value) in spacingEntries)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.xxs),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: typography.label,
                          ),
                        ),
                        SizedBox(
                          width: 56,
                          child: Text(
                            '${value.toInt()}px',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: typography.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: value,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: radius.borderRadiusSm,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            'DsRadiusTokens & DsTypographyTokens',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.sm,
            children: [
              for (final (name, value) in radiusEntries)
                DsCard(
                  padding: EdgeInsets.all(spacing.sm),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(value),
                          border: Border.all(color: colors.primary),
                        ),
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        '$name (${value.toInt()})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.bodySmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComponentsCatalogSection extends StatefulWidget {
  const _ComponentsCatalogSection();

  @override
  State<_ComponentsCatalogSection> createState() =>
      _ComponentsCatalogSectionState();
}

class _ComponentsCatalogSectionState extends State<_ComponentsCatalogSection> {
  bool _isLoadingButton = false;
  bool _showValidationError = false;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dsSpacing;
    final typography = context.dsTypography;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'DsButton — Variantes e Tamanhos',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: spacing.sm,
                  runSpacing: spacing.sm,
                  children: [
                    for (final variant in DsButtonVariant.values)
                      DsButton(
                        label: variant.name,
                        variant: variant,
                        onPressed: () {},
                      ),
                  ],
                ),
                SizedBox(height: spacing.md),
                Wrap(
                  spacing: spacing.sm,
                  runSpacing: spacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final size in DsButtonSize.values)
                      DsButton(
                        label: 'Size ${size.name}',
                        size: size,
                        variant: DsButtonVariant.outline,
                        onPressed: () {},
                      ),
                    DsButton(
                      label: _isLoadingButton
                          ? 'Processando...'
                          : 'Simular Loading',
                      isLoading: _isLoadingButton,
                      leadingIcon: Icons.sync,
                      onPressed: () {
                        setState(() => _isLoadingButton = true);
                      },
                    ),
                    if (_isLoadingButton)
                      DsButton(
                        label: 'Concluir',
                        variant: DsButtonVariant.ghost,
                        onPressed: () {
                          setState(() => _isLoadingButton = false);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            'DsTextField — Inputs e Segurança',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DsTextField(
                  label: 'Campo de texto padrão',
                  hintText: 'Digite para testar...',
                  helperText: 'Suporte a helperText e validação sem overflow.',
                  errorText: _showValidationError
                      ? 'Validação de erro ativa neste componente.'
                      : null,
                  prefixIcon: const Icon(Icons.text_fields),
                ),
                SizedBox(height: spacing.md),
                const DsTextField.password(
                  label: 'Campo sensível (DsTextField.password)',
                  hintText: 'Autocorreção e sugestões desativadas',
                  helperText:
                      'Protegido com obscureText, autocorrect: false e enableSuggestions: false.',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                SizedBox(height: spacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DsButton(
                    label: _showValidationError
                        ? 'Limpar Estado de Erro'
                        : 'Testar Estado de Erro',
                    variant: DsButtonVariant.outline,
                    size: DsButtonSize.sm,
                    onPressed: () {
                      setState(
                        () => _showValidationError = !_showValidationError,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatesAndLayoutCatalogSection extends StatefulWidget {
  const _StatesAndLayoutCatalogSection();

  @override
  State<_StatesAndLayoutCatalogSection> createState() =>
      _StatesAndLayoutCatalogSectionState();
}

class _StatesAndLayoutCatalogSectionState
    extends State<_StatesAndLayoutCatalogSection> {
  DsStateVariant _activeVariant = DsStateVariant.neutral;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dsSpacing;
    final typography = context.dsTypography;
    final windowSize = context.dsWindowSize;
    final screenWidth = MediaQuery.sizeOf(context).width;

    Widget statePreview;
    switch (_activeVariant) {
      case DsStateVariant.neutral:
        statePreview = DsStateView.empty(
          title: 'Pronto para integração',
          description:
              'Estado neutro sem dados fictícios. Redimensione a janela para testar breakpoints.',
          actionLabel: 'Simular Erro',
          onAction: () => setState(() => _activeVariant = DsStateVariant.error),
        );
      case DsStateVariant.loading:
        statePreview = const DsStateView.loading(
          title: 'Aguardando resposta...',
          description: 'Estado técnico de carregamento.',
        );
      case DsStateVariant.error:
        statePreview = DsStateView.error(
          title: 'Estado de falha técnica',
          description: 'Verificação visual do componente DsStateView.error.',
          actionLabel: 'Voltar ao Estado Pronto',
          onAction: () =>
              setState(() => _activeVariant = DsStateVariant.neutral),
        );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'DsBreakpoints & DsResponsiveScaffold',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Viewport atual: ${screenWidth.toInt()}px — Modo: ${windowSize.name.toUpperCase()}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.title,
                ),
                SizedBox(height: spacing.xs),
                Text(
                  '• compact (< 600px): Bottom NavigationBar\n'
                  '• medium (600px–1023px): NavigationRail lateral\n'
                  '• expanded (>= 1024px): Sidebar Desktop/Web expandida',
                  style: typography.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.xl),
          Text(
            'DsStateView — Estados Técnicos Reais',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.headline,
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.sm,
            children: [
              DsButton(
                label: 'Empty / Ready',
                size: DsButtonSize.sm,
                variant: _activeVariant == DsStateVariant.neutral
                    ? DsButtonVariant.primary
                    : DsButtonVariant.outline,
                onPressed: () =>
                    setState(() => _activeVariant = DsStateVariant.neutral),
              ),
              DsButton(
                label: 'Loading',
                size: DsButtonSize.sm,
                variant: _activeVariant == DsStateVariant.loading
                    ? DsButtonVariant.primary
                    : DsButtonVariant.outline,
                onPressed: () =>
                    setState(() => _activeVariant = DsStateVariant.loading),
              ),
              DsButton(
                label: 'Error',
                size: DsButtonSize.sm,
                variant: _activeVariant == DsStateVariant.error
                    ? DsButtonVariant.danger
                    : DsButtonVariant.outline,
                onPressed: () =>
                    setState(() => _activeVariant = DsStateVariant.error),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          DsCard(
            child: statePreview,
          ),
        ],
      ),
    );
  }
}
