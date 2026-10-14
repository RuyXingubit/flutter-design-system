import 'package:flutter/material.dart';
import '../../theme/ds_theme_extensions.dart';
import '../button/ds_button.dart';

/// Semantic state categories for [DsStateView].
enum DsStateVariant {
  neutral,
  loading,
  error,
}

/// A clean, neutral component for representing loading, empty, or error states
/// without relying on placeholder or fake business data.
///
/// Built with defensive constraints ([SingleChildScrollView], [ConstrainedBox],
/// and [TextOverflow.ellipsis]) to prevent vertical or horizontal overflow on
/// any screen size or text scale factor.
class DsStateView extends StatelessWidget {
  const DsStateView({
    required this.title,
    super.key,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.isLoading = false,
    this.variant = DsStateVariant.neutral,
  });

  /// Creates a clean empty/ready state view.
  const DsStateView.empty({
    required this.title,
    super.key,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  })  : isLoading = false,
        variant = DsStateVariant.neutral;

  /// Creates a clean loading state view.
  const DsStateView.loading({
    super.key,
    this.title = 'Carregando...',
    this.description,
  })  : icon = null,
        actionLabel = null,
        onAction = null,
        isLoading = true,
        variant = DsStateVariant.loading;

  /// Creates a clean error state view with optional retry action.
  const DsStateView.error({
    required this.title,
    super.key,
    this.description,
    this.icon = Icons.error_outline,
    this.actionLabel,
    this.onAction,
  })  : isLoading = false,
        variant = DsStateVariant.error;

  final String title;
  final String? description;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isLoading;
  final DsStateVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.dsColors;
    final spacing = context.dsSpacing;
    final typography = context.dsTypography;

    final isError = variant == DsStateVariant.error;
    final accentColor = isError ? colors.error : colors.primary;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 36.0,
                  height: 36.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
                SizedBox(height: spacing.md),
              ] else if (icon != null) ...[
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: isError
                        ? colors.error.withValues(alpha: 0.12)
                        : colors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 28.0,
                    color: isError ? colors.error : colors.textSecondary,
                  ),
                ),
                SizedBox(height: spacing.md),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: typography.title.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (description != null && description!.trim().isNotEmpty) ...[
                SizedBox(height: spacing.xs),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: typography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
              if (!isLoading && actionLabel != null && onAction != null) ...[
                SizedBox(height: spacing.lg),
                DsButton(
                  label: actionLabel!,
                  variant: isError
                      ? DsButtonVariant.danger
                      : DsButtonVariant.primary,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
