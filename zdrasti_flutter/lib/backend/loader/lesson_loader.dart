import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zdrasti_flutter/models/lesson.dart';

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

}
