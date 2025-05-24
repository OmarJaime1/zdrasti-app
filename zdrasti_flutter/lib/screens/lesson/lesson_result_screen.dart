import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/backend/service/lesson_service.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/sessions.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';
import 'package:zdrasti_flutter/widgets/boss/offline_banner.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';

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
  bool _loading = true;
  bool _alreadyCompleted = false;
  bool _passed = true;
  int _xpEarned = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _finalizeLesson();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _finalizeLesson() async {
    try {
      final xp = await LessonService.finalizeLessonResult(
        user: widget.user,
        lesson: widget.lesson,
        session: widget.session,
      );

      setState(() {
        _xpEarned = xp;
        _passed = widget.session.passed;
        _alreadyCompleted = xp == 0 && widget.session.passed;
        _loading = false;
      });

      if (xp > 0) {
        _confettiController.play();
      }
    } catch (e) {
      debugPrint('❌ Error finalizing lesson: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultText = _passed
      ? _alreadyCompleted
          ? LocalizationService.getStaticText('lesson.resultRepeat')
          : LocalizationService.getStaticText('lesson.resultFirstTime')
      : LocalizationService.getStaticText('lesson.resultTryAgain');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(
        title: Text(LocalizationService.getStaticText('lesson.resultTitle')),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: Column (
              children: [
                const OfflineBanner(staticTextKey: 'banner.offlineXpPending'),
                Expanded(
                  child: Stack(
                  children: 
                  [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          emissionFrequency: 0.05,
                          numberOfParticles: 40,
                          gravity: 0.4,
                          maxBlastForce: 25,
                          minBlastForce: 5,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TranslationBubble(
                              bulgarian: resultText,
                              nativeLanguage: '',
                              showTail: true,
                            ),
                            const SizedBox(height: 12),
                            Image.asset(
                              'assets/images/kuker/kuker_helper.png',
                              height: 120,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _passed
                                ? LocalizationService.getStaticText('lesson.resultPassed')
                                : LocalizationService.getStaticText('lesson.resultFailed'),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _passed ? Colors.green : Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            if (_xpEarned > 0)
                              Text(
                                '+$_xpEarned ${LocalizationService.getStaticText('lesson.xpEarned')}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ZdrastiShell(user: widget.user),
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  LocalizationService.getStaticText('lesson.backToDashboard'),
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                )
            ],)
          ),
    );
  }
}