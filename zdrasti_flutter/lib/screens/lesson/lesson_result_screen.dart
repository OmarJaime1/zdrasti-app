
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/backend/service/xp_service.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/sessions.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/models/xp_breakdown.dart';
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';
import 'package:zdrasti_flutter/widgets/boss/offline_banner.dart';

class LessonResultScreen extends StatefulWidget {
  final Lesson lesson;
  final local.User user;
  final LessonSession session;

  const LessonResultScreen({
    super.key,
    required this.lesson,
    required this.user,
    required this.session,
  });

  @override
  State<LessonResultScreen> createState() => _LessonResultScreenState();
}

class _LessonResultScreenState extends State<LessonResultScreen> {
  late XpBreakdown _xpBreakdown;
  bool _passed = false;
  bool _alreadyCompleted = false;
  bool _loading = true;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _finalizeLesson();
  }

  Future<void> _finalizeLesson() async {
    final user = widget.user;
    final lesson = widget.lesson;
    final session = widget.session;

    final score = session.score;

    final xp = await XpService().awardXpForActivity(
      user: user,
      activityId: lesson.lessonId,
      score: score,
      type: ActivityType.lesson,
    );

    setState(() {
      _xpBreakdown = xp;
      _passed = session.passed;
      _alreadyCompleted = xp.total == 0 && session.passed;
      _loading = false;
    });

    if (xp.total > 0) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getSectionTitle(String id) {
    final cleanId = id.contains('_') ? id.split('_').last : id;

    const sectionKeys = {
      'grammar': 'lesson.grammarTitle',
      'listening': 'lesson.listeningTitle',
      'quiz': 'lesson.quizTitle',
      'roleplay': 'lesson.roleplayTitle',
    };

    final key = sectionKeys[cleanId];
    return key != null ? LocalizationService.getStaticText(key) : id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.getStaticText("lesson.resultTitle")),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const OfflineBanner(staticTextKey: 'banner.offlineXpPending'),
                const SizedBox(height: 32),
                if (_alreadyCompleted)
                  Text(LocalizationService.getStaticText("lesson.resultRepeat"),
                      style: const TextStyle(fontSize: 18, color: Colors.orange)),
                if (!_alreadyCompleted)
                  Text(
                    _passed
                        ? LocalizationService.getStaticText("lesson.resultPassed")
                        : LocalizationService.getStaticText("lesson.resultFailed"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _passed ? Colors.green : Colors.red,
                    ),
                  ),
                const SizedBox(height: 24),
                if (!_alreadyCompleted && _xpBreakdown.total > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${LocalizationService.getStaticText("lesson.xpEarned")} +${_xpBreakdown.total} XP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${LocalizationService.getStaticText("xp.base")} ${_xpBreakdown.baseXp}',
                        textAlign: TextAlign.center,
                      ),
                      if (_xpBreakdown.repeatXp > 0)
                        Text(
                          '${LocalizationService.getStaticText("xp.repeatBonus")} ${_xpBreakdown.repeatXp}',
                          textAlign: TextAlign.center,
                        ),
                      if (_xpBreakdown.streakXp > 0)
                        Text(
                          '${LocalizationService.getStaticText("xp.streakBonus")} ${_xpBreakdown.streakXp}',
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                  
                if (!_passed && widget.session.sectionStats.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Text(
                    LocalizationService.getStaticText("xp.sectionScores"),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.session.sectionStats.entries.map((entry) {
                      final sectionLabel = _getSectionTitle(entry.key);
                      final scoreText = '${entry.value.correct.toString().padLeft(3)} /${entry.value.total}';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              child: Text(
                                sectionLabel,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              scoreText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFeatures: [FontFeature.tabularFigures()],
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) =>
                              ZdrastiShell(user: widget.user)),
                    );
                  },
                  child: Text(LocalizationService.getStaticText("lesson.backToDashboard")),
                ),
              ],
            ),
    );
  }
}