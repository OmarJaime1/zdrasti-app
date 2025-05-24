import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';

class LessonTipSlangSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;
  final User user;

  const LessonTipSlangSection({
    super.key,
    required this.data,
    required this.onCompleted,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    final dynamic culturalTipRaw = data['culturalTip'];
    final Map<String, dynamic>? culturalTip =
        culturalTipRaw is Map<String, dynamic> ? culturalTipRaw : null;

    final String localizedTip = (culturalTip != null && culturalTip['text'] is Map)
        ? LocalizationService.getLocalizedText(
            Map<String, String>.from(culturalTip['text']),
          )
        : '';

    final Map<String, dynamic>? slang = data['slang'];
    final bool showSlang = !user.safe_mode && slang != null && slang['text'] != null;

    final String localizedSlang = showSlang
        ? LocalizationService.getLocalizedText(
            Map<String, String>.from(slang['text']),
          )
        : '';

    final String slangRegion = showSlang && slang['region'] != null
        ? slang['region']
        : LocalizationService.getStaticText('lesson.slangRegionCommon');

    return LessonScaffold(
      title: LocalizationService.getStaticText('lesson.tipSlangTitle'),
      onNext: () => onCompleted(true, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (localizedTip.isNotEmpty)
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
          if (showSlang) ...[
            Text(
              LocalizationService.getStaticText('lesson.slangLabel')
                  .replaceAll('{region}', slangRegion),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                localizedSlang,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
