import 'package:flutter/material.dart';
import '../foundations/ds_breakpoints.dart';
import '../theme/ds_theme_extensions.dart';

/// Navigation item model used by [DsResponsiveScaffold] across Mobile, Tablet,
/// and Desktop/Web layouts.
@immutable
class DsNavigationItem {
  const DsNavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.tooltip,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String? tooltip;
}

/// An adaptive application shell that automatically switches navigation patterns
/// based on the viewport width ([DsBreakpoints]):
///
/// - **Compact (`< 600px`)**: Bottom [NavigationBar]
/// - **Medium (`600px–1023px`)**: Compact lateral [NavigationRail]
/// - **Expanded (`>= 1024px`)**: Full lateral Desktop/Web Sidebar
///
/// Preserves the [body] subtree across layout transitions and enforces
/// defensive anti-overflow constraints on all navigation labels and headers.
class DsResponsiveScaffold extends StatelessWidget {
  const DsResponsiveScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.destinations = const <DsNavigationItem>[],
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.sidebarHeader,
    this.sidebarFooter,
    this.floatingActionButton,
    this.sidebarWidth = 260.0,
  }) : assert(
          selectedIndex >= 0,
          'selectedIndex must be non-negative.',
        );

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final List<DsNavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final Widget? floatingActionButton;
  final double sidebarWidth;

  bool get _hasNavigation => destinations.length >= 2;
  bool get _hasAppBar =>
      title != null || (actions != null && actions!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final typography = context.dsTypography;

    return LayoutBuilder(
      builder: (context, constraints) {
        final windowSize = DsBreakpoints.fromWidth(constraints.maxWidth);

        final PreferredSizeWidget? appBar = _hasAppBar
            ? AppBar(
                backgroundColor: colors.surface,
                foregroundColor: colors.textPrimary,
                elevation: 0,
                scrolledUnderElevation: 0,
                shape: Border(
                  bottom: BorderSide(color: colors.divider),
                ),
                title: title != null
                    ? Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.title,
                      )
                    : null,
                actions: actions,
              )
            : null;

        if (!_hasNavigation) {
          return Scaffold(
            backgroundColor: colors.background,
            appBar: appBar,
            body: SafeArea(child: body),
            floatingActionButton: floatingActionButton,
          );
        }

        switch (windowSize) {
          case DsWindowSize.compact:
            return Scaffold(
              backgroundColor: colors.background,
              appBar: appBar,
              body: SafeArea(child: body),
              floatingActionButton: floatingActionButton,
              bottomNavigationBar: NavigationBar(
                key: const ValueKey<String>('ds_compact_navigation_bar'),
                backgroundColor: colors.surface,
                indicatorColor: colors.primaryContainer,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                destinations: [
                  for (final item in destinations)
                    NavigationDestination(
                      icon: Icon(item.icon, color: colors.textSecondary),
                      selectedIcon: Icon(
                        item.selectedIcon ?? item.icon,
                        color: colors.primary,
                      ),
                      label: item.label,
                      tooltip: item.tooltip ?? item.label,
                    ),
                ],
              ),
            );

          case DsWindowSize.medium:
            return Scaffold(
              backgroundColor: colors.background,
              appBar: appBar,
              floatingActionButton: floatingActionButton,
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NavigationRail(
                    key: const ValueKey<String>('ds_medium_navigation_rail'),
                    backgroundColor: colors.surface,
                    indicatorColor: colors.primaryContainer,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    labelType: NavigationRailLabelType.all,
                    leading: sidebarHeader,
                    trailing: sidebarFooter != null
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: sidebarFooter,
                            ),
                          )
                        : null,
                    destinations: [
                      for (final item in destinations)
                        NavigationRailDestination(
                          icon: Icon(item.icon, color: colors.textSecondary),
                          selectedIcon: Icon(
                            item.selectedIcon ?? item.icon,
                            color: colors.primary,
                          ),
                          label: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 72.0),
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: typography.bodySmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                  VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    color: colors.divider,
                  ),
                  Expanded(
                    child: SafeArea(child: body),
                  ),
                ],
              ),
            );

          case DsWindowSize.expanded:
            return Scaffold(
              backgroundColor: colors.background,
              appBar: appBar,
              floatingActionButton: floatingActionButton,
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DsDesktopSidebar(
                    key: const ValueKey<String>('ds_expanded_sidebar'),
                    width: sidebarWidth,
                    destinations: destinations,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    header: sidebarHeader,
                    footer: sidebarFooter,
                  ),
                  VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    color: colors.divider,
                  ),
                  Expanded(
                    child: SafeArea(child: body),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

class _DsDesktopSidebar extends StatelessWidget {
  const _DsDesktopSidebar({
    required this.width,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.header,
    this.footer,
    super.key,
  });

  final double width;
  final List<DsNavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final spacing = context.dsSpacing;
    final radius = context.dsRadius;
    final typography = context.dsTypography;

    return SizedBox(
      width: width,
      child: Material(
        color: colors.surface,
        child: SafeArea(
          right: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) ...[
                Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: header,
                ),
                Divider(height: 1.0, color: colors.divider),
              ],
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(spacing.sm),
                  itemCount: destinations.length,
                  separatorBuilder: (_, _) => SizedBox(height: spacing.xxs),
                  itemBuilder: (context, index) {
                    final item = destinations[index];
                    final isSelected = index == selectedIndex;
                    final fgColor =
                        isSelected ? colors.primary : colors.textSecondary;

                    return Semantics(
                      button: true,
                      selected: isSelected,
                      label: item.tooltip ?? item.label,
                      child: Material(
                        color: isSelected
                            ? colors.primaryContainer
                            : Colors.transparent,
                        borderRadius: radius.borderRadiusMd,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: onDestinationSelected != null
                              ? () => onDestinationSelected!(index)
                              : null,
                          borderRadius: radius.borderRadiusMd,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 48.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.md,
                                vertical: spacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? (item.selectedIcon ?? item.icon)
                                        : item.icon,
                                    size: 20.0,
                                    color: fgColor,
                                  ),
                                  SizedBox(width: spacing.sm),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: typography.label.copyWith(
                                        color: isSelected
                                            ? colors.primary
                                            : colors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (footer != null) ...[
                Divider(height: 1.0, color: colors.divider),
                Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: footer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
