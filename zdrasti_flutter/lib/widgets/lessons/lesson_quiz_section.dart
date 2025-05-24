import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/lessons/quiz_question_card.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonQuizSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;

  const LessonQuizSection({
    super.key,
    required this.data,
    required this.onCompleted,
  });

  @override
  State<LessonQuizSection> createState() => _LessonQuizSectionState();
}

class _LessonQuizSectionState extends State<LessonQuizSection> {
  late final List<QuizQuestion> _questions;
  final PageController _pageController = PageController();
  int _correct = 0;
  int _currentPage = 0;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    _questions = List<QuizQuestion>.from(widget.data['quiz']);
  }

  void _handleAnswered(bool correct) {
    if (correct) _correct++;

    Future.delayed(const Duration(seconds: 2), () {
      final isLast = _currentPage == _questions.length - 1;
      if (!isLast && mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else if (mounted) {
        setState(() => _quizFinished = true);
      }
    });
  }

  void _handleFinish() {
    final total = _questions.length;
    final score = total == 0 ? 0.0 : _correct / total;
    final passed = score >= 0.8;
    widget.onCompleted(passed, score);
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final passed = total == 0 ? false : (_correct / total) >= 0.8;

    return LessonScaffold(
      title: LocalizationService.getStaticText('lesson.quizTitle'),
      onNext: _quizFinished ? _handleFinish : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              LocalizationService.getStaticText('lesson.questionProgress')
                .replaceAll('{current}', '${_currentPage + 1}')
                .replaceAll('{total}', '$total'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: total,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final offset = Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return SlideTransition(
                      position: offset,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Padding(
                    key: ValueKey(index),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: QuizQuestionCard(
                      question: question,
                      onAnswered: _handleAnswered,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _quizFinished
                ? Column(
                    key: const ValueKey('result'),
                    children: [
                      Text(
                        LocalizationService.getStaticText('lesson.quizScore')
                          .replaceAll('{correct}', '$_correct')
                          .replaceAll('{total}', '$total'),
                        style: TextStyle(
                          fontSize: 16,
                          color: passed ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        passed
                            ? LocalizationService.getStaticText('lesson.quizPassed')
                            : LocalizationService.getStaticText('lesson.quizFailed'),
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text(
                    LocalizationService.getStaticText('lesson.quizPrompt'),
                    key: const ValueKey('prompt'),
                    style: const TextStyle(color: Colors.grey),
                  ),
          ),
        ],
      ),
    );
  }
}