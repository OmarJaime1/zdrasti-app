import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class RoleplayCard extends StatefulWidget {
  final List<String> linesWithBlanks;
  final List<List<String>> correctAnswers; // Multiple accepted values per blank
  final void Function(List<String> userAnswers, bool passed) onSubmitted;
  final int passScorePercent;

  const RoleplayCard({
    super.key,
    required this.linesWithBlanks,
    required this.correctAnswers,
    required this.onSubmitted,
    this.passScorePercent = 80,
  });

  @override
  State<RoleplayCard> createState() => _RoleplayCardState();
}

class _RoleplayCardState extends State<RoleplayCard> {
  final Map<int, TextEditingController> _controllers = {};
  bool _submitted = false;
  List<bool> _isCorrect = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.correctAnswers.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  void _handleSubmit() {
    final userAnswers = _controllers.values.map((c) => c.text.trim()).toList();

    // Require all blanks to be filled
    final allFilled = userAnswers.every((answer) => answer.isNotEmpty);
    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationService.getStaticText('snackbar.fillAllBlanks'))),
      );
      return;
    }

    final results = <bool>[];

    for (var i = 0; i < userAnswers.length; i++) {
      final normalizedUser = userAnswers[i].toLowerCase();
      final accepted = widget.correctAnswers[i].map((a) => a.toLowerCase().trim());
      results.add(accepted.contains(normalizedUser));
    }

    final correctCount = results.where((r) => r).length;
    final scorePercent = (correctCount / widget.correctAnswers.length) * 100;
    final passed = scorePercent >= widget.passScorePercent;

    setState(() {
      _submitted = true;
      _isCorrect = results;
    });

    widget.onSubmitted(userAnswers, passed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.linesWithBlanks.asMap().entries.map((entry) {
          final index = entry.key;
          final line = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• "),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 8,
                    children: line.split(' ').map((word) {
                      if (word.contains('_____')) {
                        final blankIndex = _controllers.keys.toList().indexOf(index);
                        return SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _controllers[blankIndex],
                            maxLength: 30,
                            enabled: !_submitted,
                            decoration: InputDecoration(
                              counterText: '', // hides character count
                              hintText: '...',
                              filled: true,
                              fillColor: _submitted
                                  ? (_isCorrect[blankIndex]
                                      ? Colors.green.shade50
                                      : Colors.red.shade50)
                                  : Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _submitted
                                      ? (_isCorrect[blankIndex]
                                          ? Colors.green
                                          : Colors.red)
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text(
                          word,
                          style: const TextStyle(fontSize: 16),
                        );
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        if (!_submitted)
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text(LocalizationService.getStaticText('button.submitAnswers')),
          ),
      ],
    );
  }
}