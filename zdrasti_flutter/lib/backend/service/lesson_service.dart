import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/sessions.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;

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

  static Future<int> finalizeLessonResult({
    required local.User user,
    required Lesson lesson,
    required LessonSession session,
  }) async {
    final alreadyDone = await hasUserCompletedLesson(
      userId: user.id,
      lessonId: lesson.lessonId,
    );

    if (alreadyDone) return 0;

    await markLessonComplete(
      userId: user.id,
      lesson: lesson,
      score: session.score,
    );

    if (session.passed) {
      await UserService.addXp(user.id, amount: session.xp);
      return session.xp;
    }

    return 0;
  }
}