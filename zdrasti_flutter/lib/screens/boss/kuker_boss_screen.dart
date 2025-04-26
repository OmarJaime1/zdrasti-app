import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/backend/boss_loader.dart';
import 'package:zdrasti_flutter/backend/lesson_loader.dart';
import 'package:zdrasti_flutter/backend/service/boss_writing_service.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:zdrasti_flutter/screens/boss/kuker_boss_result_screen.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_helpers.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_section_factory.dart';

class KukerBossScreen extends StatefulWidget {
  final KukerBoss boss;
  final User user;

  const KukerBossScreen({
    super.key,
    required this.boss,
    required this.user,
  });

  @override
  State<KukerBossScreen> createState() => _KukerBossScreenState();
}

class _KukerBossScreenState extends State<KukerBossScreen> {
  int _sectionIndex = 0;
  final Map<String, bool> _sectionResults = {};
  bool _writingUnlocked = false;
  bool _writingBlockedByCooldown = false;
  bool _hasLoadedCooldown = false;
  String? _gptExplanation;
  List<VocabularyWord>? _cachedVocab;

  bool _showResultOverlay = false;
  bool _lastSectionPassed = false;
  late String _kukerImagePath;

  @override
  void initState() {
    super.initState();
    _kukerImagePath = 'assets/images/kuker/kuker_boss_${widget.boss.level.toLowerCase()}.png';
    _loadWritingCooldown();
    _loadBossVocabulary();
  }

  Future<void> _loadBossVocabulary() async {
    final vocab = await LessonLoader.loadAllVocabForLevel(widget.boss.level);
    setState(() => _cachedVocab = vocab);
  }

  Future<void> _loadWritingCooldown() async {
    final lastAttempt = await UserService.getLastWritingAttemptTime(widget.user.id);
    _writingBlockedByCooldown = BossLoader.isWritingCooldownActive(lastAttempt);
    setState(() => _hasLoadedCooldown = true);
    _updateWritingUnlocked();
  }

  void _updateWritingUnlocked() {
    final passedCount = _sectionResults.values.where((v) => v).length;
    setState(() {
      _writingUnlocked =
          passedCount >= widget.boss.logic.requiredSectionsToPass && !_writingBlockedByCooldown;
    });
  }

  void _onSectionCompleted(bool passed) async {
    final section = widget.boss.sections[_sectionIndex];
    _sectionResults[section.id] = passed;
    _updateWritingUnlocked();

    setState(() {
      _lastSectionPassed = passed;
      _showResultOverlay = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _showResultOverlay = false);

    final isLast = _sectionIndex == widget.boss.sections.length - 1;
    if (isLast || (_isNextSectionWriting() && !_writingUnlocked)) {
      _goToResults();
    } else {
      setState(() => _sectionIndex++);
    }
  }

  bool _isNextSectionWriting() {
    if (_sectionIndex + 1 >= widget.boss.sections.length) return false;
    return widget.boss.sections[_sectionIndex + 1].type == 'text_input';
  }

  void _goToResults() {
    final writingSection = widget.boss.sections.firstWhere(
      (s) => s.type == 'text_input',
      orElse: () => KukerSection(id: '', title: '', kukerScript: '', type: ''),
    );

    final passedCount = _sectionResults.values.where((v) => v).length;
    final required = widget.boss.logic.requiredSectionsToPass;
    final passed = passedCount >= required && (_sectionResults[writingSection.id] ?? true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => KukerBossResultScreen(
          boss: widget.boss,
          user: widget.user,
          passed: passed,
          writingAttempted: _writingUnlocked,
          gptExplanation: _gptExplanation,
        ),
      ),
    );
  }

  Future<Widget> _buildSection() async {
    final section = widget.boss.sections[_sectionIndex];

    return BossSectionFactory.build(
      section: section,
      bossLevel: widget.boss.level,
      onCompleted: _onSectionCompleted,
      onWritingSubmitted: section.type == 'text_input'
          ? (userText) async {
              final result = await BossWritingService.evaluate(userText);
              await UserService.updateWritingAttemptTime(widget.user.id);
              _gptExplanation = result.explanation;
              _onSectionCompleted(result.passed);
            }
          : null,
      vocabOverride: _cachedVocab,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoadedCooldown || _cachedVocab == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final section = widget.boss.sections[_sectionIndex];
    final cooldownText = widget.user.last_writing_attempt == null
      ? 'Available now'
      : BossLoader.formatCooldownRemaining(widget.user.last_writing_attempt!);

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: LessonScaffold(
            key: ValueKey(_sectionIndex),
            title: section.title,
            child: Column(
              children: [
                if (!_writingUnlocked && _writingBlockedByCooldown)
                  BossSectionHelpers.practiceModeBanner(cooldownText),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: BossSectionHelpers.sectionTracker(
                    index: _sectionIndex,
                    total: widget.boss.sections.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [
                      TranslationBubble(
                        bulgarian: section.kukerScript,
                        nativeLanguage: '',
                        showTail: true,
                      ),
                      const SizedBox(height: 8),
                      Image.asset(_kukerImagePath, height: 120),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder<Widget>(
                    future: _buildSection(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return snapshot.data ?? const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showResultOverlay)
          BossSectionHelpers.feedbackOverlay(passed: _lastSectionPassed),
      ],
    );
  }
}