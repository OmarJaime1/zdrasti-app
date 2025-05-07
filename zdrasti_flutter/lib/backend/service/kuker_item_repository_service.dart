import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zdrasti_flutter/models/kuker_items.dart';

class KukerItemRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const _cacheKey = 'cached_kuker_items';

  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Load all KukerItems, from Supabase if online, or cache if offline
  Future<List<KukerItem>> loadItems() async {
    final online = await KukerItemRepository.isOnline();

    if (online) {
      try {
        final result = await _supabase.from('kuker_items').select();
        final items = result.map<KukerItem>((map) => KukerItem.fromMap(map)).toList();

        await _cacheItems(items); // store latest
        return items;
      } catch (e) {
        print('⚠️ Failed to load from Supabase: $e');
        return _loadFromCache();
      }
    } else {
      return _loadFromCache();
    }
  }

  Future<void> _cacheItems(List<KukerItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((i) => i.toMap()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  Future<List<KukerItem>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);

    if (jsonString == null) return [];

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map<KukerItem>((map) => KukerItem.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Helper: get items grouped by category
  Future<Map<String, List<KukerItem>>> loadGroupedByCategory() async {
    final all = await loadItems();
    final Map<String, List<KukerItem>> grouped = {};

    for (final item in all) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }
}
