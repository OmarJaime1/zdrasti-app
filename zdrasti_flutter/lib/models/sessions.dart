abstract class AbstractSession {
  int correctAnswers = 0;
  int totalQuestions = 0;

  final Map<String, SectionStats> sectionStats = {};

  void recordSection({
    required String sectionId,
    required int correct,
    required int total,
  }) {
    sectionStats.putIfAbsent(sectionId, () => SectionStats(sectionId));
    sectionStats[sectionId]!.correct += correct;
    sectionStats[sectionId]!.total += total;

    correctAnswers += correct;
    totalQuestions += total;
  }

  int get score => totalQuestions == 0 ? 0 : ((correctAnswers / totalQuestions) * 100).toInt();
  bool get flawless => correctAnswers == totalQuestions;
  bool get passed; // Implemented in subclass
  int get xp;      // Implemented in subclass
}

class SectionStats {
  final String sectionId;
  int correct = 0;
  int total = 0;

  SectionStats(this.sectionId);
}

class LessonSession extends AbstractSession {
  @override
  bool get passed => score >= 80;

  @override
  int get xp => score >= 90 ? 100 : (score >= 80 ? 75 : 0);
}

class BossSession extends AbstractSession {
  @override
  bool get passed => score >= 85;

  @override
  int get xp => passed ? 100 : 0;
}