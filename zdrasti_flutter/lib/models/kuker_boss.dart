import 'package:zdrasti_flutter/models/lesson.dart';

class KukerBoss {
  final String bossId;
  final String level;
  final String region;
  final String name;
  final String theme;
  final String introScript;
  final List<KukerSection> sections;
  final KukerFinalScript finalScript;
  final KukerLogic logic;

  KukerBoss({
    required this.bossId,
    required this.level,
    required this.region,
    required this.name,
    required this.theme,
    required this.introScript,
    required this.sections,
    required this.finalScript,
    required this.logic,
  });

  factory KukerBoss.fromJson(Map<String, dynamic> json) {
    return KukerBoss(
      bossId: json['boss_id'],
      level: json['level'],
      region: json['region'],
      name: json['name'],
      theme: json['theme'],
      introScript: json['intro_script'],
      sections: (json['sections'] as List)
          .map((s) => KukerSection.fromJson(s))
          .toList(),
      finalScript: KukerFinalScript.fromJson(json['final_script']),
      logic: KukerLogic.fromJson(json['logic']),
    );
  }
}

class KukerSection {
  final String id;
  final Map<String, String> title;
  final Map<String, String> kukerScript;
  final String type;

  // Shared fields
  final String? instructions;
  final int? passScore;
  final Map<String, String>? scenario;

  // Vocabulary
  final int? numberOfItems;

  // Grammar
  final List<GrammarQuestion>? grammarQuestions;

  // Listening
  final List<ListeningPrompt>? audioPrompts;

  // Reading
  final String? paragraph;
  final List<ReadingQuestion>? readingQuestions;

  // Roleplay
  final List<FitrVariant>? fitrVariants;
  final bool? useRandomVariant;
  final int? minimumScorePercent;

  // Writing
  final Map<String, String>? userPrompt;
  final Map<String, List<String>>? evaluationCriteria;
  final String? chatGptPromptFile;

  KukerSection({
    required this.id,
    required this.title,
    required this.kukerScript,
    required this.type,
    this.instructions,
    this.passScore,
    this.scenario,
    this.numberOfItems,
    this.grammarQuestions,
    this.audioPrompts,
    this.paragraph,
    this.readingQuestions,
    this.fitrVariants,
    this.useRandomVariant,
    this.minimumScorePercent,
    this.userPrompt,
    this.evaluationCriteria,
    this.chatGptPromptFile,
  });

  factory KukerSection.fromJson(Map<String, dynamic> json) {
    final type = json['type'];

    List<GrammarQuestion>? grammarQuestions;
    List<ReadingQuestion>? readingQuestions;

    if (type == 'fill_in_the_blank_quiz') {
      grammarQuestions = (json['questions'] as List?)
          ?.map((q) => GrammarQuestion.fromJson(q))
          .toList();
    } else if (type == 'short_paragraph_comprehension') {
      readingQuestions = (json['questions'] as List?)
          ?.map((q) => ReadingQuestion.fromJson(q))
          .toList();
    }

    return KukerSection(
      id: json['id'],
      title: Map<String, String>.from(json['title']),
      kukerScript: Map<String, String>.from(json['kuker_script']),
      type: type,
      instructions: json['instructions'],
      passScore: json['pass_score'],
      scenario: (json['scenario'] as Map?)?.cast<String, String>(),
      numberOfItems: json['number_of_items'],
      grammarQuestions: grammarQuestions,
      audioPrompts: (json['audio_prompts'] as List?)
          ?.map((a) => ListeningPrompt.fromJson(a))
          .toList(),
      paragraph: json['paragraph'],
      readingQuestions: readingQuestions,
      fitrVariants: (json['variants'] as List?)
          ?.map((v) => FitrVariant.fromJson(v))
          .toList(),
      useRandomVariant: json['use_random_variant'],
      minimumScorePercent: json['minimum_score_percent'],
      userPrompt: (json['user_prompt'] as Map?)?.cast<String, String>(),
      evaluationCriteria: (json['evaluation_criteria'] as Map?)
          ?.map((k, v) => MapEntry(k, (v as List).cast<String>())),
      chatGptPromptFile: json['chatGPT_prompt_file'],
      
    );
  }
}

class GrammarQuestion {
  final String question;
  final String answer;

  GrammarQuestion({required this.question, required this.answer});

  factory GrammarQuestion.fromJson(Map<String, dynamic> json) {
    return GrammarQuestion(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class ListeningPrompt {
  final String id;
  final String text;
  final String answer;

  ListeningPrompt({required this.id, required this.text, required this.answer});

  factory ListeningPrompt.fromJson(Map<String, dynamic> json) {
    return ListeningPrompt(
      id: json['id'],
      text: json['text'],
      answer: json['answer'],
    );
  }
}

class ReadingQuestion {
  final String question;
  final String answer;

  ReadingQuestion({required this.question, required this.answer});

  factory ReadingQuestion.fromJson(Map<String, dynamic> json) {
    return ReadingQuestion(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class FitrVariant {
  final String refId;
  final Map<String, String> scenario;
  final List<String> dialogueWithBlanks;
  final List<RoleplayAnswer> answers;

  FitrVariant({
    required this.refId,
    required this.scenario,
    required this.dialogueWithBlanks,
    required this.answers,
  });

  factory FitrVariant.fromJson(Map<String, dynamic> json) {
    return FitrVariant(
      refId: json['ref_id'],
      scenario: Map<String, String>.from(json['scenario']),
      dialogueWithBlanks: List<String>.from(json['dialogue_with_blanks']),
      answers: (json['answers'] as List)
          .map((a) => RoleplayAnswer.fromJson(a))
          .toList(),
    );
  }
}

class KukerFinalScript {
  final String pass;
  final String failWritting;
  final String failSections;

  KukerFinalScript({
    required this.pass,
    required this.failWritting,
    required this.failSections,
  });

  factory KukerFinalScript.fromJson(Map<String, dynamic> json) {
    return KukerFinalScript(
      pass: json['pass'],
      failWritting: json['fail_writting'],
      failSections: json['fail_quiz'],
    );
  }
}

class KukerLogic {
  final int requiredSectionsToPass;
  final bool allowTokenUseOnlyIfAllOthersPassed;
  final bool fitrVariantsRotatePerAttempt;

  KukerLogic({
    required this.requiredSectionsToPass,
    required this.allowTokenUseOnlyIfAllOthersPassed,
    required this.fitrVariantsRotatePerAttempt,
  });

  factory KukerLogic.fromJson(Map<String, dynamic> json) {
    return KukerLogic(
      requiredSectionsToPass: json['required_sections_to_pass'],
      allowTokenUseOnlyIfAllOthersPassed: json['allow_token_use_only_if_all_others_passed'],
      fitrVariantsRotatePerAttempt: json['fitr_variants_rotate_per_attempt'],
    );
  }
}