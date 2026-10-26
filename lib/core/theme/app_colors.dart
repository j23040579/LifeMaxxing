import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Color tokens for the LifeMaxxing design system.
//
// Access via BuildContext extension:  context.colors.background
// ─────────────────────────────────────────────────────────────────────────────

/// Base color contract – every token the UI layer can reference.
abstract class AppColors {
  const AppColors();

  Color get background;
  Color get surface;
  Color get surfaceRaised;
  Color get border;
  Color get controlOutline;
  Color get text;
  Color get textMuted;
  Color get steel;
  Color get accentFill;
  Color get accentText;
  Color get onAccent;
  Color get warning;
  Color get warningIcon;
  Color get success;
  Color get error;
  Color get focusRing;

  Brightness get brightness;
}

// ── Dark palette ─────────────────────────────────────────────────────────────

class AppColorsDark extends AppColors {
  const AppColorsDark();

  @override
  Color get background => const Color(0xFF0E0E10);
  @override
  Color get surface => const Color(0xFF17171A);
  @override
  Color get surfaceRaised => const Color(0xFF1F1F23);
  @override
  Color get border => const Color(0xFF2E2E33);
  @override
  Color get controlOutline => const Color(0xFF6B6862);
  @override
  Color get text => const Color(0xFFF5F2EE);
  @override
  Color get textMuted => const Color(0xFFA09C97);
  @override
  Color get steel => const Color(0xFF8E96A3);
  @override
  Color get accentFill => const Color(0xFFC8102E);
  @override
  Color get accentText => const Color(0xFFF2566B);
  @override
  Color get onAccent => const Color(0xFFFFFFFF);
  @override
  Color get warning => const Color(0xFFE0A030);
  @override
  Color get warningIcon => const Color(0xFFE0A030);
  @override
  Color get success => const Color(0xFF5CCB95);
  @override
  Color get error => const Color(0xFFFF8A7A);
  @override
  Color get focusRing => const Color(0xFFF5F2EE);

  @override
  Brightness get brightness => Brightness.dark;
}

// ── Light palette ────────────────────────────────────────────────────────────

class AppColorsLight extends AppColors {
  const AppColorsLight();

  @override
  Color get background => const Color(0xFFF5F2EE);
  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get surfaceRaised => const Color(0xFFFFFFFF);
  @override
  Color get border => const Color(0xFFD9D4CC);
  @override
  Color get controlOutline => const Color(0xFF8C877F);
  @override
  Color get text => const Color(0xFF0E0E10);
  @override
  Color get textMuted => const Color(0xFF5E5A55);
  @override
  Color get steel => const Color(0xFF5C6470);
  @override
  Color get accentFill => const Color(0xFFC8102E);
  @override
  Color get accentText => const Color(0xFFC8102E);
  @override
  Color get onAccent => const Color(0xFFFFFFFF);
  @override
  Color get warning => const Color(0xFF8A5A00);
  @override
  Color get warningIcon => const Color(0xFFE0A030);
  @override
  Color get success => const Color(0xFF1F7A4D);
  @override
  Color get error => const Color(0xFFB3261E);
  @override
  Color get focusRing => const Color(0xFF0E0E10);

  @override
  Brightness get brightness => Brightness.light;
}

// ── InheritedWidget for propagating the palette down the tree ─────────────

class AppColorsProvider extends InheritedWidget {
  const AppColorsProvider({
    super.key,
    required this.colors,
    required super.child,
  });

  final AppColors colors;

  static AppColors of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppColorsProvider>();
    assert(provider != null, 'No AppColorsProvider found in context');
    return provider!.colors;
  }

  /// Non-listening lookup (useful in callbacks).
  static AppColors read(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<AppColorsProvider>();
    assert(provider != null, 'No AppColorsProvider found in context');
    return provider!.colors;
  }

  @override
  bool updateShouldNotify(AppColorsProvider oldWidget) =>
      colors.brightness != oldWidget.colors.brightness;
}

// ── BuildContext convenience extension ────────────────────────────────────

extension AppColorsX on BuildContext {
  /// Quick access: `context.colors.background`
  AppColors get colors => AppColorsProvider.of(this);
}
