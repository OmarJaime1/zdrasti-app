import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/models/kuker_data.dart';

class KukerRepository {
  final SupabaseClient _supabase;

  KukerRepository({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser!.id;
  static const _cachedKey = 'cached_kuker_data';

  /// Load the Kuker customization for the current user
  Future<KukerData?> loadKuker() async {
    try {
      final result = await _supabase
          .from('kuker_customization')
          .select()
          .eq('user_id', _userId)
          .maybeSingle();

      if (result != null) {
        print('[KukerRepository] Kuker loaded from Supabase.');
        final kuker = KukerData.fromMap(result);
        await _cacheKuker(kuker);
        return kuker;
      } else {
        print('[KukerRepository] No Kuker found in Supabase.');
      }
    } catch (e) {
      print('[KukerRepository] ERROR loading from Supabase: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cachedKey);
    if (json != null) {
      try {
        final map = jsonDecode(json);
        print('[KukerRepository] Kuker loaded from cache.');
        return KukerData.fromMap(map);
      } catch (e) {
        print('[KukerRepository] Failed to parse cached Kuker: $e');
      }
    } else {
      print('[KukerRepository] No Kuker found in cache.');
    }

    return null;
  }

  /// Save the Kuker customization for the current user
  Future<void> saveKuker(KukerData kuker) async {
    await _supabase.from('kuker_customization').upsert({
      'user_id': _userId,
      'mask': kuker.mask,
      'horns': kuker.horns,
      'costume': kuker.costume,
      'accessory': kuker.accessory,
      'expression': kuker.expression,
      'shoes': kuker.shoes,
    });

    await _cacheKuker(kuker); // ✅ also save to local cache
    print('[KukerRepository] Kuker saved successfully.');
  }

  Future<void> _cacheKuker(KukerData kuker) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(kuker.toMap());
    await prefs.setString(_cachedKey, json);
    print('[KukerRepository] Cached Kuker locally.');
  }

  /// Get list of unlocked item IDs for the current user
  Future<List<String>> getUnlockedItems() async {
    final result = await _supabase
        .from('unlocked_items')
        .select('item_id')
        .eq('user_id', _userId);

    if (result.isEmpty) {
      final defaults = ['mask_01', 'horns_01', 'costume_01', 'neutral', 'none', 'none'];
      await _supabase.from('unlocked_items').insert(
        defaults.map((id) => {'user_id': _userId, 'item_id': id}).toList(),
      );
      return defaults;
    }

    return result.map<String>((row) => row['item_id'] as String).toList();
  }

}
