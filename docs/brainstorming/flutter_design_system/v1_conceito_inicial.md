# Brainstorming: Flutter Design System Reutilizável (v1 - Conceito Inicial)

**Data:** 2026-10-14  
**Objetivo:** Explorar as capacidades do Flutter para construir um Design System / Frontend modular que possa ser reaproveitado em múltiplos projetos (Web, Mobile, Desktop).

---

## 1. Visão Geral: Por que o Flutter é excelente para Design Systems?

Diferente da Web tradicional (onde CSS pode vazar escopo ou depender de dezenas de bibliotecas externas), o Flutter desenha cada pixel no próprio canvas (Impeller/Skia) e possui composição estritamente tipada. Isso permite criar um **pacote único (`package`)** que entrega:
- **Design Tokens tipados** (zero "magic numbers" soltos pelo código).
- **Componentes blindados contra erros de layout** (constraints defensivas contra overflow embutidas no próprio componente do Design System).
- **Suporte nativo a Multi-Tema / White-Label** (Light, Dark ou temas customizados por projeto consumidor usando `ThemeExtension`).
- **Templates de Tela Completos** (Shell de navegação responsiva Mobile/Web/Desktop, formulários padronizados, estados vazios/carregamento).

---

## 2. Pilares Arquiteturais no Flutter

### 2.1. Camada 1: Design Tokens & Foundations (`ThemeExtension`)
O recurso mais poderoso do Flutter moderno para Design Systems é o `ThemeExtension<T>`:
- Permite estender o `ThemeData` nativo com classes próprias (ex: `DsColors`, `DsSpacing`, `DsRadius`, `DsTypography`).
- Suporta interpolação nativa (`lerp`), fazendo com que a troca entre Light Mode, Dark Mode ou o tema de outro projeto ocorra com animação suave.
- Acesso ergonômico via extension no `BuildContext` (ex: `context.dsColors.primary`, `context.dsSpacing.md`).

### 2.2. Camada 2: Componentes Atômicos e Moleculares (Blindados contra Overflow)
Em vez de usar `ElevatedButton` ou `TextField` crus em cada projeto, o Design System expõe componentes próprios (ex: `DsButton`, `DsTextField`, `DsCard`, `DsBadge`, `DsModal`):
- **Prevenção de Overflow de Fábrica:** Todo componente já nasce com `Flexible`/`Expanded`, `TextOverflow.ellipsis`, e suporte a escalonamento de fonte de acessibilidade (`TextScaler`).
- **Acessibilidade (a11y) e Semântica:** `Semantics`, áreas mínimas de toque (48x48) e navegação por teclado/foco já resolvidos na base.
- **API Estrita:** Ao limitar as propriedades expostas, garante-se consistência visual em todos os projetos.

### 2.3. Camada 3: Organisms & Page Templates ("Frontend Pronto")
Além de botões e inputs, o pacote pode exportar **estruturas de tela completas** parametrizadas:
- **`DsResponsiveShell`**: Layout adaptativo que vira `BottomNavigationBar` no celular, `NavigationRail` no tablet e `Sidebar` completa na Web/Desktop.
- **`DsPageScaffold`**: Estrutura padrão de página com cabeçalho, breadcrumbs, área de ações e tratamento nativo de estados (`loading`, `empty`, `error`, `content`).
- **`DsAuthLayout` / `DsFormLayout`**: Estruturas prontas onde o projeto consumidor só injeta os callbacks e textos.

---

## 3. Estratégias para Reutilizar em Outros Projetos

| Estratégia | Como funciona | Prós | Contras |
| :--- | :--- | :--- | :--- |
| **1. Git Package (Recomendado para projetos separados)** | O Design System fica em um repositório Git próprio. Outros projetos importam no `pubspec.yaml` via URL do Git + tag/branch (`ref: v1.0.0`). | Versionamento imutável por projeto; funciona entre repositórios diferentes sem custo. | Precisa fazer commit/tag para atualizar nos projetos consumidores (ou usar `dependency_overrides` com `path:` durante o desenvolvimento local). |
| **2. Local Path / Pub Workspaces (Monorepo)** | Múltiplos projetos e o pacote do Design System compartilham um workspace Dart (`pubspec.yaml` com `workspace:`). | Alterações refletem instantaneamente em todos os projetos locais. | Exige que os projetos estejam na mesma estrutura de pastas ou monorepo. |
| **3. Abordagem Híbrida (Git + Path local)** | O Design System é um pacote Git independente com um app `showcase/` (catálogo visual) dentro dele. | Permite desenvolver e testar todos os componentes no `showcase/` local e consumir via Git com versionamento seguro em qualquer outro projeto. | — |

---

## 4. Catálogo Interativo (Showcase / Widgetbook) e Testes

Para desenvolver e validar o Design System sem depender de um projeto final:
1. **App de Catálogo (`example/` ou `widgetbook`)**: Uma aplicação Flutter dentro do próprio repositório que lista todos os tokens, componentes e templates, permitindo testar:
   - Alternância Light / Dark Mode em tempo real;
   - Simulação de telas Mobile, Tablet e Desktop (teste de responsividade e zero overflow);
   - Simulação de aumento de fonte do sistema (`TextScaler`).
2. **Testes Automatizados (`flutter_test`)**: Testes de widget garantindo que cada componente renderiza sem overflow mesmo em telas pequenas (ex: 320px) ou com textos longos.

---

## 5. Decisões em Aberto para Alinhamento
1. **Nível de abstração desejado:** Queremos focar apenas em **Tokens + Componentes Base** (botões, inputs, cards) ou ir até **Templates de Tela / Layouts Responsivos** (shells de dashboard, telas base)?
2. **Base visual:** Construir em cima do **Material 3 customizado** (aproveitando toda a infraestrutura de acessibilidade e navegação do Flutter com cara própria) ou um estilo **100% do zero (`WidgetsApp` / custom)**?
3. **Forma de consumo nos outros projetos:** Repositório Git independente (consumido via `git:` no `pubspec.yaml`) + App Showcase integrado?
