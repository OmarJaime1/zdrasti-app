import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class BossSectionHelpers {

    static Widget sectionTracker({required int index, required int total}) {
    final label = LocalizationService.getStaticText('boss.sectionTracker')
      .replaceAll('{current}', '${index + 1}')
      .replaceAll('{total}', '$total');

    return Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  static Widget practiceModeBanner(String cooldownRemaining) {
    final bannerText = LocalizationService.getStaticText('banner.practiceMode')
        .replaceAll('{cooldown}', cooldownRemaining);

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.orangeAccent.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        bannerText,
        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget feedbackOverlay({required bool passed}) {
    return Positioned.fill(
      child: Center(
        child: Icon(
          passed ? Icons.check_circle : Icons.cancel,
          size: 96,
          color: passed ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  static Widget answerFeedbackBox({
    required bool isCorrect,
    required String correctAnswer,
    String? label,
  }) {
    final color = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    final textColor = isCorrect ? Colors.green.shade800 : Colors.red.shade800;
    final prefix = isCorrect
      ? LocalizationService.getStaticText('feedback.correct')
      : LocalizationService.getStaticText('feedback.incorrect');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label != null ? '$prefix: $label' : '$prefix: $correctAnswer',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget inputField({
    required TextEditingController controller,
    required bool enabled,
    required String hint,
    EdgeInsets? margin,
  }) {
    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget confirmableSubmitButton({
    required ValueNotifier<String> notifier,
    required VoidCallback onPressed,
    required String label,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: notifier,
      builder: (context, text, _) {
        return ElevatedButton(
          onPressed: text.trim().isEmpty ? null : onPressed,
          child: Text(LocalizationService.getStaticText(label)),
        );
      },
    );
  }

  static Widget nextOrSubmitButton({
    required bool submitted,
    VoidCallback? onSubmit,
    required VoidCallback onNext,
    String submitLabel = 'button.submit',
    String nextLabel = 'button.next',
  }) {
    return ElevatedButton(
      onPressed: submitted ? onNext : (onSubmit ?? () {}),
      child: Text(LocalizationService.getStaticText(submitted ? nextLabel : submitLabel)),
    );
  } 
}
