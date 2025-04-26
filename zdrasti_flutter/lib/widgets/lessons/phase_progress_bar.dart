import 'dart:math';
import 'package:flutter/material.dart';

class PhaseProgressBar extends StatelessWidget {
  final List<bool> phaseCompletion;
  final int activePhaseIndex;
  final List<AnimationController> pulseControllers;

  const PhaseProgressBar({
    super.key,
    required this.phaseCompletion,
    required this.activePhaseIndex,
    required this.pulseControllers,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: Row(
        children: List.generate(3, (index) {
          final isFilled = phaseCompletion[index];
          final isActive = index == activePhaseIndex;
          final controller = pulseControllers[index];

          return AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              double scale = 1.0;
              if (isFilled || isActive) {
                scale = 1.0 + sin(controller.value * pi) * 0.3;
              }

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 20,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isFilled ? Colors.green : Colors.transparent,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
