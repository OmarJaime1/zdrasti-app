import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson_section.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/widgets/lessons/lesson_alphabet_section.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_grammar_section.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_listening_section.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_quiz_section.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_roleplay_section.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_tip_slang_section.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_vocab_section.dart';


class LessonSectionFactory {
  static Widget build({
    required LessonSection section,
    required void Function(bool passed, double score) onCompleted,
    required local.User user,
  }) {
    switch (section.type) {
      case 'grammar':
        return LessonGrammarSection(data: section.data, onCompleted: onCompleted);
      case 'tip_slang':
        return LessonTipSlangSection(data: section.data, onCompleted: onCompleted, user: user);
      case 'alphabet':
        return LessonAlphabetSection(data: section.data, onCompleted: onCompleted);
      case 'vocab':
        return LessonVocabSection(data: section.data, onCompleted: onCompleted);
      case 'quiz':
        return LessonQuizSection(data: section.data, onCompleted: onCompleted);
      case 'listening':
        return LessonListeningSection(data: section.data, onCompleted: onCompleted);
      case 'roleplay':
        return LessonRoleplaySection(data: section.data, onCompleted: onCompleted);
      default:
        return Center(child: Text('Unsupported section type: ${section.type}'));
        
    }
  }
}
