import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/lessons/listening_card.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonListeningSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;

  const LessonListeningSection({
    super.key,
    required this.data,
    required this.onCompleted,
  });

  @override
  State<LessonListeningSection> createState() => _LessonListeningSectionState();
}

class _LessonListeningSectionState extends State<LessonListeningSection> {
  bool _completed = false;
  double _score = 0.0;
  bool _passed = false;

  void _handleCompleted(int correct, int total) {
    final score = total == 0 ? 0.0 : correct / total;
    final passed = score >= 0.8;

    setState(() {
      _completed = true;
      _score = score;
      _passed = passed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.data['listening'] as ListeningSection;

    return LessonScaffold(
      title: LocalizationService.getStaticText('lesson.listeningTitle'),
      onNext: _completed
          ? () => widget.onCompleted(_passed, _score)
          : null,
      child: Column(
        children: [
          Expanded(
            child: ListeningCard(
              section: section,
              onCompleted: _handleCompleted,
            ),
          ),
          if (_completed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Text(
                    LocalizationService.getStaticText('lesson.quizScore')
                        .replaceAll('{correct}', (_score * section.questions.length).round().toString())
                        .replaceAll('{total}', section.questions.length.toString()),
                    style: TextStyle(
                      fontSize: 16,
                      color: _passed ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _passed
                        ? LocalizationService.getStaticText('lesson.quizPassed')
                        : LocalizationService.getStaticText('lesson.quizFailed'),
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
