# Brainstorming: Flutter Design System Reutilizável (v3 - Consumo via Git & Configuração pelo Usuário em Runtime)

**Data:** 2026-10-14  
**Evolução da:** `v2_sdd_arquitetura_e_escopo.md`  
**Objetivo:** Formalizar na documentação o consumo oficial via Git (`https://github.com/RuyXingubit/flutter-design-system.git`) e expandir a arquitetura do Design System para permitir que o **usuário final do sistema** personalize a aparência em **runtime** (além da configuração estática via código).

---

## 1. Consumo Oficial via Git na Documentação (`SDD.md` e `README.md`)

Qualquer projeto consumidor importa o Design System diretamente pelo repositório Git público:
```yaml
dependencies:
  flutter_design_system:
    git:
      url: https://github.com/RuyXingubit/flutter-design-system.git
      ref: main # Ou tag específica (ex: v0.1.0)
```

---

## 2. Arquitetura de Configuração em Runtime pelo Usuário Final

Além de o desenvolvedor poder configurar o tema via código (`DsTheme.light(...)`), o usuário final do aplicativo precisa poder ajustar suas preferências visuais em tempo de execução (ex: tela de "Preferências de Aparência" dentro do sistema).

### 2.1. Peças Arquiteturais Adicionadas ao Design System

1. **`DsRuntimeConfig` (Modelo Imutável e Serializável):**
   - Guarda as escolhas do usuário:
     - `ThemeMode themeMode` (`light`, `dark`, `system`)
     - `Color? primaryColor` (cor de destaque escolhida pelo usuário)
     - `DsCornerStyle cornerStyle` (`sharp`, `subtle`, `standard`, `rounded`)
     - `DsVisualDensity density` (`compact`, `standard`, `comfortable`)
   - Possui serialização segura (`toMap()` / `fromMap()`) com validação de valores para que o projeto consumidor possa salvar as escolhas do usuário em banco local (`SharedPreferences` / SQLite) ou na API do perfil do usuário.

2. **`DsThemeController` (`ChangeNotifier`) & `DsThemeScope` (`InheritedNotifier`):**
   - Gerencia o estado reativo do tema em runtime.
   - Gera automaticamente `lightTheme` e `darkTheme` a partir das escolhas do usuário.
   - Acessível em qualquer lugar via `context.dsThemeController`.

3. **`DsThemeSettingsPanel` (Componente de UI Reutilizável para o Usuário Final):**
   - Widget pronto que qualquer projeto consumidor pode embutir na sua tela de Configurações ou em um Modal/BottomSheet.
   - Permite ao usuário final clicar e alterar em tempo real:
     - Tema (`Claro`, `Escuro`, `Sistema`);
     - Cor principal do sistema (paleta de cores acessíveis);
     - Formato dos cantos (`Reto`, `Suave`, `Padrão`, `Arredondado`);
     - Densidade de espaçamento (`Compacto`, `Padrão`, `Confortável`);
     - Botão de restaurar padrões.
