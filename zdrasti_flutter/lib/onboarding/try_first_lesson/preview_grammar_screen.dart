import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/widgets/grammar_example_card.dart';
import 'package:zdrasti_flutter/onboarding/try_first_lesson/preview_quiz_screen.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';

class PreviewGrammarScreen extends StatefulWidget {
  const PreviewGrammarScreen({super.key});

  @override
  State<PreviewGrammarScreen> createState() => _PreviewGrammarScreenState();
}

class _PreviewGrammarScreenState extends State<PreviewGrammarScreen> {
  bool showTranslation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Grammar Tip'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'In Bulgarian, adjectives agree with the gender of nouns.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              GrammarExampleCard(
                bulgarian: 'Мъжът е щастлив.',
                nativeLanguage: 'The man is happy.',
              ),
              GrammarExampleCard(
                bulgarian: 'Жената е щастлива.',
                nativeLanguage: 'The woman is happy.',
              ),
              GrammarExampleCard(
                bulgarian: 'Малко момче е щастливо.',
                nativeLanguage: 'The little boy is happy.',
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  const TranslationBubble(
                      bulgarian: 'Tap to show/hide translation',
                      nativeLanguage: '',
                  ),                  
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/kuker/kuker_helper.png',
                    height: 120,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Go to quiz screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PreviewQuizScreen()),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
