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
}
