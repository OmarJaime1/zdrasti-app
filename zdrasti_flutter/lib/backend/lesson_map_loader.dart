import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zdrasti_flutter/models/lesson_node.dart';

class LessonMapLoader {
  static Future<List<LessonNode>> loadLessonNodes({
    required String level,
    required Set<String> completedLessonIds,
  }) async {
    final raw = await rootBundle.loadString('assets/lessons/map_circle_locations.json');
    final json = jsonDecode(raw);
    final List maps = json['maps'];

    List<_ParsedNode> orderedNodes = [];

    for (var map in maps) {
      if (map['cefr_level'] != level) continue;

      final String mapId = map['map_id'];
      final String phase = map['phase'];
      final String background = map['background'];
      final List lessonCircles = map['lesson_circles'];

      for (int i = 0; i < lessonCircles.length; i++) {
        final lesson = lessonCircles[i];
        final id = lesson['lesson_id'];

        final position = Offset(
          (lesson['position']['x'] ?? lesson['position']['x_percent']) * 1.0,
          (lesson['position']['y'] ?? lesson['position']['y_percent']) * 1.0,
        );

        orderedNodes.add(_ParsedNode(
          lessonId: id,
          phase: phase,
          mapId: mapId,
          background: background,
          position: position,
        ));
      }
    }

    // Find the first uncompleted lesson
    final firstUncompleted = orderedNodes.firstWhere(
      (n) => !completedLessonIds.contains(n.lessonId),
      orElse: () => _ParsedNode.empty(),
    );

    return orderedNodes.map((n) {
      LessonStatus status;

      if (completedLessonIds.contains(n.lessonId)) {
        status = LessonStatus.completed;
      } else if (n.lessonId == firstUncompleted.lessonId) {
        status = LessonStatus.active;
      } else {
        status = LessonStatus.locked;
      }

      return LessonNode(
        lessonId: n.lessonId,
        phase: n.phase,
        mapId: n.mapId,
        background: n.background,
        position: n.position,
        status: status,
      );
    }).toList();
  }
}

class _ParsedNode {
  final String lessonId;
  final String phase;
  final String mapId;
  final String background;
  final Offset position;

  _ParsedNode({
    required this.lessonId,
    required this.phase,
    required this.mapId,
    required this.background,
    required this.position,
  });

  factory _ParsedNode.empty() {
    return _ParsedNode(
      lessonId: '',
      phase: '',
      mapId: '',
      background: '',
      position: Offset.zero,
    );
  }
}
