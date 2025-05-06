import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_helpers.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';

class BossFitrSection extends StatefulWidget {
  final FitrVariant variant;
  final int passScorePercent;
  final void Function(bool passed, double score) onCompleted;
  final Map<String, String>? scenario;

  const BossFitrSection({
    super.key,
    required this.variant,
    required this.passScorePercent,
    required this.onCompleted,
    this.scenario,
  });

  @override
  State<BossFitrSection> createState() => _BossFitrSectionState();
}

class _BossFitrSectionState extends State<BossFitrSection> with BossSectionLogic {
  final Map<int, TextEditingController> _controllers = {};
  final List<bool> _results = [];
  bool _submitted = false;
  bool _passed = false;
  double _scorePercent = 0.0;
  int _totalBuiltBlanks = 0;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    _results.clear();

    bool anyEmpty = false;
    for (int i = 0; i < _totalBuiltBlanks; i++) {
      final text = _controllers[i]?.text;
      if (text == null || text.trim().isEmpty) {
        anyEmpty = true;
        break;
      }
    }

    if (anyEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar( content: Text(LocalizationService.getStaticText('snackbar.fillAllBlanks')),)
      );
      return;
    }

    for (int i = 0; i < _totalBuiltBlanks; i++) {
      final accepted = widget.variant.answers[i].correct.map((s) => s.toLowerCase().trim()).toList();
      final actual = _controllers[i]!.text.toLowerCase().trim();
      final isCorrect = accepted.contains(actual);
      _results.add(isCorrect);
    }

    final correct = _results.where((r) => r).length;
    _scorePercent = (correct / _totalBuiltBlanks) * 100;

    setState(() {
      _submitted = true;
      _passed = _scorePercent >= widget.passScorePercent;
    });
  }

  @override
  Widget build(BuildContext context) {
    _totalBuiltBlanks = 0;

    final scenarioText = widget.scenario != null ? LocalizationService.getLocalizedText(widget.scenario!) : '';
    final lines = widget.variant.dialogueWithBlanks;
    int blankIndex = 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (scenarioText.isNotEmpty)
            Center(
              child: Column(
                children: [
                  TranslationBubble(
                    bulgarian: scenarioText,
                    nativeLanguage: '',
                    showTail: true,
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/kuker/kuker_boss_a1.png', height: 100),
                ],
              ),
            ),
          const SizedBox(height: 20),

          for (final line in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        ...line.split(' ').map((word) {
                          if (word.contains('_____')) {
                            final index = blankIndex;
                            if (!_controllers.containsKey(index)) {
                              _controllers[index] = TextEditingController();
                            }
                            final showAnswer = _submitted;
                            final correctAnswers = widget.variant.answers[index].correct;
                            final isCorrect = _results.length > index && _results[index];
                            blankIndex++;
                            _totalBuiltBlanks++;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: BossSectionHelpers.inputField(
                                    controller: _controllers[index]!,
                                    enabled: !_submitted,
                                    hint: LocalizationService.getStaticText('input.blank'),
                                    margin: EdgeInsets.zero,
                                  ),
                                ),
                                if (showAnswer)
                                  BossSectionHelpers.answerFeedbackBox(
                                    isCorrect: isCorrect,
                                    correctAnswer: correctAnswers.join(', '),
                                  )
                              ],
                            );
                          } else {
                            return Text(word, style: const TextStyle(fontSize: 16));
                          }
                        }).toList()
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          Center(
            child: BossSectionHelpers.nextOrSubmitButton(
              submitted: _submitted,
              onSubmit: _handleSubmit,
              onNext: () => widget.onCompleted(_passed, _scorePercent),
              submitLabel: 'boss.submitRoleplay',
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get hasSubmitted => _submitted;

  @override
  double getScore() {
    final total = _totalBuiltBlanks;
    final correct = _results.where((r) => r).length;
    return total == 0 ? 0.0 : correct / total;
  }
}