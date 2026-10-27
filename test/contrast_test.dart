import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';

/// Calculates the relative luminance of a color per WCAG 2.1 specs.
double _relativeLuminance(Color color) {
  double getComponentLuminance(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    }
    return math.pow((component + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = getComponentLuminance(color.r);
  final g = getComponentLuminance(color.g);
  final b = getComponentLuminance(color.b);

  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Calculates the contrast ratio between two colors (1:1 to 21:1).
double _contrastRatio(Color c1, Color c2) {
  final l1 = _relativeLuminance(c1);
  final l2 = _relativeLuminance(c2);
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('WCAG Contrast Tests - Dark Theme', () {
    const dark = AppColorsDark();

    test('Body text on background meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(dark.text, dark.background);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason:
              'Text on dark background ratio is ${ratio.toStringAsFixed(2)}:1');
    });

    test('Body text on surface meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(dark.text, dark.surface);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason:
              'Text on dark surface ratio is ${ratio.toStringAsFixed(2)}:1');
    });

    test(
        'Control outline on background meets WCAG AA for UI controls (>= 3.0:1)',
        () {
      final ratio = _contrastRatio(dark.controlOutline, dark.background);
      expect(ratio, greaterThanOrEqualTo(3.0),
          reason:
              'Control outline on background ratio is ${ratio.toStringAsFixed(2)}:1');
    });

    test('White text on accent fill meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(dark.onAccent, dark.accentFill);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason:
              'onAccent on accentFill ratio is ${ratio.toStringAsFixed(2)}:1');
    });
  });

  group('WCAG Contrast Tests - Light Theme', () {
    const light = AppColorsLight();

    test('Body text on background meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(light.text, light.background);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason:
              'Text on light background ratio is ${ratio.toStringAsFixed(2)}:1');
    });

    test('Body text on surface meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(light.text, light.surface);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason:
              'Text on light surface ratio is ${ratio.toStringAsFixed(2)}:1');
    });

    test('White text on accent fill meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(light.onAccent, light.accentFill);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason:
              'onAccent on accentFill ratio is ${ratio.toStringAsFixed(2)}:1');
    });
  });
}
