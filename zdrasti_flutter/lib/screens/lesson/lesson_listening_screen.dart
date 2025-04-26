import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/lessons/quiz_question_card.dart';
import 'package:zdrasti_flutter/backend/service/audio/audio_service.dart';
import 'lesson_roleplay_screen.dart';

class LessonListeningScreen extends StatefulWidget {
  final Lesson lesson;
  final User user;

  const LessonListeningScreen({
    super.key,
    required this.lesson,
    required this.user,
  });

  @override
  State<LessonListeningScreen> createState() => _LessonListeningScreenState();
}

class _LessonListeningScreenState extends State<LessonListeningScreen> {
  bool _completed = false;

  void _onAnswered(bool correct) {
    // Once all questions are answered, mark screen complete
    final total = widget.lesson.listening.questions.length;
    final completedCount = _answered.length;
    if (completedCount == total && !_completed) {
      setState(() {
        _completed = true;
      });
    }
  }

  final Map<int, bool> _answered = {};

  @override
  Widget build(BuildContext context) {
    final script = widget.lesson.listening.script;
    final questions = widget.lesson.listening.questions;

    return LessonScaffold(
      title: 'Listening',
      onNext: _completed
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonRoleplayScreen(
                    lesson: widget.lesson,
                    user: widget.user,
                  ),
                ),
              );
            }
          : null,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Script with audio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Script:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.deepPurple),
                        tooltip: 'Play audio',
                        onPressed: () => AudioService.speak(script),
                      ),
                    ],
                  ),
                  Text(
                    script,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Listening questions
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;

              return QuizQuestionCard(
                question: question,
                onAnswered: (isCorrect) {
                  _answered[index] = true;
                  _onAnswered(isCorrect);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
