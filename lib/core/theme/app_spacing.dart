import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spacing & radius tokens for the LifeMaxxing design system.
//
// Based on a 4-point grid system.
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppSpacing {
  // ── Spacing scale (4-point grid) ─────────────────────────────────────────

  /// 4 pt – hairline gaps, icon-to-label padding
  static const double xs = 4;

  /// 8 pt – tight spacing between related elements
  static const double sm = 8;

  /// 12 pt – standard inner padding
  static const double md = 12;

  /// 16 pt – card padding, default section gap
  static const double lg = 16;

  /// 24 pt – between groups, section separators
  static const double xl = 24;

  /// 32 pt – large section breaks
  static const double xxl = 32;

  /// 48 pt – hero spacing, top/bottom safe-area-like padding
  static const double xxxl = 48;

  // ── Corner radii ─────────────────────────────────────────────────────────
  // Use continuous (superellipse) corners via the smoothing factor in
  // the theme to get that iOS feel.

  /// 12 pt – controls, buttons, text fields
  static const double radiusSm = 12;
  static const double radiusControl = 12;

  /// 18 pt – cards, list groups
  static const double radiusMd = 18;
  static const double radiusCard = 18;

  /// 28 pt – bottom sheets, modals
  static const double radiusLg = 28;
  static const double radiusSheet = 28;

  /// 999 pt – pills, full-round elements
  static const double radiusFull = 999;

  // ── BorderRadius helpers ─────────────────────────────────────────────────

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));

  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));

  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));

  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(radiusFull));

  /// Top-only large radius – typically for bottom sheets.
  static const BorderRadius borderRadiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(radiusLg),
    topRight: Radius.circular(radiusLg),
  );

  // ── EdgeInsets helpers ───────────────────────────────────────────────────

  /// Uniform padding at each scale step.
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  /// Horizontal-only padding (common for screen-edge insets).
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: xl);

  /// Vertical-only padding.
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  /// iOS-style inset-grouped list padding (horizontal 16, vertical 12).
  static const EdgeInsets insetGrouped =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// Card inner padding.
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Standard screen padding (horizontal 16 + top 8).
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(lg, sm, lg, 0);
}
