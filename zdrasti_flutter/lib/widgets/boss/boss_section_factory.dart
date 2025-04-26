import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_vocabulary_section.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_grammar_section.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_listening_section.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_reading_section.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_fitr_section.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_writing_section.dart';

typedef SectionCompleteCallback = void Function(bool passed);

class BossSectionFactory {
  static Widget build({
    required KukerSection section,
    required String bossLevel,
    required SectionCompleteCallback onCompleted,
    required void Function(String)? onWritingSubmitted,
    List<VocabularyWord>? vocabOverride,
  }) {
    switch (section.type) {
      case 'random_vocabulary_test':
        return BossVocabularySection(
          allWords: vocabOverride ?? [],
          onCompleted: onCompleted,
        );

      case 'fill_in_the_blank_quiz':
        return BossGrammarSection(
          questions: section.grammarQuestions ?? [],
          passScore: section.passScore ?? 4,
          onCompleted: onCompleted,
        );

      case 'audio_transcription':
        return BossListeningSection(
          prompts: section.audioPrompts ?? [],
          onCompleted: onCompleted,
        );

      case 'short_paragraph_comprehension':
        return BossReadingSection(
          paragraph: section.paragraph ?? '',
          questions: section.readingQuestions ?? [],
          passScore: section.passScore ?? 4,
          onCompleted: onCompleted,
        );

      case 'fitr':
        final variants = section.fitrVariants ?? [];
        final variant = variants.isEmpty
            ? null
            : (section.useRandomVariant ?? false
                ? (variants..shuffle()).first
                : variants.first);
        return variant == null
            ? const Center(child: Text('❌ No roleplay variants found.'))
            : BossFitrSection(
                variant: variant,
                passScorePercent: section.minimumScorePercent ?? 80,
                onCompleted: onCompleted,
              );

      case 'text_input':
        final lang = 'en'; // optionally use LocalizationService
        final prompt = section.userPrompt?[lang] ?? section.userPrompt?['en'] ?? '';
        return BossWritingSection(
          prompt: prompt,
          onSubmitted: onWritingSubmitted!,
        );

      default:
        return const Center(child: Text('Unsupported section type.'));
    }
  }
}