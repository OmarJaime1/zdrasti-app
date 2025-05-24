import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson_node.dart';

Color getColorForStatus(LessonStatus status) {
  switch (status) {
    case LessonStatus.completed:
      return Colors.green;
    case LessonStatus.active:
      return Colors.deepPurple;
    case LessonStatus.locked:
      return Colors.grey;
  }
}

IconData getIconForStatus(LessonStatus status) {
  switch (status) {
    case LessonStatus.completed:
      return Icons.check;
    case LessonStatus.active:
      return Icons.play_arrow;
    case LessonStatus.locked:
      return Icons.lock;
  }
}

String getBossLessonIdForLevel(String level) => 'boss_${level.toLowerCase()}';

RenderBox? getMapRenderBox(GlobalKey key) {
  final context = key.currentContext;
  if (context == null) return null;
  return context.findRenderObject() as RenderBox?;
}

void animateScrollToEdge({
  required TransformationController controller,
  required TickerProvider vsync,
  required RenderBox renderBox,
  required VoidCallback onFinished,
}) {
  const Duration duration = Duration(milliseconds: 400);
  const double rightNudge = -450.0;

  final mapSize = renderBox.size;
  final visibleSize = renderBox.size;

  double translateY = -(mapSize.height - visibleSize.height + 200);
  if (translateY.abs() < 1.0) translateY = -238.0;

  final currentMatrix = controller.value;
  final step1Target = Matrix4.identity()
    ..translate(currentMatrix.getTranslation().x, translateY);
  final step2Target = Matrix4.identity()
    ..translate(rightNudge, translateY);

  final step1Controller = AnimationController(vsync: vsync, duration: duration);
  final step1Animation = Matrix4Tween(
    begin: currentMatrix,
    end: step1Target,
  ).animate(CurvedAnimation(parent: step1Controller, curve: Curves.easeInOut));

  step1Animation.addListener(() {
    controller.value = step1Animation.value;
  });

  step1Controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      step1Controller.dispose();

      final step2Controller = AnimationController(vsync: vsync, duration: duration);
      final step2Animation = Matrix4Tween(
        begin: step1Target,
        end: step2Target,
      ).animate(CurvedAnimation(parent: step2Controller, curve: Curves.easeInOut));

      step2Animation.addListener(() {
        controller.value = step2Animation.value;
      });

      step2Controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          step2Controller.dispose();
          onFinished();
        }
      });

      step2Controller.forward();
    }
  });

  step1Controller.forward();
}

Future<void> scrollWhenMapReady({
  required GlobalKey mapKey,
  required TransformationController controller,
  required TickerProvider vsync,
  required VoidCallback onFinished,
}) async {
  while (true) {
    final renderBox = getMapRenderBox(mapKey);
    if (renderBox != null && renderBox.hasSize && renderBox.size.height > 100) break;
    await Future.delayed(const Duration(milliseconds: 30));
  }

  final renderBox = getMapRenderBox(mapKey);
  if (renderBox == null) return;

  animateScrollToEdge(
    controller: controller,
    vsync: vsync,
    renderBox: renderBox,
    onFinished: onFinished,
  );
}

List<bool> calculatePhaseCompletionStates(List<LessonNode> allNodes) {
  const allPhases = ['first', 'mid', 'final'];
  final completedPhases = <String, bool>{};

  for (final phase in allPhases) {
    final nodesForPhase = allNodes.where((n) => n.phase == phase).toList();
    final isComplete = nodesForPhase.isNotEmpty &&
        nodesForPhase.every((n) => n.status == LessonStatus.completed);
    completedPhases[phase] = isComplete;
  }

  return allPhases.map((p) => completedPhases[p] ?? false).toList();
}

Widget buildFloatingTooltip(String text) {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: 1,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    ),
  );
}
