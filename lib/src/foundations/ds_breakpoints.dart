import 'package:flutter/widgets.dart';

/// Semantic window size categories for responsive layouts.
enum DsWindowSize {
  /// Mobile viewports (`width < 600px`).
  compact,

  /// Tablet viewports (`600px <= width < 1024px`).
  medium,

  /// Desktop / Web wide viewports (`width >= 1024px`).
  expanded,
}

/// Breakpoint definitions and responsive helpers for the Design System.
abstract final class DsBreakpoints {
  /// Maximum width (exclusive) for [DsWindowSize.compact].
  static const double compactMaxWidth = 600.0;

  /// Maximum width (exclusive) for [DsWindowSize.medium].
  static const double mediumMaxWidth = 1024.0;

  /// Resolves the [DsWindowSize] for a given viewport [width].
  static DsWindowSize fromWidth(double width) {
    if (width < compactMaxWidth) {
      return DsWindowSize.compact;
    }
    if (width < mediumMaxWidth) {
      return DsWindowSize.medium;
    }
    return DsWindowSize.expanded;
  }

  /// Resolves the current [DsWindowSize] from the [MediaQuery] width of [context].
  static DsWindowSize of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }
}
