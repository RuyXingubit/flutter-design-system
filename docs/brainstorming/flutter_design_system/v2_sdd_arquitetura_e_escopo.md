# Brainstorming: Flutter Design System Reutilizável (v2 - SDD & Escopo Inicial)

**Data:** 2026-10-14  
**Evolução da:** `v1_conceito_inicial.md`  
**Objetivo:** Definir a documentação SDD (Software Design Document) formalizando a arquitetura, contratos de componentes, regras defensivas contra overflow, estratégia de testes e o faseamento do Escopo Inicial.

---

## 1. Decisões Estruturais Consolidadas na v2

1. **Base Visual sobre Material 3 Customizado (`ThemeExtension`)**:
   - Aproveita a infraestrutura nativa de acessibilidade, foco de teclado, navegação e renderização do Flutter, mas isola toda a identidade visual em `ThemeExtension<T>` próprias (`DsColors`, `DsSpacing`, `DsRadius`, `DsTypography`).
2. **Estrutura de Pacote Reutilizável + App Showcase (`example/`)**:
   - A raiz do projeto é o próprio pacote reutilizável (`flutter_design_system`), pronto para ser importado por outros projetos via `git:` ou `path:`.
   - A pasta `example/` contém o **Catálogo Técnico Interativo (Showcase)** para inspecionar tokens, alternar Light/Dark mode e validar responsividade sem usar dados de negócio fictícios.
3. **Torture Tests de Overflow por Componente**:
   - Todo componente criado deve passar por um teste automatizado que o renderiza em uma tela estreita (`320px`), com texto longo e `TextScaler.linear(2.0)`, garantindo zero erros de `RenderFlex overflowed`.

---

## 2. Definição do Escopo Inicial (Faseado Sob Demanda)

Para seguir o fluxo estrito (*Pedir -> Executar o mínimo necessário -> Testar -> Aprovar -> Avançar*), o Escopo Inicial foi dividido em 4 entregas enxutas e testáveis:

- **Etapa 1 — Fundação do Pacote & Design Tokens (`ThemeExtension`)**:
  - Criação da estrutura do package Flutter, tokens de cores (Light/Dark), espaçamentos, raios de borda, tipografia e extensões de `BuildContext` + testes unitários de tema e interpolação (`lerp`).
- **Etapa 2 — Componentes Atômicos Blindados (`DsButton`, `DsTextField`, `DsCard`)**:
  - Implementação dos 3 componentes base com constraints defensivas contra overflow, acessibilidade e estados (`loading`, `disabled`, `error`) + testes de widget e torture tests de overflow.
- **Etapa 3 — Layout Responsivo & Estados Neutros (`DsResponsiveScaffold`, `DsStateView`)**:
  - Shell adaptativo (Mobile/Tablet/Desktop) e componente neutro para estados de carregamento/vazio/erro + testes de mudança de breakpoint.
- **Etapa 4 — Catálogo Técnico Interativo (`example/`)**:
  - Aplicação enxuta de inspeção visual dos tokens, componentes e breakpoints em tempo real.
