import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';

class BossFitrSection extends StatefulWidget {
  final FitrVariant variant;
  final int passScorePercent;
  final void Function(bool passed) onCompleted;
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

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.variant.answers.length; i++) {
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

    for (int i = 0; i < widget.variant.answers.length; i++) {
      final accepted = [widget.variant.answers[i].correct];
      final actual = _controllers[i]!.text.trim().toLowerCase();
      _results.add(accepted.contains(actual));
    }

    final correct = _results.where((r) => r).length;
    final scorePercent = (correct / widget.variant.answers.length) * 100;
    final passed = scorePercent >= widget.passScorePercent;

    setState(() => _submitted = true);
    widget.onCompleted(passed);
  }

  @override
  Widget build(BuildContext context) {
    final scenarioText = widget.scenario?['en'] ?? widget.scenario?.values.first ?? '';
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
                      children: line.split(' ').map((word) {
                        if (word.contains('_____')) {
                          final index = blankIndex++;
                          return SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _controllers[index],
                              enabled: !_submitted,
                              decoration: InputDecoration(
                                hintText: '...',
                                filled: true,
                                fillColor: _submitted
                                    ? (_results[index]
                                        ? Colors.green.shade50
                                        : Colors.red.shade50)
                                    : Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _submitted
                                        ? (_results[index]
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Text(word, style: const TextStyle(fontSize: 16));
                        }
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          if (!_submitted)
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Submit Roleplay'),
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
    final total = widget.variant.answers.length;
    final correct = _results.where((r) => r).length;
    return total == 0 ? 0.0 : correct / total;
  }
}
