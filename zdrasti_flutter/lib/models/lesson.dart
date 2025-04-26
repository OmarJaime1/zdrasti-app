class VocabularyWord {
  final String bg;
  final Map<String, String> translation;

  VocabularyWord({required this.bg, required this.translation});

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      bg: json['bg'],
      translation: Map<String, String>.from(json['translation']),
    );
  }
}

class GrammarTopic {
  final Map<String, String> title;
  final Map<String, String> explanation;
  final Map<String, List<String>>? tableHeaders;
  final List<List<String>>? tableRows;
  final List<GrammarExample>? examples;
  final Map<String, String>? usageTip;

  GrammarTopic({
    required this.title,
    required this.explanation,
    this.tableHeaders,
    this.tableRows,
    this.examples,
    this.usageTip,
  });

  factory GrammarTopic.fromJson(Map<String, dynamic> json) {
    final table = json['table'];
    return GrammarTopic(
      title: Map<String, String>.from(json['title']),
      explanation: Map<String, String>.from(json['explanation']),
      tableHeaders: table?['headers'] != null
          ? (table['headers'] as Map<String, dynamic>).map(
              (k, v) => MapEntry(k, List<String>.from(v)))
          : null,
      tableRows: table?['rows'] != null
          ? (table['rows'] as List)
              .whereType<List>()
              .map((r) => r.whereType<String>().toList())
              .toList()
          : null,
      examples: (json['examples'] is List)
          ? (json['examples'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => GrammarExample.fromJson(e))
              .toList()
          : null,
      usageTip: json['usage_tip'] != null
          ? Map<String, String>.from(json['usage_tip'])
          : null,
    );
  }
}

class GrammarExample {
  final String bg;
  final Map<String, String> translation;

  GrammarExample({required this.bg, required this.translation});

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      bg: json['bg'],
      translation: Map<String, String>.from(json['translation']),
    );
  }
}

class QuizQuestion {
  final Map<String, String> question;
  final String type;
  final Map<String, List<String>> localizedOptions;
  final Map<String, String> localizedAnswer;
  final Map<String, String> explanation;

  QuizQuestion({
    required this.question,
    required this.type,
    required this.localizedOptions,
    required this.localizedAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    Map<String, List<String>> parsedOptions;

    if (rawOptions is List) {
      final safeList = rawOptions.whereType<String>().toList();
      parsedOptions = {
        'en': safeList,
        'es': safeList,
        'tr': safeList,
      };
    } else if (rawOptions is Map<String, dynamic>) {
      parsedOptions = {};
      rawOptions.forEach((lang, value) {
        if (value is List) {
          parsedOptions[lang] = value.whereType<String>().toList();
        }
      });
    } else {
      parsedOptions = {};
    }

    final rawAnswer = json['answer'];
    Map<String, String> parsedAnswer;

    if (rawAnswer is String) {
      parsedAnswer = {
        'en': rawAnswer,
        'es': rawAnswer,
        'tr': rawAnswer,
      };
    } else if (rawAnswer is Map<String, dynamic>) {
      parsedAnswer = {};
      rawAnswer.forEach((lang, value) {
        if (value is String) {
          parsedAnswer[lang] = value;
        }
      });
    } else {
      parsedAnswer = {};
    }

    return QuizQuestion(
      question: Map<String, String>.from(json['question']),
      type: json['type'],
      localizedOptions: parsedOptions,
      localizedAnswer: parsedAnswer,
      explanation: Map<String, String>.from(json['explanation']),
    );
  }
}

class ListeningSection {
  final String script;
  final List<QuizQuestion> questions;

  ListeningSection({required this.script, required this.questions});

  factory ListeningSection.fromJson(Map<String, dynamic> json) {
    return ListeningSection(
      script: json['script'],
      questions: (json['questions'] is List)
          ? (json['questions'] as List)
              .whereType<Map<String, dynamic>>()
              .map((q) => QuizQuestion.fromJson(q))
              .toList()
          : [],
    );
  }
}

class FitrRoleplay {
  final Map<String, String> scenario;
  final List<String> dialogueWithBlanks;
  final List<RoleplayAnswer> answers;
  final int passScorePercent;

  FitrRoleplay({
    required this.scenario,
    required this.dialogueWithBlanks,
    required this.answers,
    required this.passScorePercent,
  });

  factory FitrRoleplay.fromJson(Map<String, dynamic> json) {
    return FitrRoleplay(
      scenario: Map<String, String>.from(json['scenario']),
      dialogueWithBlanks: List<String>.from(json['dialogue_with_blanks']),
      answers: (json['answers'] is List)
          ? (json['answers'] as List)
              .whereType<Map<String, dynamic>>()
              .map((a) => RoleplayAnswer.fromJson(a))
              .toList()
          : [],
      passScorePercent: json['pass_score_percent'] ?? 80,
    );
  }
}

class RoleplayAnswer {
  final List<String> correct;

  RoleplayAnswer({required this.correct});

  factory RoleplayAnswer.fromJson(Map<String, dynamic> json) {
    return RoleplayAnswer(correct: List<String>.from(json['correct']));
  }
}

class Lesson {
  final String lessonId;
  final String cefrLevel;
  final Map<String, String> title;
  final List<VocabularyWord> vocabulary;
  final GrammarTopic grammarTopic;
  final Map<String, dynamic> culturalTip;
  final Map<String, dynamic>? slang;
  final List<QuizQuestion> quiz;
  final ListeningSection listening;
  final FitrRoleplay fitrRoleplay;
  final Map<String, String>? alphabetNotes;
  final List<Map<String, dynamic>>? alphabetTable;
  final Map<String, String>? overview;

  Lesson({
    required this.lessonId,
    required this.cefrLevel,
    required this.title,
    required this.vocabulary,
    required this.grammarTopic,
    required this.culturalTip,
    this.slang,
    required this.quiz,
    required this.listening,
    required this.fitrRoleplay,
    this.alphabetNotes,
    this.alphabetTable,
    this.overview,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lesson_id'],
      cefrLevel: json['cefr_level'],
      title: Map<String, String>.from(json['title']),
      vocabulary: (json['vocabulary'] is List)
          ? (json['vocabulary'] as List)
              .whereType<Map<String, dynamic>>()
              .map((v) => VocabularyWord.fromJson(v))
              .toList()
          : [],
      grammarTopic: json['grammar_topic'] != null
          ? GrammarTopic.fromJson(json['grammar_topic'])
          : GrammarTopic(title: {}, explanation: {}),
      culturalTip: Map<String, dynamic>.from(json['cultural_tip']),
      slang: json['slang'] != null ? Map<String, dynamic>.from(json['slang']) : null,
      quiz: (json['quiz'] is List)
          ? (json['quiz'] as List)
              .whereType<Map<String, dynamic>>()
              .map((q) => QuizQuestion.fromJson(q))
              .toList()
          : [],
      listening: json['listening'] != null
          ? ListeningSection.fromJson(json['listening'])
          : ListeningSection(script: '', questions: []),
      fitrRoleplay: json['fitr_roleplay'] != null
          ? FitrRoleplay.fromJson(json['fitr_roleplay'])
          : FitrRoleplay(
              scenario: {},
              dialogueWithBlanks: [],
              answers: [],
              passScorePercent: 80,
            ),
      alphabetNotes: json['alphabet_notes'] != null
          ? Map<String, String>.from(json['alphabet_notes'])
          : null,
      alphabetTable: json['alphabet_table'] != null
          ? List<Map<String, dynamic>>.from(json['alphabet_table'])
          : null,
      overview: json['overview'] != null ? Map<String, String>.from(json['overview']) : null,
    );
  }
}