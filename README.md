# Flutter Design System (`flutter_design_system`)

Pacote Flutter modular de **Design System e Frontend reutilizável**, projetado para ser compartilhado entre múltiplos aplicativos (**Mobile, Web e Desktop**) com consistência visual, suporte nativo a **White-Label / Multi-Tema** e componentes blindados contra erros de layout (*Zero Overflow*).

---

## Principais Capacidades

- **Design Tokens Tipados (`ThemeExtension<T>`):** Cores semânticas (`DsColorTokens`), espaçamentos em grid de 4px (`DsSpacingTokens`), raios de borda (`DsRadiusTokens`) e escala tipográfica (`DsTypographyTokens`) integrados nativamente ao `ThemeData` do Flutter com suporte a interpolação animada (`lerp`).
- **Multi-Brand / White-Label Nativo:** Qualquer projeto consumidor pode sobrescrever cores ou tokens específicos via `copyWith` sem alterar o código dos componentes.
- **Blindagem Anti-Overflow de Fábrica:** Todos os componentes aplicam constraints defensivas (`Flexible`, `Expanded`, `ConstrainedBox`, `SingleChildScrollView`, `TextOverflow.ellipsis`), validados com *Torture Tests* em viewports reduzidos e `TextScaler` em `2.0x`.
- **Segurança por Padrão:** Construtor dedicado `DsTextField.password` com `obscureText: true`, `enableSuggestions: false`, `autocorrect: false` e alternância de visibilidade acessível.
- **Layout Responsivo Automático (`DsResponsiveScaffold`):** Alterna automaticamente entre `NavigationBar` inferior no celular (`< 600px`), `NavigationRail` lateral no tablet (`600px–1023px`) e `Sidebar` expandida no Desktop/Web (`>= 1024px`).

---

## Arquitetura em Camadas

| Camada | Módulos | Responsabilidade |
| :--- | :--- | :--- |
| **1. Foundations & Tokens** | `DsColorTokens`, `DsSpacingTokens`, `DsRadiusTokens`, `DsTypographyTokens`, `DsBreakpoints`, `DsTheme` | Valores semânticos, temas Light/Dark/Custom e classificação de viewport (`compact`, `medium`, `expanded`). |
| **2. Componentes Base** | `DsButton`, `DsTextField`, `DsCard` | Átomos e moléculas interativos com acessibilidade, segurança de input e proteção contra overflow. |
| **3. Layouts & Estados** | `DsResponsiveScaffold`, `DsStateView` | Shell de navegação adaptativa multi-plataforma e estados técnicos neutros (`empty`, `loading`, `error`). |

> Para detalhes completos de engenharia e contratos de componentes, consulte o [Software Design Document (docs/SDD.md)](docs/SDD.md).

---

## Como Usar em Outros Projetos

### 1. Adicione no `pubspec.yaml` do projeto consumidor

Via Git (recomendado para projetos em repositórios separados):

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_design_system:
    git:
      url: https://github.com/RuyXingubit/flutter-design-system.git
      ref: main # Ou uma tag de versão, ex: v0.1.0
```

Ou via caminho local (durante desenvolvimento simultâneo):

```yaml
dependencies:
  flutter_design_system:
    path: ../flutter-design-system
```

### 2. Configure o `MaterialApp` com `DsTheme`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Projeto',
      theme: DsTheme.light(),
      darkTheme: DsTheme.dark(),
      home: const HomePage(),
    );
  }
}
```

### 3. Customização White-Label (Opcional)

Para aplicar a identidade visual de outro projeto mantendo todos os componentes:

```dart
theme: DsTheme.light(
  colorsOverride: DsColorTokens.light().copyWith(
    primary: const Color(0xFF059669),
    primaryContainer: const Color(0xFFD1FAE5),
  ),
),
```

---

## Exemplos Rápidos de Componentes

```dart
// Acesso direto aos tokens via BuildContext
final spacing = context.dsSpacing;
final colors = context.dsColors;

// Botão com proteção anti-overflow e bloqueio automático em loading
DsButton(
  label: 'Salvar Alterações',
  variant: DsButtonVariant.primary,
  isLoading: isSaving,
  leadingIcon: Icons.check,
  onPressed: () {},
);

// Input de senha seguro (sem sugestões/autocorreção + toggle de visibilidade)
const DsTextField.password(
  label: 'Senha de acesso',
  hintText: 'Digite sua senha',
);

// Shell responsivo automático (Mobile BottomBar / Tablet Rail / Desktop Sidebar)
DsResponsiveScaffold(
  title: 'Painel',
  selectedIndex: currentIndex,
  onDestinationSelected: (index) => setState(() => currentIndex = index),
  destinations: const [
    DsNavigationItem(label: 'Início', icon: Icons.home_outlined),
    DsNavigationItem(label: 'Configurações', icon: Icons.settings_outlined),
  ],
  body: const DsStateView.empty(
    title: 'Pronto para integração',
    description: 'Conecte seu módulo a este template.',
  ),
);
```

---

## Catálogo Técnico Interativo (`example/`)

O repositório inclui uma aplicação de catálogo em `example/` para inspecionar tokens, testar variantes de componentes, alternar Light/Dark mode, simular overrides White-Label e validar breakpoints responsivos em tempo real:

```bash
cd example
flutter run -d chrome
# ou: flutter run -d macos
```

---

## Testes e Qualidade

Todos os tokens, componentes e layouts possuem cobertura de testes unitários, funcionais e *Torture Tests* anti-overflow (`TextScaler.linear(2.0)` em viewports estreitos):

```bash
# Executar análise estática e testes do pacote principal
flutter analyze
flutter test

# Executar testes do catálogo interativo
cd example && flutter test
```

---

## Licença

Distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais informações.
