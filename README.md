# Flutter Design System (`flutter_design_system`)

Pacote Flutter modular de **Design System e Frontend reutilizável**, projetado para ser compartilhado via **Git** entre múltiplos aplicativos (**Mobile, Web e Desktop**) com consistência visual, suporte nativo a **White-Label / Multi-Tema**, **personalização em Runtime pelo usuário final** e componentes blindados contra erros de layout (*Zero Overflow*).

---

## Principais Capacidades

- **Design Tokens Tipados (`ThemeExtension<T>`):** Cores semânticas (`DsColorTokens`), espaçamentos em grid de 4px (`DsSpacingTokens`), raios de borda (`DsRadiusTokens`) e escala tipográfica (`DsTypographyTokens`) integrados ao `ThemeData` do Flutter com suporte a interpolação animada (`lerp`).
- **Configuração Dupla (Via Código + Em Runtime pelo Usuário Final):**
  - **Via Código:** O desenvolvedor define a identidade visual ou overrides White-Label no `MaterialApp`.
  - **Em Runtime:** O próprio usuário do sistema pode alterar em tempo real o modo (`Claro` / `Escuro` / `Sistema`), a cor de destaque, o formato das bordas (`Reto`, `Suave`, `Padrão`, `Arredondado`) e a densidade de espaçamento (`Compacto`, `Padrão`, `Confortável`) usando `DsThemeController`, `DsThemeScope` e o painel pronto `DsThemeSettingsPanel`.
  - **Persistência Simples e Segura:** `DsRuntimeConfig` possui `toMap()` e `fromMap()` com validação segura para salvar as escolhas do usuário no `SharedPreferences`, banco local ou API.
- **Blindagem Anti-Overflow de Fábrica:** Todos os componentes aplicam constraints defensivas (`Flexible`, `Expanded`, `ConstrainedBox`, `SingleChildScrollView`, `TextOverflow.ellipsis`), validados com *Torture Tests* em viewports reduzidos e `TextScaler` em `2.0x`.
- **Segurança por Padrão:** Construtor dedicado `DsTextField.password` com `obscureText: true`, `enableSuggestions: false`, `autocorrect: false` e alternância de visibilidade acessível.
- **Layout Responsivo Automático (`DsResponsiveScaffold`):** Alterna automaticamente entre `NavigationBar` inferior no celular (`< 600px`), `NavigationRail` lateral no tablet (`600px–1023px`) e `Sidebar` expandida no Desktop/Web (`>= 1024px`).

---

## 1. Como Importar em Outros Projetos (Via Git)

No arquivo `pubspec.yaml` de qualquer outro projeto Flutter seu, adicione a dependência apontando para este repositório Git:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_design_system:
    git:
      url: https://github.com/RuyXingubit/flutter-design-system.git
      ref: main # Ou fixe uma tag de versão (ex: ref: v0.1.0) para estabilidade
```

Depois, execute no terminal do outro projeto:
```bash
flutter pub get
```

---

## 2. Como Configurar no Projeto Consumidor

Você pode configurar o Design System de **duas formas**: fixa via código ou dinâmica em runtime para o usuário final.

### Opção A: Configuração via Código (Fixa ou White-Label por Projeto)

Ideal quando o tema é definido apenas pelo código do aplicativo:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Projeto',
      // Tema padrão (ou passe colorsOverride / radiusOverride para White-Label):
      theme: DsTheme.light(
        colorsOverride: DsColorTokens.light().copyWith(
          primary: const Color(0xFF059669),
        ),
      ),
      darkTheme: DsTheme.dark(),
      home: const HomePage(),
    );
  }
}
```

### Opção B: Configuração em Runtime pelo Usuário do Sistema (Dinâmica + Persistente)

Ideal quando você quer permitir que o **usuário final do aplicativo** personalize cores, tema claro/escuro, arredondamento de cantos e densidade de tela em tempo de execução:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';

