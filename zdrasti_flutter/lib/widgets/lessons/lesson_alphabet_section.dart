import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonAlphabetSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;

  const LessonAlphabetSection({
    super.key,
    required this.data,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> titleMap = Map<String, String>.from(data['title']);
    final String title = LocalizationService.getLocalizedText(titleMap);
    final String notes = LocalizationService.getLocalizedText(Map<String, String>.from(data['notes']));
    final List<Map<String, dynamic>> table = List<Map<String, dynamic>>.from(data['table']);
    final String culturalTip = LocalizationService.getLocalizedText(Map<String, String>.from(data['culturalTip']['text']));

    return LessonScaffold(
      title: title,
      onNext: () => onCompleted(true, 1.0),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (notes.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(notes),
            ),
          const SizedBox(height: 20),

          TranslationBubble(
            bulgarian: culturalTip,
            nativeLanguage: LocalizationService.nativeLanguage,
            showTail: true,
          ),
          const SizedBox(height: 24),

          Text(
            LocalizationService.getStaticText('lesson.alphabetTitle'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...table.map((entry) {
            final letter = entry['letter'] ?? '';
            final example = entry['example'] ?? '';
            final pronunciation = (entry['pronunciation'] as Map?)?[LocalizationService.nativeLanguage] ?? '';
            final translation = (entry['translation'] as Map?)?[LocalizationService.nativeLanguage] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(letter, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    if (pronunciation.isNotEmpty)
                      Text(pronunciation, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    if (example.isNotEmpty)
                      Text(
                        LocalizationService.getStaticText('lesson.exampleFormat')
                          .replaceAll('{example}', example)
                          .replaceAll('{translation}', translation),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}