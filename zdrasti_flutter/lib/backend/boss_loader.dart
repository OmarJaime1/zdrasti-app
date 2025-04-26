import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';

class BossLoader {
  static Future<KukerBoss> loadBossForLevel(String level) async {
    final path = 'assets/lessons/boss_${level.toLowerCase()}.json';
    print('[BossLoader] Trying to load boss from: $path');

    try {
      final rawJson = await rootBundle.loadString(path);
      print('[BossLoader] Successfully loaded raw JSON');
      final data = json.decode(rawJson);
      return KukerBoss.fromJson(data);
    } catch (e, stackTrace) {
      print('[BossLoader] ERROR: Could not load boss JSON from $path');
      print('Exception: $e');
      print(stackTrace);
      rethrow;
    }
  }


  static bool isWritingCooldownActive(DateTime? lastAttempt) {
    if (lastAttempt == null) return false;
    final now = DateTime.now().toUtc();
    return now.difference(lastAttempt).inHours < 24;
  }

  static String formatCooldownRemaining(DateTime lastAttempt) {
    final now = DateTime.now().toUtc();
    final remaining = Duration(hours: 24) - now.difference(lastAttempt);
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

}
