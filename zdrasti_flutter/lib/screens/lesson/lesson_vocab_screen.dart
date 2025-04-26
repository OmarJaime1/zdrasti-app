import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/lessons/vocab_card.dart';
import 'lesson_grammar_screen.dart';

class LessonVocabScreen extends StatelessWidget {
  final Lesson lesson;
  final User user;

  const LessonVocabScreen({super.key, 
    required this.lesson,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final title = LocalizationService.getLocalizedText(lesson.title);

    return LessonScaffold(
      title: '$title • Vocabulary',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonGrammarScreen(lesson: lesson, user: user,),
          ),
        );
      },
      child: ListView.builder(
        itemCount: lesson.vocabulary.length,
        itemBuilder: (context, index) {
          final word = lesson.vocabulary[index];
          return VocabCard(word: word);
        },
      ),
    );
  }
}