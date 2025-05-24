import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_helpers.dart';

class LessonRoleplaySection extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;

  const LessonRoleplaySection({
    super.key,
    required this.data,
    required this.onCompleted,
  });

  @override
  State<LessonRoleplaySection> createState() => _LessonRoleplaySectionState();
}

class _LessonRoleplaySectionState extends State<LessonRoleplaySection> {
  late final FitrRoleplay fitr;
  late final List<TextEditingController> _controllers;
  late final List<bool> _isCorrect;
  bool _submitted = false;
  bool _passed = false;

  @override
  void initState() {
    super.initState();
    fitr = widget.data['roleplay'];
    _controllers = List.generate(fitr.answers.length, (_) => TextEditingController());
    _isCorrect = List.filled(fitr.answers.length, false);
  }

  void _handleSubmit() {
    final userAnswers = _controllers.map((c) => c.text.trim()).toList();
    final correctAnswers = fitr.answers;

    bool allFilled = userAnswers.every((a) => a.isNotEmpty);
    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationService.getStaticText('lesson.fillAllBlanks'))),
      );
      return;
    }

    int correct = 0;
    for (int i = 0; i < correctAnswers.length; i++) {
      final correctSet = correctAnswers[i].correct.map((s) => s.trim().toLowerCase()).toSet();
      final userAnswer = userAnswers[i].toLowerCase();
      _isCorrect[i] = correctSet.contains(userAnswer);
      if (_isCorrect[i]) correct++;
    }

    final score = correct / correctAnswers.length;
    _passed = score >= fitr.passScorePercent;

    setState(() {
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scenario = LocalizationService.getLocalizedText(fitr.scenario);

    int blankCounter = 0;

    return LessonScaffold(
      title: LocalizationService.getStaticText('lesson.roleplayTitle'),
      onNext: _submitted ? () => widget.onCompleted(_passed, _passed ? 1.0 : 0.0) : null,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: fitr.dialogueWithBlanks.map((line) {
                  final words = line.split(' ');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: words.map((word) {
                        if (word.contains('_____')) {
                          final controller = _controllers[blankCounter];
                          final correct = _isCorrect[blankCounter];
                          final answerList = fitr.answers[blankCounter].correct;
                          blankCounter++;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: controller,
                                  enabled: !_submitted,
                                  decoration: InputDecoration(
                                    hintText: '',
                                    filled: true,
                                    fillColor: _submitted
                                        ? (correct
                                            ? Colors.green.shade50
                                            : Colors.red.shade50)
                                        : Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _submitted
                                            ? (correct ? Colors.green : Colors.red)
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_submitted && !correct)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: BossSectionHelpers.answerFeedbackBox(
                                    isCorrect: false,
                                    correctAnswer: answerList.join(', '),
                                  ),
                                ),
                            ],
                          );
                        } else {
                          return Text(word, style: const TextStyle(fontSize: 16));
                        }
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (!_submitted)
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text(LocalizationService.getStaticText('button.submit')),
            ),
        ],
      ),
    );
  }
}