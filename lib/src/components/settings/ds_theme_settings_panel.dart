import 'package:flutter/material.dart';
import '../../theme/ds_theme_controller.dart';
import '../../theme/ds_theme_extensions.dart';
import '../button/ds_button.dart';
import '../card/ds_card.dart';

/// A ready-to-use UI panel that allows end-users to customize the application's
/// appearance at runtime (`ThemeMode`, brand accent color, corner style, and
/// spacing density).
///
/// Reads and updates [DsThemeController] either from the [controller] parameter
/// or automatically from the nearest [DsThemeScope] via `context.dsThemeController`.
class DsThemeSettingsPanel extends StatelessWidget {
  const DsThemeSettingsPanel({
    super.key,
    this.controller,
    this.colorOptions = DsBrandColorOption.defaults,
    this.showResetButton = true,
  });

  final DsThemeController? controller;
  final List<DsBrandColorOption> colorOptions;
  final bool showResetButton;

  @override
  Widget build(BuildContext context) {
    final activeController = controller ?? context.dsThemeController;
    return ListenableBuilder(
      listenable: activeController,
      builder: (context, _) {
        final config = activeController.config;
        final colors = context.dsColors;
        final spacing = context.dsSpacing;
        final radius = context.dsRadius;
        final typography = context.dsTypography;

        return DsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modo de Tema',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.title,
              ),
              SizedBox(height: spacing.xs),
              Wrap(
                spacing: spacing.xs,
                runSpacing: spacing.xs,
                children: [
                  _buildChoiceButton(
                    label: 'Sistema',
                    icon: Icons.brightness_auto_outlined,
                    isSelected: config.themeMode == ThemeMode.system,
                    onTap: () => activeController.setThemeMode(ThemeMode.system),
                  ),
                  _buildChoiceButton(
                    label: 'Claro',
                    icon: Icons.light_mode_outlined,
                    isSelected: config.themeMode == ThemeMode.light,
                    onTap: () => activeController.setThemeMode(ThemeMode.light),
                  ),
                  _buildChoiceButton(
                    label: 'Escuro',
                    icon: Icons.dark_mode_outlined,
                    isSelected: config.themeMode == ThemeMode.dark,
                    onTap: () => activeController.setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
              SizedBox(height: spacing.lg),
              Text(
                'Cor de Destaque',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.title,
              ),
              SizedBox(height: spacing.xs),
              Wrap(
                spacing: spacing.xs,
                runSpacing: spacing.xs,
                children: [
                  for (final option in colorOptions)
                    _ColorOptionChip(
                      option: option,
                      isSelected:
                          (config.customPrimaryColor == null &&
                              option.id == 'blue') ||
                          config.customPrimaryColor?.toARGB32() ==
                              option.color.toARGB32(),
                      borderRadius: radius.borderRadiusMd,
                      borderColor: colors.border,
                      textStyle: typography.label,
                      spacing: spacing.xs,
                      onTap: () {
                        activeController.setPrimaryColor(
                          option.id == 'blue' ? null : option.color,
                        );
                      },
                    ),
                ],
              ),
              SizedBox(height: spacing.lg),
              Text(
                'Estilo de Bordas',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.title,
              ),
              SizedBox(height: spacing.xs),
              Wrap(
                spacing: spacing.xs,
                runSpacing: spacing.xs,
                children: [
                  for (final style in DsCornerStyle.values)
                    _buildChoiceButton(
                      label: _cornerLabel(style),
                      isSelected: config.cornerStyle == style,
                      onTap: () => activeController.setCornerStyle(style),
                    ),
                ],
              ),
              SizedBox(height: spacing.lg),
              Text(
                'Densidade de Espaçamento',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.title,
              ),
              SizedBox(height: spacing.xs),
              Wrap(
                spacing: spacing.xs,
                runSpacing: spacing.xs,
                children: [
                  for (final density in DsVisualDensity.values)
                    _buildChoiceButton(
                      label: _densityLabel(density),
                      isSelected: config.density == density,
                      onTap: () => activeController.setDensity(density),
                    ),
                ],
              ),
              if (showResetButton) ...[
                SizedBox(height: spacing.lg),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DsButton(
                    label: 'Restaurar Padrão',
                    variant: DsButtonVariant.ghost,
                    size: DsButtonSize.sm,
                    leadingIcon: Icons.restart_alt,
                    onPressed: activeController.resetToDefaults,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return DsButton(
      label: label,
      leadingIcon: icon,
      size: DsButtonSize.sm,
      variant: isSelected ? DsButtonVariant.primary : DsButtonVariant.outline,
      onPressed: onTap,
    );
  }

  String _cornerLabel(DsCornerStyle style) {
    switch (style) {
      case DsCornerStyle.sharp:
        return 'Reto';
      case DsCornerStyle.subtle:
        return 'Suave';
      case DsCornerStyle.standard:
        return 'Padrão';
      case DsCornerStyle.rounded:
        return 'Arredondado';
    }
  }

  String _densityLabel(DsVisualDensity density) {
    switch (density) {
      case DsVisualDensity.compact:
        return 'Compacto';
      case DsVisualDensity.standard:
        return 'Padrão';
      case DsVisualDensity.comfortable:
        return 'Confortável';
    }
  }
}

class _ColorOptionChip extends StatelessWidget {
  const _ColorOptionChip({
    required this.option,
    required this.isSelected,
    required this.borderRadius,
    required this.borderColor,
    required this.textStyle,
    required this.spacing,
    required this.onTap,
  });

  final DsBrandColorOption option;
  final bool isSelected;
  final BorderRadius borderRadius;
  final Color borderColor;
  final TextStyle textStyle;
  final double spacing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;

    return Semantics(
      button: true,
      selected: isSelected,
      label: option.label,
      child: Material(
        color: isSelected ? colors.primaryContainer : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
            color: isSelected ? option.color : borderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40.0),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing * 1.5,
                vertical: spacing,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: option.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Flexible(
                    child: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
