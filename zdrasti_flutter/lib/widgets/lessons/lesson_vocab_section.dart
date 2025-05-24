import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/lessons/vocab_card.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonVocabSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;

  const LessonVocabSection({
    super.key,
    required this.data,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final List<VocabularyWord> words = List<VocabularyWord>.from(data['vocabulary']);
    final Map<String, String> titleMap = Map<String, String>.from(data['title']);
    final title = LocalizationService.getLocalizedText(titleMap);

    return LessonScaffold(
      title: '$title • ${LocalizationService.getStaticText("lesson.vocabTitle")}',
      onNext: () => onCompleted(true, 1.0),
      child: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return VocabCard(word: words[index]);
        },
      ),
    );
  }
}
