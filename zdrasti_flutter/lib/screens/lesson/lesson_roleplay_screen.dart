import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_result_screen.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonRoleplayScreen extends StatefulWidget {
  final Lesson lesson;
  final User user;

  const LessonRoleplayScreen({
    super.key,
    required this.lesson,
    required this.user,
  });

  @override
  State<LessonRoleplayScreen> createState() => _LessonRoleplayScreenState();
}

class _LessonRoleplayScreenState extends State<LessonRoleplayScreen> {
  late List<TextEditingController> _controllers;
  bool _submitted = false;
  bool _passed = false;
  int _correct = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.lesson.fitrRoleplay.answers.length,
      (_) => TextEditingController(),
    );
  }

  void _handleSubmit() {
    final userAnswers = _controllers.map((c) => c.text.trim()).toList();
    final correctAnswers = widget.lesson.fitrRoleplay.answers;

    int correctCount = 0;
    for (int i = 0; i < correctAnswers.length; i++) {
      final accepted = correctAnswers[i].correct.map((e) => e.toLowerCase().trim()).toList();
      final userInput = userAnswers[i].toLowerCase();
      if (accepted.contains(userInput)) correctCount++;
    }

    final score = (correctCount / correctAnswers.length) * 100;
    setState(() {
      _submitted = true;
      _passed = score >= widget.lesson.fitrRoleplay.passScorePercent;
      _correct = correctCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fitr = widget.lesson.fitrRoleplay;
    final scenario = LocalizationService.getLocalizedText(fitr.scenario);
    final lines = fitr.dialogueWithBlanks;
    final total = fitr.answers.length;

    int answerIndex = 0;

    return LessonScaffold(
      title: 'Roleplay Practice',
      onNext: _submitted
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonResultScreen(
                    lesson: widget.lesson,
                    user: widget.user,
                  ),
                ),
              );
            }
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                TranslationBubble(
                  bulgarian: scenario,
                  nativeLanguage: '',
                  showTail: true,
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/images/kuker/kuker_helper.png',
                  height: 100,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: lines.map((line) {
                  final isBlank = line.contains('__________');

                  if (isBlank) {
                    final controller = _controllers[answerIndex];
                    answerIndex++;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 18)),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              enabled: !_submitted,
                              decoration: InputDecoration(
                                hintText: 'Type your response...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 18)),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (!_submitted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final anyBlank = _controllers.any((c) => c.text.trim().isEmpty);
                    if (!anyBlank) {
                      _handleSubmit();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all blanks')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'You got $_correct of $total correct.',
                      style: TextStyle(
                        fontSize: 16,
                        color: _passed ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      '🎉 Great job! You completed the dialogue.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}