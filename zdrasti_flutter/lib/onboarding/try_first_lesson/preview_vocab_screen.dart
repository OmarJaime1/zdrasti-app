import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/widgets/vocab_card.dart';
import 'package:zdrasti_flutter/onboarding/try_first_lesson/preview_grammar_screen.dart';

class PreviewVocabScreen extends StatelessWidget {
  const PreviewVocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('First Bulgarian Words'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Let’s learn your first Bulgarian words!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            VocabCard(word: 'хляб (hlyab)', imagePath: 'assets/images/vocab/bread.png'),
            VocabCard(word: 'вода (voda)', imagePath: 'assets/images/vocab/water.png'),
            VocabCard(word: 'здравей (zdravey)', imagePath: 'assets/images/vocab/hello.png'),
            const Spacer(),
            Image.asset(
              'assets/images/kuker/kuker_helper.png',
              height: 120,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //Go to grammar screen
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PreviewGrammarScreen(),
                      ),
                    );
              },
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}