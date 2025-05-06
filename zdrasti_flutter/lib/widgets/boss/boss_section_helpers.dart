import 'package:flutter/material.dart';

class BossSectionHelpers {
  static Widget sectionTracker({required int index, required int total}) {
    return Text(
      'Section ${index + 1} of $total',
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  static Widget practiceModeBanner(String cooldownRemaining) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.orangeAccent.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        'Practice Mode: Writing locked.\nAvailable in $cooldownRemaining',
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
    final prefix = isCorrect ? '✅ Correct' : '❌ Correct answer';

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

}
