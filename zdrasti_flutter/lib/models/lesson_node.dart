import 'dart:ui';

enum LessonStatus { completed, active, locked }

class LessonNode {
  final String lessonId;
  final String phase;
  final String mapId;
  final String background;
  final Offset position; // x/y are percentages (0.0–1.0)
  final LessonStatus status;

  LessonNode({
    required this.lessonId,
    required this.phase,
    required this.mapId,
    required this.background,
    required this.position,
    required this.status,
  });
}