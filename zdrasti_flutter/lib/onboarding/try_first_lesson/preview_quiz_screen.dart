import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/onboarding/try_first_lesson/preview_roleplay_screen.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';

class PreviewQuizScreen extends StatefulWidget {
  const PreviewQuizScreen({super.key});

  @override
  State<PreviewQuizScreen> createState() => _PreviewQuizScreenState();
}

class _PreviewQuizScreenState extends State<PreviewQuizScreen> {
  String? selectedAnswer1;
  String? selectedAnswer2;

  final correctAnswer1 = 'Bread';
  final correctAnswer2 = 'Щастлива';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Quiz'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '1. What does "хляб" mean?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              quizOption('Water', selectedAnswer1, (val) {
                setState(() => selectedAnswer1 = val);
              }),
              quizOption('Bread', selectedAnswer1, (val) {
                setState(() => selectedAnswer1 = val);
              }),
              quizOption('Hello', selectedAnswer1, (val) {
                setState(() => selectedAnswer1 = val);
              }),
              feedbackForAnswer(selectedAnswer1, correctAnswer1),
              const SizedBox(height: 24),
              const Text(
                '2. Which form is feminine?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              quizOption('Щастлив', selectedAnswer2, (val) {
                setState(() => selectedAnswer2 = val);
              }),
              quizOption('Щастливо', selectedAnswer2, (val) {
                setState(() => selectedAnswer2 = val);
              }),
              quizOption('Щастлива', selectedAnswer2, (val) {
                setState(() => selectedAnswer2 = val);
              }),
              feedbackForAnswer(selectedAnswer2, correctAnswer2),
              const SizedBox(height: 32),

              // Kuker + speech + button
              Column(
                children: [
                  const TranslationBubble(
                      bulgarian: 'Answer both questions correctly to continue',
                      nativeLanguage: '',
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/kuker/kuker_helper.png',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (selectedAnswer1 == correctAnswer1 && selectedAnswer2 == correctAnswer2)
                        ? () {
                            // Navigate to Roleplay preview screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PreviewRoleplayScreen()),
                            );
                          }
                        : null,
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quizOption(String label, String? groupValue, Function(String?) onChanged) {
    return RadioListTile<String>(
      title: Text(label),
      value: label,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  Widget feedbackForAnswer(String? selected, String correct) {
    if (selected == null) return const SizedBox.shrink();
    final isCorrect = selected == correct;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        isCorrect ? '🎉 Great job!' : '😅 Not quite. Try again!',
        style: TextStyle(
          color: isCorrect ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}