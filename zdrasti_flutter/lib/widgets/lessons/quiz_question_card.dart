import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class QuizQuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final void Function(bool correct) onAnswered;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  late List<String> _localizedOptions;
  String? _selectedOption;
  bool _submitted = false;
  bool _wasCorrect = false;

  @override
  void initState() {
    super.initState();
    _localizedOptions = _localizeOptions(widget.question.localizedOptions);
  }

  List<String> _localizeOptions(dynamic options) {
    if (options is List) {
      return options.cast<String>();
    }
    if (options is Map<String, dynamic>) {
      final lang = LocalizationService.nativeLanguage;
      final localized = options[lang];
      if (localized is List) return localized.cast<String>();
    }
    return [];
  }

  String _localize(dynamic value) {
    final lang = LocalizationService.nativeLanguage;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value[lang] ?? value['en'] ?? value.values.first;
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final questionText = _localize(widget.question.question);
    final explanation = _localize(widget.question.explanation);
    final correctAnswer = _localize(widget.question.localizedAnswer);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._localizedOptions.map((option) {
              final isSelected = option == _selectedOption;
              final isCorrect = option == correctAnswer;

              Color? tileColor;
              if (_submitted) {
                if (isSelected && isCorrect) tileColor = Colors.green.shade100;
                else if (isSelected && !isCorrect) tileColor = Colors.red.shade100;
                else if (isCorrect) tileColor = Colors.green.shade50;
              }

              Icon? icon;
              if (_submitted && isSelected) {
                icon = isCorrect
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red);
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: RadioListTile<String>(
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: _submitted ? null : (value) {
                    setState(() => _selectedOption = value);
                  },
                  title: Text(option),
                  secondary: icon,
                  activeColor: Colors.deepPurple,
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              );
            }),
            const SizedBox(height: 12),
            if (!_submitted)
              ElevatedButton(
                onPressed: _selectedOption == null ? null : () {
                  final correct = _selectedOption == correctAnswer;
                  setState(() {
                    _submitted = true;
                    _wasCorrect = correct;
                  });
                  widget.onAnswered(correct);
                },
                child: const Text('Submit'),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    _wasCorrect ? '✅ Correct!' : '❌ Incorrect',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _wasCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    explanation,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
