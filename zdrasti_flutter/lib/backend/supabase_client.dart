import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const supabaseUrl = 'https://ygdxxfqfqrshvkvergzl.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlnZHh4ZnFmcXJzaHZrdmVyZ3psIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM3NTkzNTksImV4cCI6MjA1OTMzNTM1OX0.faD0xhq-T4jd4ukiaSW9AJuCEID8Cb_4utJtN1_3jCo';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}