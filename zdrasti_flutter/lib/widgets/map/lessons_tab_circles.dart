import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/loader/lesson_loader.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/lesson_node.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/backend/service/audio/audio_service.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_session_screen.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_vocab_screen.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_alphabet_screen.dart';
import 'package:zdrasti_flutter/widgets/map/lessons_circles_sparkle_effect.dart';
import 'lessons_tab_utils.dart';

class LessonCircleButton extends StatefulWidget {
  final LessonNode node;
  final Lesson lesson;
  final bool isGlowing;
  final Animation<double> glowAnimation;
  final User user;

  const LessonCircleButton({
    super.key,
    required this.node,
    required this.lesson,
    required this.isGlowing,
    required this.glowAnimation,
    required this.user,
  });

  @override
  State<LessonCircleButton> createState() => _LessonCircleButtonState();
}

class _LessonCircleButtonState extends State<LessonCircleButton> {
  final ValueNotifier<double> _tapScale = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100 + widget.node.lessonId.hashCode % 100), () {
      _tapScale.value = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.node.status == LessonStatus.locked
          ? null
          : () async {
              _tapScale.value = 1.2;
              await AudioService.playSound('sounds/tap_click.ogg');
              await Future.delayed(const Duration(milliseconds: 100));
              _tapScale.value = 1.0;

              LocalizationService.setLanguage(widget.user.native_language);

              if (widget.lesson.lessonId == 'a1_00') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonAlphabetScreen(
                      lesson: widget.lesson,
                      user: widget.user
                    ),
                  ),
                );
              } else {
                final sections = LessonLoader.buildLessonSections(widget.lesson);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonSessionScreen(
                      lessonId: widget.lesson.lessonId,
                      sections: sections,
                      lesson: widget.lesson,
                      user: widget.user,
                    ),
                  ),
                );
              }
            },
      child: ValueListenableBuilder<double>(
        valueListenable: _tapScale,
        builder: (context, tapScale, _) {
          final baseColor = getColorForStatus(widget.node.status);

          return AnimatedBuilder(
            animation: widget.glowAnimation,
            builder: (context, child) {
              final pulse = widget.glowAnimation.value;

              final rotation = widget.isGlowing ? math.sin(pulse * 2 * math.pi) * 0.4 : 0.0;

              final pulseScale = widget.isGlowing ? 1.15 + (pulse * 0.15) : 1.0;
              final totalScale = pulseScale * tapScale;

              final glow = widget.isGlowing
                  ? BoxShadow(
                      color: Colors.green.withOpacity(0.8 + 0.2 * pulse),
                      blurRadius: 40 + (pulse * 12),
                      spreadRadius: 6 + (pulse * 4),
                    )
                  : const BoxShadow(color: Colors.transparent);

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.rotate(
                  angle: rotation,
                  child: Transform.scale(
                    scale: totalScale,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: baseColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                          glow,
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          getIconForStatus(widget.node.status),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                LessonSparkleEffect(enabled: widget.isGlowing),
              ],
            );

            },
          );
        },
      ),
    );
  }
}
