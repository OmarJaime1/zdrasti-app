import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_helpers.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';

class BossReadingSection extends StatefulWidget {
  final String paragraph;
  final List<ReadingQuestion> questions;
  final int passScore;
  final void Function(bool passed, double score) onCompleted;

  const BossReadingSection({
    super.key,
    required this.paragraph,
    required this.questions,
    this.passScore = 4,
    required this.onCompleted,
  });

  @override
  State<BossReadingSection> createState() => _BossReadingSectionState();
}

class _BossReadingSectionState extends State<BossReadingSection> with BossSectionLogic {
  final Map<int, TextEditingController> _controllers = {};
  final List<bool> _results = [];
  bool _submitted = false;
  bool _passed = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.questions.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    bool anyEmpty = _controllers.values.any((controller) => controller.text.trim().isEmpty);

    if (anyEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions before submitting.')),
      );
      return;
    }

    for (int i = 0; i < widget.questions.length; i++) {
      final expected = widget.questions[i].answer.trim().toLowerCase();
      final actual = _controllers[i]!.text.trim().toLowerCase();
      _results.add(expected == actual);
    }

    final correct = _results.where((r) => r).length;
  
    setState(() {
      _submitted = true;
      _passed = correct >= widget.passScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text('Read this paragraph:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(widget.paragraph, style: const TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              itemCount: widget.questions.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q${i + 1}: ${widget.questions[i].question}'),
                      const SizedBox(height: 6),
                      BossSectionHelpers.inputField(
                        controller: _controllers[i]!,
                        enabled: !_submitted,
                        hint: 'Your answer...',
                      ),
                      if (_submitted)
                        BossSectionHelpers.answerFeedbackBox(
                          isCorrect: _results[i],
                          correctAnswer: widget.questions[i].answer,
                        )
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          Center(
            child: BossSectionHelpers.nextOrSubmitButton(
              submitted: _submitted,
              onSubmit: _handleSubmit,
              onNext: () => widget.onCompleted(_passed, getScore()),
              submitLabel: 'Submit Answers',
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get hasSubmitted => _submitted;

  @override
  double getScore() => widget.questions.isEmpty ? 0.0 : _results.where((r) => r).length / widget.questions.length;

}
