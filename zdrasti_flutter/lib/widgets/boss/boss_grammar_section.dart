// lib/widgets/boss/boss_grammar_section.dart

import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';

class BossGrammarSection extends StatefulWidget {
  final List<GrammarQuestion> questions;
  final int passScore;
  final void Function(bool passed) onCompleted;

  const BossGrammarSection({
    super.key,
    required this.questions,
    this.passScore = 4,
    required this.onCompleted,
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

  void _next() {
    if (_currentIndex + 1 < widget.questions.length) {
      setState(() {
        _currentIndex++;
        _controller.clear();
        _submitted = false;
      });
    } else {
      final passed = _correctCount >= widget.passScore;
      widget.onCompleted(passed);
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

          TextField(
            controller: _controller,
            enabled: !_submitted,
            decoration: const InputDecoration(
              hintText: 'Type your answer...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          if (!_submitted)
            ElevatedButton(
              onPressed: _controller.text.trim().isEmpty ? null : _handleSubmit,
              child: const Text('Submit'),
            )
          else ...[
            Text(
              _wasCorrect ? '✅ Correct!' : '❌ Incorrect. Correct: ${widget.questions[_currentIndex].answer}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _wasCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _next,
              child: const Text('Next'),
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
