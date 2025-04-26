import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/models/user_settings.dart';

class UserSettingsService {
  static final _client = Supabase.instance.client;

  static Future<UserSettings?> fetchSettings(String userId) async {
    final response = await _client
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .single();

    // ignore: unnecessary_null_comparison
    if (response == null) return null;
    return UserSettings.fromMap(response);
  }

  static Future<void> saveSettings(String userId, UserSettings settings) async {
    await _client.from('user_settings').upsert({
      'user_id': userId,
      ...settings.toMap(),
    });
  }
}