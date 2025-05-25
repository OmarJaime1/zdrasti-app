import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/models/xp_breakdown.dart';

enum ActivityType { lesson, boss }

class XpService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<XpBreakdown> awardXpForActivity({
    required local.User user,
    required String activityId,
    required int score,
    required ActivityType type,
  }) async {
    final now = DateTime.now();
    final todayKey = now.day.toString();
    final monthKey = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    // 1. Check first-time and repeat status
    final isFirstTime = await isFirstTimePass(
      userId: user.id,
      activityId: activityId,
      type: type,
    );

    final alreadyRepeated = await alreadyRepeatedToday(
      userId: user.id,
      activityId: activityId,
      type: type,
    );

    final repeatTodayXp = await repeatXpToday(userId: user.id);

    // 2. Base XP per type
    final baseXpForType = (type == ActivityType.lesson) ? 50 : 150;

    int baseXp = 0;
    int repeatXp = 0;
    int streakXp = 0;

    if (isFirstTime) {
      baseXp = baseXpForType;
    } else if (score >= 90 && !alreadyRepeated && repeatTodayXp < 10) {
      repeatXp = 3;
    }

    final hasActivityToday = user.last_activity_date != null &&
        user.last_activity_date!.year == now.year &&
        user.last_activity_date!.month == now.month &&
        user.last_activity_date!.day == now.day;

    if (!hasActivityToday) {
      streakXp = _computeStreakBonus(user.streak ?? 0);
    }

    final totalXp = baseXp + repeatXp + streakXp;
    Map<String, dynamic> xpByDay = {};

    try {
      final response = await _client
          .from('user_xp_monthly')
          .select('xp_by_day')
          .eq('user_id', user.id)
          .eq('month_year', monthKey)
          .maybeSingle();

      if (response == null) {
        debugPrint('⚠️ No XP record found for $monthKey — creating empty.');
        await _client.from('user_xp_monthly').insert({
          'user_id': user.id,
          'month_year': monthKey,
          'xp_by_day': {},
        });
      } else if (response['xp_by_day'] != null) {
        xpByDay = Map<String, dynamic>.from(response['xp_by_day']);
      }
    } catch (e) {
      debugPrint('❌ Error fetching user_xp_monthly: $e');
    }

    try {
      final currentDay = Map<String, dynamic>.from(xpByDay[todayKey] ?? {});
      if (baseXp > 0) currentDay['base'] = baseXp;
      if (repeatXp > 0) currentDay['repeat'] = repeatXp;
      if (streakXp > 0) currentDay['streak'] = streakXp;
      xpByDay[todayKey] = currentDay;

      await _client
          .from('user_xp_monthly')
          .upsert({
            'user_id': user.id,
            'month_year': monthKey,
            'xp_by_day': xpByDay,
          })
          .eq('user_id', user.id)
          .eq('month_year', monthKey);
    } catch (e) {
      debugPrint('❌ Error writing XP JSON for $monthKey: $e');
    }

    try {
      final updatedXp = (user.xp_total ?? 0) + totalXp;
      final updates = {
        'xp_total': updatedXp,
        'last_activity_date': now.toIso8601String(),
      };

      await _client.from('users').update(updates).eq('id', user.id);
    } catch (e) {
      debugPrint('❌ Error updating user: $e');
    }

    return XpBreakdown(
      baseXp: baseXp,
      repeatXp: repeatXp,
      streakXp: streakXp,
    );
  }

  Future<bool> isFirstTimePass({
    required String userId,
    required String activityId,
    required ActivityType type,
  }) async {
    try {
      if (type == ActivityType.lesson) {
        final res = await _client
            .from('lessons')
            .select('id')
            .eq('user_id', userId)
            .eq('lesson_id', activityId)
            .eq('completed', true)
            .limit(1)
            .maybeSingle();

        return res == null;
      } else {
        final res = await _client
            .from('boss_results')
            .select('xp_awarded')
            .eq('user_id', userId)
            .eq('boss_id', activityId)
            .limit(1)
            .maybeSingle();

        return res == null || res['xp_awarded'] != true;
      }
    } catch (e) {
      debugPrint('❌ isFirstTimePass error: $e');
      return false;
    }
  }

  Future<bool> alreadyRepeatedToday({
    required String userId,
    required String activityId,
    required ActivityType type,
  }) async {
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD

    try {
      if (type == ActivityType.lesson) {
        final res = await _client
            .from('lessons')
            .select('id')
            .eq('user_id', userId)
            .eq('lesson_id', activityId)
            .gte('created_at', today)
            .limit(1)
            .maybeSingle();

        return res != null;
      } else {
        final res = await _client
            .from('boss_results')
            .select('boss_id')
            .eq('user_id', userId)
            .eq('boss_id', activityId)
            .gte('updated_at', today)
            .limit(1)
            .maybeSingle();

        return res != null;
      }
    } catch (e) {
      debugPrint('❌ alreadyRepeatedToday error: $e');
      return false;
    }
  }

  Future<int> repeatXpToday({ required String userId }) async {
    final today = DateTime.now();
    final monthKey = "${today.year}-${today.month.toString().padLeft(2, '0')}";
    final dayKey = today.day.toString();

    try {
      final res = await _client
          .from('user_xp_monthly')
          .select('xp_by_day')
          .eq('user_id', userId)
          .eq('month_year', monthKey)
          .maybeSingle();

      if (res != null && res['xp_by_day'] != null) {
        final xpMap = Map<String, dynamic>.from(res['xp_by_day']);
        final day = Map<String, dynamic>.from(xpMap[dayKey] ?? {});
        return (day['repeat'] ?? 0) as int;
      }
    } catch (e) {
      debugPrint('❌ repeatXpToday error: $e');
    }

    return 0;
  }

  int _computeStreakBonus(int streak) {
    if (streak >= 30) return 40;
    if (streak >= 20) return 30;
    if (streak >= 10) return 20;
    if (streak >= 5) return 10;
    if (streak >= 3) return 5;
    return 0;
  }
}