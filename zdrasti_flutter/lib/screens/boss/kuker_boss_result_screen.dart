import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:confetti/confetti.dart';

class KukerBossResultScreen extends StatefulWidget {
  final KukerBoss boss;
  final User user;
  final bool passed;
  final bool writingAttempted;
  final String? gptExplanation;
  final Map<String, double> sectionScores;
  final Map<String, bool> sectionPasses;

  const KukerBossResultScreen({
    super.key,
    required this.boss,
    required this.user,
    required this.passed,
    required this.writingAttempted,
    this.gptExplanation,
    required this.sectionScores,
    required this.sectionPasses,
  });

  @override
  State<KukerBossResultScreen> createState() => _KukerBossResultScreenState();
}

class _KukerBossResultScreenState extends State<KukerBossResultScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 4));

    _handleXpAndProgress();
    _startAutoRedirect();

    if (widget.passed) {
      _confetti.play();
    }
  }

  Future<void> _handleXpAndProgress() async {
    final hasAlreadyPassed =
        await UserService.hasPassedBoss(widget.user.id, widget.boss.bossId);

    if (!hasAlreadyPassed && widget.passed) {
      await UserService.addXp(widget.user.id, amount: 75);
      await UserService.saveBossPassStatus(
        userId: widget.user.id,
        bossId: widget.boss.bossId,
        passed: true,
        xpAwarded: true,
      );
    } else {
      await UserService.saveBossPassStatus(
        userId: widget.user.id,
        bossId: widget.boss.bossId,
        passed: widget.passed,
        xpAwarded: hasAlreadyPassed,
      );
    }
  }

  void _startAutoRedirect() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ZdrastiShell(user: widget.user),
        ),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🧠 Determine which script to show
    final script = widget.passed
        ? widget.boss.finalScript.pass
        : widget.writingAttempted
            ? widget.boss.finalScript.failWritting
            : widget.boss.finalScript.failSections;

    final kukerImagePath =
        'assets/images/kuker/kuker_boss_${widget.boss.level.toLowerCase()}.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TranslationBubble(
                      bulgarian: script,
                      nativeLanguage: '',
                      showTail: true,
                    ),
                    const SizedBox(height: 12),
                    Image.asset(kukerImagePath, height: 160),

                    const SizedBox(height: 16),
                    _buildScoreSummary(),

                    // GPT Feedback (if writing failed)
                    if (!widget.passed && widget.writingAttempted && widget.gptExplanation != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            const Text(
                              'Why your writing didn’t pass:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.gptExplanation!,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Confetti on pass
          if (widget.passed)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                maxBlastForce: 20,
                minBlastForce: 10,
                numberOfParticles: 30,
                emissionFrequency: 0.1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreSummary() {
    final sections = widget.boss.sections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your performance:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final section in sections)
          _buildScoreTile(
            LocalizationService.getLocalizedText(section.title),
            section.type == 'text_input'
                ? (widget.writingAttempted
                    ? (widget.passed ? '✅ Passed' : '❌ Failed')
                    : '—')
                : _formatScore(section),
          ),
      ],
    );
  }

  String _formatScore(KukerSection section) {
    final score = widget.sectionScores[section.id];
    final passed = widget.sectionPasses[section.id];

    if (score == null) return '—';
    final percent = (score * 100).round();
    final emoji = passed == true ? '✅' : '❌';
    return '$emoji $percent%';
  }

  Widget _buildScoreTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}