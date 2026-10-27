import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData dark() => _build(const AppColorsDark());
  static ThemeData light() => _build(const AppColorsLight());

  static ThemeData _build(AppColors c) {
    final isDark = c.brightness == Brightness.dark;
    final textTheme = AppTypography.textTheme().apply(
      bodyColor: c.text,
      displayColor: c.text,
    );

    return ThemeData(
      brightness: c.brightness,
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: c.brightness,
        primary: c.accentFill,
        onPrimary: c.onAccent,
        primaryContainer: c.accentFill.withAlpha(30),
        onPrimaryContainer: c.accentText,
        secondary: c.steel,
        onSecondary: c.onAccent,
        secondaryContainer: c.surfaceRaised,
        onSecondaryContainer: c.text,
        tertiary: c.steel,
        onTertiary: c.onAccent,
        error: c.error,
        onError: c.onAccent,
        surface: c.surface,
        onSurface: c.text,
        onSurfaceVariant: c.textMuted,
        outline: c.controlOutline,
        outlineVariant: c.border,
        shadow: Colors.black,
        scrim: Colors.black,
      ),
      scaffoldBackgroundColor: c.background,
      canvasColor: c.surface,
      cardColor: c.surface,
      dividerColor: c.border,
      splashColor: c.accentFill.withAlpha(18),
      highlightColor: c.accentFill.withAlpha(12),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(color: c.text),
        iconTheme: IconThemeData(color: c.text, size: 24),
        actionsIconTheme: IconThemeData(color: c.steel, size: 24),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        surfaceTintColor: Colors.transparent,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
