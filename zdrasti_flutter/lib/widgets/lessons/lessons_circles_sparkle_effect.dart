import 'dart:math';
import 'package:flutter/material.dart';

class LessonSparkleEffect extends StatefulWidget {
  final bool enabled;

  const LessonSparkleEffect({super.key, required this.enabled});

  @override
  State<LessonSparkleEffect> createState() => _LessonSparkleEffectState();
}

class _LessonSparkleEffectState extends State<LessonSparkleEffect> with TickerProviderStateMixin {
  late List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();
    _sparkles = List.generate(4, (_) => _Sparkle(this));
    if (widget.enabled) _startAll();
  }

  void _startAll() {
    for (final sparkle in _sparkles) {
      sparkle.start();
    }
  }

  void _stopAll() {
    for (final sparkle in _sparkles) {
      sparkle.stop();
    }
  }

  @override
  void didUpdateWidget(covariant LessonSparkleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_sparkles.first.controller.isAnimating) {
      _startAll();
    } else if (!widget.enabled && _sparkles.first.controller.isAnimating) {
      _stopAll();
    }
  }

  @override
  void dispose() {
    for (final sparkle in _sparkles) {
      sparkle.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enabled
        ? SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              clipBehavior: Clip.none,
              children: _sparkles.map((s) => s.build()).toList(),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _Sparkle {
  final TickerProvider vsync;
  late final AnimationController controller;
  late final Animation<double> opacity;
  final Random random = Random();
  double x = 0;
  double y = 0;

  _Sparkle(this.vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );
    opacity = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _randomizePosition();
        controller.reverse(from: 1.0);
      }
    });
  }

  void start() {
    _randomizePosition();
    controller.forward(from: 0.0);
  }

  void stop() => controller.stop();
  void dispose() => controller.dispose();

  void _randomizePosition() {
    x = random.nextDouble() * 60 - 10; // ±30 px
    y = random.nextDouble() * 60 - 10;
  }

  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: SizedBox(
        width: 16,
        height: 16,
        child: FadeTransition(
          opacity: opacity,
          child: Icon(
            Icons.star,
            size: 12,
            color: Colors.amberAccent.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
