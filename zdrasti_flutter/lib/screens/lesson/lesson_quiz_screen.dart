import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/lessons/quiz_question_card.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_listening_screen.dart';

class LessonQuizScreen extends StatefulWidget {
  final Lesson lesson;
  final User user;

  const LessonQuizScreen({
    super.key,
    required this.lesson,
    required this.user,
  });

  @override
  State<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  final PageController _pageController = PageController();
  int _correct = 0;
  bool _quizFinished = false;
  int _currentPage = 0;

  void _handleAnswered(bool correct) {
    setState(() {
      if (correct) _correct++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      final isLast = _currentPage == widget.lesson.quiz.length - 1;
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonListeningScreen(
          lesson: widget.lesson,
          user: widget.user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.lesson.quiz.length;
    final passed = (_correct / total) >= 0.8;

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
                final question = widget.lesson.quiz[index];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
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
                    key: ValueKey('prompt'),
                    style: TextStyle(color: Colors.grey),
                  ),
          ),
        ],
      ),
    );
  }
}