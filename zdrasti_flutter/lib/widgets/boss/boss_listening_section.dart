import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/backend/service/audio/audio_service.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_logic.dart';

class BossListeningSection extends StatefulWidget {
  final List<ListeningPrompt> prompts;
  final void Function(bool passed) onCompleted;

  const BossListeningSection({
    super.key,
    required this.prompts,
    required this.onCompleted,
  });

  @override
  State<BossListeningSection> createState() => _BossListeningSectionState();
}

class _BossListeningSectionState extends State<BossListeningSection> with BossSectionLogic {
  final Map<int, TextEditingController> _controllers = {};
  final List<bool> _results = [];
  bool _submitted = false;
  bool _passed = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.prompts.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _playAudio(String text) {
    AudioService.speak(text);
  }

  void _handleSubmit() {
    bool anyEmpty = _controllers.values.any((controller) => controller.text.trim().isEmpty);

    if (anyEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all answers before submitting.')),
      );
      return;
    }

    final newResults = <bool>[];
    for (var i = 0; i < widget.prompts.length; i++) {
      final expected = widget.prompts[i].answer.trim().toLowerCase();
      final actual = _controllers[i]!.text.trim().toLowerCase();
      newResults.add(expected == actual);
    }

    final correct = newResults.where((r) => r).length;

    setState(() {
      _results.clear();
      _results.addAll(newResults);
      _submitted = true;
      _passed = correct >= (widget.prompts.length * 0.8);
    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.prompts.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Prompt ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Play audio',
                        onPressed: () => _playAudio(widget.prompts[i].text),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _controllers[i],
                    enabled: !_submitted,
                    decoration: InputDecoration(
                      hintText: 'Type exactly what you hear...',
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
                        _results[i] ? '✅ Correct' : '❌ Correct: ${widget.prompts[i].answer}',
                        style: TextStyle(
                          color: _results[i] ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ],
              ),
            ),

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: _submitted ? () => widget.onCompleted(_passed) : _handleSubmit,
              child: Text(_submitted ? 'Next' : 'Submit All'),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get hasSubmitted => _submitted;

  @override
  double getScore() => widget.prompts.isEmpty ? 0.0 : _results.where((r) => r).length / widget.prompts.length;
}
