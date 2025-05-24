import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/lesson_section.dart';

class LessonLoader {
  static Future<List<Lesson>> loadLessonsForLevel(String level) async {
    final jsonString = await rootBundle.loadString('assets/lessons/lessons_a1.json');
    final data = json.decode(jsonString);
    final lessonsList = data['lessons']; 

    return List<Lesson>.from(
      lessonsList.map((json) => Lesson.fromJson(json)),
    );
  }

  static Future<List<VocabularyWord>> loadAllVocabForLevel(String level) async {
    final allLessons = await loadLessonsForLevel(level);
    final allVocab = <VocabularyWord>[];

    for (final lesson in allLessons) {
      allVocab.addAll(lesson.vocabulary);
    }

    return allVocab;
  }

  static  List<LessonSection> buildLessonSections(Lesson lesson) {
    final idPrefix = lesson.lessonId;

    return [
      if (lesson.vocabulary.isNotEmpty)
        LessonSection(
          id: '${idPrefix}_vocab',
          type: 'vocab',
          data: {
            'vocabulary': lesson.vocabulary,
            'title': lesson.title,
          },
          isScored: false,
        ),
      if (lesson.grammarTopic.title.isNotEmpty)
        LessonSection(
          id: '${idPrefix}_grammar',
          type: 'grammar',
          data: {
            'grammar': lesson.grammarTopic,
            'title': lesson.title,
          },
          isScored: false,
        ),
      if (lesson.culturalTip['text'] != null)
        LessonSection(
          id: '${idPrefix}_tipSlang',
          type: 'tip_slang',
          data: {
            'culturalTip': lesson.culturalTip,
            'slang': lesson.slang, 
            'title': lesson.title,
          },
          isScored: false,
        ),
      if (lesson.quiz.isNotEmpty)
        LessonSection(
          id: '${idPrefix}_quiz',
          type: 'quiz',
          data: {
            'quiz': lesson.quiz,
            'title': lesson.title,
          },
          isScored: true,
        ),
      if (lesson.listening.script.isNotEmpty)
        LessonSection(
          id: '${idPrefix}_listening',
          type: 'listening',
          data: {
            'listening': lesson.listening,
            'title': lesson.title,
          },
          isScored: true,
        ),
      if (lesson.fitrRoleplay.dialogueWithBlanks.isNotEmpty)
        LessonSection(
          id: '${idPrefix}_roleplay',
          type: 'roleplay',
          data: {
            'roleplay': lesson.fitrRoleplay,
            'title': lesson.title,
          },
          isScored: true,
        ),
      if (lesson.alphabetTable != null && lesson.alphabetTable!.isNotEmpty)
        LessonSection(
          id: '${idPrefix}_alphabet',
          type: 'alphabet',
          data: {
            'notes': lesson.alphabetNotes ?? {},
            'table': lesson.alphabetTable!,
            'title': lesson.title,
          },
          isScored: false,
        ),
    ];
  }
}
