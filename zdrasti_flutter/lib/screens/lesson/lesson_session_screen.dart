import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/sessions.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/models/lesson_section.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_result_screen.dart';
import 'package:zdrasti_flutter/widgets/lessons/lesson_section_factory.dart';

class LessonSessionScreen extends StatefulWidget {
  final String lessonId;
  final List<LessonSection> sections;
  final Lesson lesson;
  final local.User user;

  const LessonSessionScreen({
    super.key,
    required this.lessonId,
    required this.sections,
    required this.lesson,
    required this.user,
  });

  @override
  State<LessonSessionScreen> createState() => _LessonSessionScreenState();
}

class _LessonSessionScreenState extends State<LessonSessionScreen> {
  int _sectionIndex = 0;
  final LessonSession _session = LessonSession();

  void _onSectionCompleted(bool passed, double score) {
    final section = widget.sections[_sectionIndex];

    if (section.isScored) {
      final correct = (score * 100).round();
      const total = 100;

      _session.recordSection(
        sectionId: section.id,
        correct: correct,
        total: total,
      );
    }

    final isLast = _sectionIndex == widget.sections.length - 1;

    if (isLast) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonResultScreen(
            lesson: widget.lesson,
            user: widget.user,
            session: _session,
          ),
        ),
      );
    } else {
      setState(() => _sectionIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.sections[_sectionIndex];
    final sectionWidget = LessonSectionFactory.build(
      section: section,
      onCompleted: _onSectionCompleted,
      user: widget.user,
    );

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: sectionWidget,
        ),
      ),
    );
  }
}