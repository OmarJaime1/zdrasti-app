import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/models/lesson.dart';

class LessonService {
  static final _client = Supabase.instance.client;

  /// Check if this user has already completed this lesson
  static Future<bool> hasUserCompletedLesson({
    required String userId,
    required String lessonId,
  }) async {
    final response = await _client
        .from('lessons')
        .select('id')
        .eq('user_id', userId)
        .eq('lesson_id', lessonId)
        .eq('completed', true)
        .maybeSingle();

    return response != null;
  }

  /// Mark lesson complete in DB
  static Future<void> markLessonComplete({
    required String userId,
    required Lesson lesson,
    required int score,
  }) async {
    final isFlawless = score == 100;

    await _client.from('lessons').insert({
      'user_id': userId,
      'lesson_id': lesson.lessonId,
      'level': lesson.cefrLevel,
      'score': score,
      'completed': true,
      'flawless': isFlawless,
    });
  }

  /// Get list of completed lesson IDs for a user
  static Future<List<String>> getCompletedLessonIds(String userId) async {
    final response = await _client
        .from('lessons')
        .select('lesson_id')
        .eq('user_id', userId)
        .eq('completed', true);

    // ignore: unnecessary_null_comparison
    if (response == null || response.isEmpty) return [];

    return List<String>.from(response.map((row) => row['lesson_id']));
  }
}