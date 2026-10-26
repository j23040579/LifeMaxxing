import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Typography scale for the LifeMaxxing design system.
//
// Font: Inter (via google_fonts)
// Scale: 12 / 14 / 16 / 20 / 28 / 36
// Weights: 400 regular · 500 medium · 600 semibold
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppTypography {
  // ── Named styles ─────────────────────────────────────────────────────────

  /// 36 / semibold / tight tracking – hero headlines
  static TextStyle get displayLarge => _inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.15,
      );

  /// 28 / semibold / tight tracking – section headers
  static TextStyle get displayMedium => _inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.2,
      );

  /// 20 / semibold – card titles, list headers
  static TextStyle get titleLarge => _inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// 16 / medium – secondary titles, nav labels
  static TextStyle get titleMedium => _inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.35,
      );

  /// 16 / regular – primary body copy
  static TextStyle get bodyLarge => _inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  /// 14 / regular – default body text
  static TextStyle get bodyMedium => _inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  /// 12 / regular – captions, fine print
  static TextStyle get bodySmall => _inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// 14 / semibold – buttons, emphasized labels
  static TextStyle get labelLarge => _inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// 12 / medium – tags, badges, metadata
  static TextStyle get labelMedium => _inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
      );

  // ── Tabular figures variant ──────────────────────────────────────────────

  /// Returns [style] with tabular (monospaced) figures enabled – useful for
  /// timers, counters, and any numeric alignment.
  static TextStyle tabular(TextStyle style) {
    return style.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  // ── TextTheme builder ────────────────────────────────────────────────────

  /// Produces a Material [TextTheme] mapped to our scale.
  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      // displaySmall intentionally left default
      headlineLarge: displayMedium,
      headlineMedium: titleLarge,
      headlineSmall: titleMedium,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: labelLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: bodySmall,
    );
  }

  // ── Private helper ───────────────────────────────────────────────────────

  static TextStyle _inter({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
