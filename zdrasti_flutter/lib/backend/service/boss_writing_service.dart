class BossWritingService {
  static bool useMockChatGpt = true;

  static Future<WritingEvaluationResult> evaluate(String userText) async {
    if (useMockChatGpt) {
      return _mockEvaluate(userText);
    } else {
      return await _callRealBackend(userText);
    }
  }

  static WritingEvaluationResult _mockEvaluate(String userText) {
    final sentenceCount =
        userText.split(RegExp(r'[.!?]')).where((s) => s.trim().isNotEmpty).length;

    final passed = sentenceCount >= 3;
    final explanation = passed
        ? '✅ Pass: Writing meets A1 requirements.'
        : '❌ Fail: You wrote fewer than 3 complete sentences.';

    return WritingEvaluationResult(passed: passed, explanation: explanation);
  }

  static Future<WritingEvaluationResult> _callRealBackend(String userText) async {
    // TODO: Implement actual HTTP call to backend when ready
    throw UnimplementedError('Real GPT evaluation not implemented yet.');
  }
}

class WritingEvaluationResult {
  final bool passed;
  final String explanation;

  WritingEvaluationResult({required this.passed, required this.explanation});
}
