import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';
import 'package:zdrasti_flutter/widgets/lessons/vocab_card.dart';

class BossVocabularySection extends StatefulWidget {
  final List<VocabularyWord> allWords;
  final int numberOfItems;
  final int passScore;
  final void Function(bool passed, double score) onCompleted;

  const BossVocabularySection({
    super.key,
    required this.allWords,
    this.numberOfItems = 10,
    this.passScore = 8,
    required this.onCompleted,
  });

  @override
  State<BossVocabularySection> createState() => _BossVocabularySectionState();
}

class _BossVocabularySectionState extends State<BossVocabularySection> with BossSectionLogic {
  late List<_VocabTestItem> _testItems;
  int _currentIndex = 0;
  int _correctCount = 0;
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;
  bool _wasCorrect = false;
  late final ValueNotifier<String> _inputText;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    final shuffled = List<VocabularyWord>.from(widget.allWords)..shuffle(rng);
    _testItems = shuffled.take(widget.numberOfItems).map((w) {
      final correct = LocalizationService.getLocalizedText(w.translation);
      return _VocabTestItem(word: w, correctAnswer: correct);
    }).toList();
    
    _inputText = ValueNotifier('');
    _controller.addListener(() {
      _inputText.value = _controller.text;
    });
  }

  void _handleSubmit() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = _testItems[_currentIndex].correctAnswer.toLowerCase();

    final isCorrect = userAnswer == correctAnswer;
    setState(() {
      _submitted = true;
      _wasCorrect = isCorrect;
      if (isCorrect) _correctCount++;
    });
  }

  void _next() {
    if (_currentIndex + 1 < _testItems.length) {
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
  void dispose() {
    _controller.dispose();
    _inputText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _testItems[_currentIndex];

    return Column(
      children: [
        const SizedBox(height: 12),
        Text('Word ${_currentIndex + 1} of ${_testItems.length}'),
        const SizedBox(height: 12),

        VocabCard(word: current.word, allowReveal: false),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Translate this word into your language:'),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                enabled: !_submitted,
                decoration: InputDecoration(
                  hintText: 'Type your translation...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (!_submitted)
                ValueListenableBuilder<String>(
                valueListenable: _inputText,
                builder: (context, text, _) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: text.trim().isEmpty ? null : _handleSubmit,
                      child: const Text('Submit'),
                    ),
                  );
                },
              )
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _wasCorrect ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _wasCorrect ? '✅ Correct!' : '❌ Incorrect. Correct answer: ${current.correctAnswer}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _wasCorrect ? Colors.green.shade900 : Colors.red.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: _next,
                    child: const Text('Next'),
                  ),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get hasSubmitted => _submitted;

  @override
  double getScore() => _testItems.isEmpty ? 0.0 : _correctCount / _testItems.length;
}

class _VocabTestItem {
  final VocabularyWord word;
  final String correctAnswer;

  _VocabTestItem({required this.word, required this.correctAnswer});
}
