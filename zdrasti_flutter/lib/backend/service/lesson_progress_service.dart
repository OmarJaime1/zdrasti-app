import 'package:supabase_flutter/supabase_flutter.dart';

class LessonProgressService {
  static final _client = Supabase.instance.client;

  // Fetch all completed lesson IDs for the current user
  static Future<List<String>> fetchCompletedLessonIds(String userId) async {
    final response = await _client
        .from('lessons')
        .select('lesson_id')
        .eq('user_id', userId)
        .eq('completed', true);

    // ignore: unnecessary_null_comparison
    if (response == null || response.isEmpty) return [];
    return response.map<String>((row) => row['lesson_id'] as String).toList();
  }

  // Mark a lesson as completed
  static Future<void> markLessonCompleted(String userId, String lessonId, String level) async {
    await _client.from('lessons').upsert({
      'user_id': userId,
      'lesson_id': lessonId,
      'level': level,
      'completed': true,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Optional: Fetch all lesson progress data
  static Future<List<Map<String, dynamic>>> fetchAllProgress(String userId) async {
    final response = await _client
        .from('lessons')
        .select()
        .eq('user_id', userId);

    return response.map((r) => r).toList();
  }
}