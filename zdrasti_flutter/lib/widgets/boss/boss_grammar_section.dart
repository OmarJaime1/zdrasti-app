// lib/widgets/boss/boss_grammar_section.dart

import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_helpers.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';

class BossGrammarSection extends StatefulWidget {
  final List<GrammarQuestion> questions;
  final int passScore;
  final void Function(bool passed, double score) onCompleted;
  final Map<String, String>? scenario; 

  const BossGrammarSection({
    super.key,
    required this.questions,
    this.passScore = 4,
    required this.onCompleted,
    this.scenario,
  });

  @override
  State<BossGrammarSection> createState() => _BossGrammarSectionState();
}

class _BossGrammarSectionState extends State<BossGrammarSection> with BossSectionLogic {
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _submitted = false;
  bool _wasCorrect = false;
  final TextEditingController _controller = TextEditingController();
  late final ValueNotifier<String> _inputText;

  void _handleSubmit() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = widget.questions[_currentIndex].answer.toLowerCase();

    final isCorrect = userAnswer == correctAnswer;
    setState(() {
      _submitted = true;
      _wasCorrect = isCorrect;
      if (isCorrect) _correctCount++;
    });
  }

  @override
  void initState() {
    super.initState();
    _inputText = ValueNotifier('');
    _controller.addListener(() {
      _inputText.value = _controller.text;
    });
  }

  void _next() {
    if (_currentIndex + 1 < widget.questions.length) {
      setState(() {
        _currentIndex++;
        _controller.clear();
        _submitted = false;
      });
    } else {
      final passed = _correctCount >= widget.passScore;
      final score = getScore();
      widget.onCompleted(passed, score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex].question;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           if (widget.scenario != null && widget.scenario!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                LocalizationService.getLocalizedText(widget.scenario!),
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),

          Text(
            'Question ${_currentIndex + 1} of ${widget.questions.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Text(
            question,
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 12),

          BossSectionHelpers.inputField(
            controller: _controller,
            enabled: !_submitted,
            hint: LocalizationService.getStaticText('input.answerHint')
          ),

          const SizedBox(height: 12),

          if (!_submitted)
            Center(
              child: BossSectionHelpers.confirmableSubmitButton(
                notifier: _inputText,
                onPressed: _handleSubmit,
                label: 'button.submit',
              ),
            )
          else ...[
            BossSectionHelpers.answerFeedbackBox(
              isCorrect: _wasCorrect,
              correctAnswer: widget.questions[_currentIndex].answer,
            ),
            const SizedBox(height: 8),
            Center(
              child: BossSectionHelpers.nextOrSubmitButton(
                submitted: true,
                onNext: _next,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  @override
  bool get hasSubmitted => _submitted;
  
  @override
  double getScore() {
    final total = widget.questions.length;
    return total == 0 ? 0 : _correctCount / total;
  }
}
