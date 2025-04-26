import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_quiz_screen.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonTipSlangScreen extends StatelessWidget {
  final Lesson lesson;
  final User user;

  const LessonTipSlangScreen({
    super.key,
    required this.lesson,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> tipMap = Map<String, String>.from(lesson.culturalTip['text']);
    final String localizedTip = LocalizationService.getLocalizedText(tipMap);

    final bool hasSlang = !user.safe_mode &&
        lesson.slang != null &&
        lesson.slang!['text'] != null &&
        (lesson.slang!['text'] as Map).isNotEmpty;

    final dynamic slangTextRaw = lesson.slang?['text'];
    final bool hasSlangText = slangTextRaw != null && slangTextRaw is Map<String, dynamic>;

    final Map<String, String> slangText = hasSlangText
        ? Map<String, String>.from(slangTextRaw)
        : {};

    final String localizedSlang = LocalizationService.getLocalizedText(slangText);

    final String slangRegion = hasSlang && lesson.slang!['region'] != null
        ? lesson.slang!['region']
        : 'Common';

    return LessonScaffold(
      title: 'Cultural Tip & Slang',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonQuizScreen(lesson: lesson, user: user),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🧠 Cultural Tip Bubble with Tail
          TranslationBubble(
            bulgarian: localizedTip,
            nativeLanguage: '',
            showTail: true,
          ),
          const SizedBox(height: 12),
          Image.asset(
            'assets/images/kuker/kuker_helper.png',
            height: 140,
          ),
          const SizedBox(height: 32),

          if (hasSlang) ...[
            Text(
              '$slangRegion Bulgarian Slang:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              localizedSlang,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }  
}