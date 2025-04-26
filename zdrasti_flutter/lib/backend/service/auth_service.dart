import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _client = Supabase.instance.client;

  static Future<User?> signUpWithEmail(String email, String password) async {
    debugPrint('🟡 Attempting to sign up with email: $email');

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        debugPrint('✅ Sign up successful. User ID: ${user.id}');
        return user;
      }

      debugPrint('⚠️ Sign up response returned null user.');
      throw Exception('Signup returned null user');
    } on AuthException catch (e) {
      debugPrint('❌ Sign up failed: ${e.message}');
      throw Exception('Signup failed: ${e.message}');
    } catch (e) {
      debugPrint('🔥 Unknown sign up error: $e');
      throw Exception('Unknown signup error: $e');
    }
  }

  static Future<User?> signInWithEmail(String email, String password) async {
    debugPrint('🟡 Attempting to log in with email: $email');

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        debugPrint('✅ Login successful. User ID: ${user.id}');
        return user;
      }

      debugPrint('⚠️ Login response returned null user.');
      throw Exception('Login returned null user');
    } on AuthException catch (e) {
      debugPrint('❌ Login failed: ${e.message}');
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      debugPrint('🔥 Unknown login error: $e');
      throw Exception('Unknown login error: $e');
    }
  }

  static User? getCurrentUser() {
    final user = _client.auth.currentUser;
    debugPrint('👤 Current user: ${user?.email ?? 'None'}');
    return user;
  }

  static Future<void> signOut() async {
    debugPrint('🚪 Signing out...');
    await _client.auth.signOut();
    debugPrint('✅ Signed out completed.');
  }

  static Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      debugPrint('✅ Password reset email sent to $email');
    } catch (e) {
      debugPrint('❌ Failed to send password reset: $e');
      rethrow;
    }
  }
}