class MeuAppConfiguravel extends StatefulWidget {
  const MeuAppConfiguravel({super.key, this.savedUserMap});

  /// Mapa opcional carregado do SharedPreferences ou API com as escolhas salvas do usuário.
  final Map<String, Object?>? savedUserMap;

  @override
  State<MeuAppConfiguravel> createState() => _MeuAppConfiguravelState();
}

class _MeuAppConfiguravelState extends State<MeuAppConfiguravel> {
  late final DsThemeController _themeController = DsThemeController(
    initialConfig: widget.savedUserMap != null
        ? DsRuntimeConfig.fromMap(widget.savedUserMap!)
        : const DsRuntimeConfig(),
    onConfigChanged: (config) {
      // Chamado automaticamente sempre que o usuário altera uma opção!
      // Basta salvar config.toMap() no SharedPreferences ou backend:
      // prefs.setString('user_theme', jsonEncode(config.toMap()));
    },
  );

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsThemeScope(
      controller: _themeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) {
          return MaterialApp(
            themeMode: _themeController.themeMode,
            theme: _themeController.lightTheme,
            darkTheme: _themeController.darkTheme,
            home: const MinhaTelaDeConfiguracoes(),
          );
        },
      ),
    );
  }
}
```

#### Como exibir a tela de personalização para o usuário final:

O Design System já exporta o componente pronto **`DsThemeSettingsPanel`**, que você pode colocar em qualquer tela de "Configurações / Aparência" ou dentro de um Modal:

```dart
class MinhaTelaDeConfiguracoes extends StatelessWidget {
  const MinhaTelaDeConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.dsSpacing.lg),
        child: const DsThemeSettingsPanel(), // Painel completo pronto!
      ),
    );
  }
}
```

Ou, se quiser criar botões próprios na sua tela para mudar o tema em runtime, basta chamar o controller direto pelo `context`:
```dart
context.dsThemeController.setThemeMode(ThemeMode.dark);
context.dsThemeController.setPrimaryColor(const Color(0xFF7C3AED));
context.dsThemeController.setCornerStyle(DsCornerStyle.rounded);
context.dsThemeController.setDensity(DsVisualDensity.compact);
context.dsThemeController.resetToDefaults();
```

---

## 3. Componentes e Layouts Disponíveis

| Módulo | Descrição |
| :--- | :--- |
| `DsColorTokens`, `DsSpacingTokens`, `DsRadiusTokens`, `DsTypographyTokens` | Tokens semânticos acessíveis via `context.dsColors`, `context.dsSpacing`, `context.dsRadius`, `context.dsTypography`. |
| `DsButton` | Botão com variantes (`primary`, `secondary`, `outline`, `ghost`, `danger`), tamanhos (`sm`, `md`, `lg`), bloqueio em `isLoading` e anti-overflow. |
| `DsTextField` / `DsTextField.password` | Campo de texto padronizado com validação visual e modo de senha seguro. |
| `DsCard` | Superfície contida com borda, raio e padding semânticos. |
| `DsStateView` | Estados neutros reais (`empty`, `loading`, `error`). |
| `DsResponsiveScaffold` | Shell adaptativo automático (BottomBar no celular, NavigationRail no tablet e Sidebar no Desktop/Web). |
| `DsThemeSettingsPanel` | Painel interativo para o usuário final customizar o tema em runtime. |

> Especificação completa disponível em [docs/SDD.md](docs/SDD.md).

---

## 4. Catálogo Técnico Interativo (`example/`) e Testes

Para inspecionar todos os componentes e testar a aba **Runtime Config** ao vivo:

```bash
cd example
flutter run -d chrome
```

Para rodar a suíte completa de testes automatizados (unitários, segurança e *Torture Tests* anti-overflow):

```bash
flutter analyze
flutter test
cd example && flutter test
```

---

## Licença

Distribuído sob a licença MIT. Veja [LICENSE](LICENSE) para mais informações.
