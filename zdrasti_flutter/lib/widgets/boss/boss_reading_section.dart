import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';

class BossReadingSection extends StatefulWidget {
  final String paragraph;
  final List<ReadingQuestion> questions;
  final int passScore;
  final void Function(bool passed) onCompleted;

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
    _results.clear();

    for (int i = 0; i < widget.questions.length; i++) {
      final expected = widget.questions[i].answer.trim().toLowerCase();
      final actual = _controllers[i]!.text.trim().toLowerCase();
      _results.add(expected == actual);
    }

    final correct = _results.where((r) => r).length;
    final passed = correct >= widget.passScore;

    setState(() => _submitted = true);
    widget.onCompleted(passed);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          const SizedBox(height: 20),
          for (int i = 0; i < widget.questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q${i + 1}: ${widget.questions[i].question}'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _controllers[i],
                    enabled: !_submitted,
                    decoration: InputDecoration(
                      hintText: 'Your answer...',
                      fillColor: _submitted
                          ? (_results[i] ? Colors.green.shade50 : Colors.red.shade50)
                          : Colors.grey.shade100,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (_submitted)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _results[i] ? '✅ Correct' : '❌ Correct: ${widget.questions[i].answer}',
                        style: TextStyle(
                          color: _results[i] ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (!_submitted)
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Submit Answers'),
              ),
            )
        ],
      ),
    );
  }

  @override
  bool get hasSubmitted => _submitted;

  @override
  double getScore() => widget.questions.isEmpty ? 0.0 : _results.where((r) => r).length / widget.questions.length;

}
