import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Animation constants and spring helpers for the LifeMaxxing design system.
//
// Uses spring-based animations for that natural, iOS-like feel.
// All utilities respect the platform's reduced-motion preference.
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppAnimations {
  // ── Duration constants ───────────────────────────────────────────────────

  /// Micro interaction – icon morphs, checkbox ticks (100 ms)
  static const Duration micro = Duration(milliseconds: 100);

  /// Fast transition – opacity, color changes (200 ms)
  static const Duration fast = Duration(milliseconds: 200);

  /// Standard default – most transitions (300 ms)
  static const Duration standard = Duration(milliseconds: 300);

  /// Emphasized / spring-like feel (350 ms)
  static const Duration emphasized = Duration(milliseconds: 350);

  /// Slow / dramatic – page transitions, modals (450 ms)
  static const Duration slow = Duration(milliseconds: 450);

  // ── Curve presets ────────────────────────────────────────────────────────

  /// Standard ease-out for entering elements.
  static const Curve easeOut = Curves.easeOutCubic;

  /// Standard ease-in for exiting elements.
  static const Curve easeIn = Curves.easeInCubic;

  /// Smooth ease-in-out for symmetric transitions.
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Spring-style overshoot curve – gives that iOS bounce.
  static const Curve spring = _SpringCurve(300, 20, 1.2);

  /// Gentler spring for subtle movements.
  static const Curve springGentle = _SpringCurve(200, 22, 1.0);

  // ── Spring simulation helpers ────────────────────────────────────────────

  /// Default spring description matching ~300 ms settle time.
  ///
  /// mass: 1, stiffness: 300, damping: 20
  static SpringDescription get defaultSpringSpec =>
      const SpringDescription(mass: 1, stiffness: 300, damping: 20);

  /// A stiffer spring for quick, snappy interactions.
  static SpringDescription get stiffSpringSpec =>
      const SpringDescription(mass: 1, stiffness: 500, damping: 25);

  /// A loose spring for large, dramatic movements (sheets, page transitions).
  static SpringDescription get looseSpringSpec =>
      const SpringDescription(mass: 1, stiffness: 180, damping: 18);

  /// Creates a [SpringSimulation] from the default spring spec.
  ///
  /// [start] and [end] are the position bounds (typically 0..1).
  /// [velocity] is the initial velocity (px/s from a gesture, or 0).
  static SpringSimulation springSimulation({
    double start = 0,
    double end = 1,
    double velocity = 0,
    SpringDescription? spring,
  }) {
    return SpringSimulation(
      spring ?? defaultSpringSpec,
      start,
      end,
      velocity,
    );
  }

  // ── Reduced-motion helpers ───────────────────────────────────────────────

  /// Returns [Duration.zero] when the user has requested reduced motion,
  /// otherwise returns [duration].
  static Duration resolvedDuration(
    BuildContext context,
    Duration duration,
  ) {
    return MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
  }

  /// Returns a linear curve (no easing) when the user has requested reduced
  /// motion, otherwise returns [curve].
  static Curve resolvedCurve(BuildContext context, Curve curve) {
    return MediaQuery.disableAnimationsOf(context)
        ? Curves.linear
        : curve;
  }

  /// Whether the platform has requested reduced motion.
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }
}

// ── Custom spring-based curve ──────────────────────────────────────────────

/// A [Curve] backed by a critically/over-damped spring simulation that
/// settles within [0, 1].
class _SpringCurve extends Curve {
  const _SpringCurve(this.stiffness, this.damping, this.mass);

  final double stiffness;
  final double damping;
  final double mass;

  @override
  double transformInternal(double t) {
    final spring = SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    );
    final simulation = SpringSimulation(spring, 0, 1, 0);
    return simulation.x(t);
  }
}

// ── Interruptible animation helper ─────────────────────────────────────────

/// Mixin that provides an interruptible animation controller.
///
/// Call [animateTo] to drive the controller to a target value; if the
/// animation is already running it will be smoothly interrupted and
/// redirected.
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with SingleTickerProviderStateMixin, InterruptibleAnimationMixin {
///   @override
///   void initState() {
///     super.initState();
///     initAnimation(vsync: this);
///   }
/// }
/// ```
mixin InterruptibleAnimationMixin<T extends StatefulWidget> on State<T> {
  late AnimationController _controller;
  AnimationController get animationController => _controller;

  /// Initialise the controller. Call from [initState].
  void initAnimation({
    required TickerProvider vsync,
    Duration duration = AppAnimations.standard,
    double initialValue = 0,
  }) {
    _controller = AnimationController(
      vsync: vsync,
      duration: duration,
      value: initialValue,
    );
  }

  /// Animate towards [target] (0..1).
  ///
  /// If [respectReducedMotion] is true and the user prefers reduced motion
  /// the value jumps immediately.
  void animateTo(
    double target, {
    Duration? duration,
    Curve curve = AppAnimations.easeOut,
    bool respectReducedMotion = true,
  }) {
    if (respectReducedMotion && AppAnimations.prefersReducedMotion(context)) {
      _controller.value = target;
      return;
    }

    _controller.animateTo(
      target,
      duration: duration,
      curve: curve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
