import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/backend/supabase_client.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;

class UserService {
  static Future<void> createUser(local.User user) async {
    try {
      final response = await SupabaseService.client
          .from('users')
          .insert(user.toMap());

      debugPrint('✅ User created successfully. Supabase response: $response');
    } on PostgrestException catch (e, stack) {
      debugPrint('❌ Supabase error: ${e.message}');
      debugPrintStack(stackTrace: stack);
      rethrow;
    } catch (e, stack) {
      debugPrint('🔥 Unexpected error creating user: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  static Future<local.User?> fetchCurrentUser() async {
    final authUser = Supabase.instance.client.auth.currentUser;

    if (authUser == null) {
      debugPrint('⚠️ No auth user found. Returning null.');
      return null;
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (response == null) {
        debugPrint('❌ No matching user record found in users table.');
        return null;
      }

      final appUser = local.User.fromMap(response);
      debugPrint('✅ Loaded user from database: ${appUser.name} | Level: ${appUser.current_level}');
      return appUser;
    } catch (e) {
      debugPrint('❌ Error fetching user: $e');
      return null;
    }
  }

  /// Atomically increments XP for a user using Supabase RPC
  static Future<void> addXp(String userId, {required int amount}) async {
    try {
      await Supabase.instance.client.rpc('increment_user_xp', params: {
        'user_id_param': userId,
        'xp_to_add': amount,
      });
      debugPrint('✅ XP updated for user $userId (+$amount)');
    } catch (e) {
      debugPrint('❌ Failed to update XP: $e');
      rethrow;
    }
  }

  static Future<void> updateWritingAttemptTime(String userId) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      await Supabase.instance.client
        .from('users')
        .update({'last_writing_attempt': now})
        .eq('id', userId);

      debugPrint('📝 Updated last_writing_attempt for user $userId to $now');
    } catch (e) {
      debugPrint('❌ Failed to update writing attempt time for user $userId: $e');
    }
  }

  static Future<DateTime?> getLastWritingAttemptTime(String userId) async {
    try {
      final response = await Supabase.instance.client
        .from('users')
        .select('last_writing_attempt')
        .eq('id', userId)
        .maybeSingle();

      if (response == null) {
        debugPrint('⚠️ No user record found for $userId.');
        return null;
      }

      final raw = response['last_writing_attempt'];
      if (raw == null) {
        debugPrint('ℹ️ No last_writing_attempt recorded yet for $userId.');
        return null;
      }

      final parsed = DateTime.tryParse(raw);
      if (parsed == null) {
        debugPrint('❌ Failed to parse writing attempt timestamp for $userId: $raw');
      }

      return parsed;
    } catch (e) {
      debugPrint('❌ Error fetching writing attempt time for user $userId: $e');
      return null;
    }
  }

  static Future<bool> hasPassedBoss(String userId, String bossId) async {
    try {
      final response = await Supabase.instance.client
        .from('boss_results')
        .select('passed')
        .eq('user_id', userId)
        .eq('boss_id', bossId)
        .maybeSingle();

      final passed = response != null && response['passed'] == true;
      debugPrint('📦 Boss $bossId pass check for user $userId: $passed');
      return passed;
    } catch (e) {
      debugPrint('❌ Failed to check boss pass status for $bossId | $userId: $e');
      return false;
    }
  }

  static Future<void> saveBossPassStatus({
    required String userId,
    required String bossId,
    required bool passed,
    required bool xpAwarded,
  }) async {
    try {
      await Supabase.instance.client
        .from('boss_results')
        .upsert({
          'user_id': userId,
          'boss_id': bossId,
          'passed': passed,
          'xp_awarded': xpAwarded,
        });

      debugPrint('✅ Saved boss result for $bossId | $userId → passed: $passed, xp: $xpAwarded');
    } catch (e) {
      debugPrint('❌ Failed to save boss pass status for $bossId | $userId: $e');
    }
  }
}
