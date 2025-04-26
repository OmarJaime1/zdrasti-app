import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/backend/service/lesson_service.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';

class LessonAlphabetScreen extends StatelessWidget {
  final Lesson lesson;
  final User user;

  const LessonAlphabetScreen({
    super.key,
    required this.lesson,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final title = LocalizationService.getLocalizedText(lesson.title);
    final overview = LocalizationService.getLocalizedText(lesson.overview ?? {});
    final notes = LocalizationService.getLocalizedText(lesson.alphabetNotes ?? {});
    final tip = LocalizationService.getLocalizedText(
      Map<String, String>.from(lesson.culturalTip['text']),
    );

    final table = lesson.alphabetTable ?? [];

    return LessonScaffold(
      title: title,
      onNext: null, // Done button is at the bottom
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🧠 Overview
          Text(overview, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),

          // 🔤 Notes
          if (notes.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(notes),
            ),
            const SizedBox(height: 20),
          ],

          // 🇧🇬 Cultural Tip
          TranslationBubble(
            bulgarian: tip,
            nativeLanguage: user.native_language,
            showTail: true,
          ),
          const SizedBox(height: 20),

          // 📚 Alphabet Table
          const Text(
            'Alphabet Table',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...table.map((entry) {
            final letter = entry['letter'] ?? '';
            final pronunciation = (entry['pronunciation'] as Map?)?[user.native_language] ?? '';
            final example = entry['example'] ?? '';
            final translation = (entry['translation'] as Map?)?[user.native_language] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(letter, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    if (pronunciation != null && pronunciation.isNotEmpty)
                      Text(pronunciation, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    if (example.isNotEmpty)
                      Text(
                        'Example: $example → $translation',
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          Center(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await LessonService.markLessonComplete(
                    userId: user.id,
                    lesson: lesson,
                    score: 100,
                  );
                  await UserService.addXp(user.id, amount: 25);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZdrastiShell(user: user),
                    ),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to mark lesson complete.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
