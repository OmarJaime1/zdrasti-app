import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/kuker_item_repository_service.dart';
import 'package:zdrasti_flutter/backend/service/kuker_provider.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/screens/settings_screen.dart';
import 'package:zdrasti_flutter/screens/kuker_customization_screen.dart';
import 'package:zdrasti_flutter/screens/welcome_screen.dart';
import 'package:zdrasti_flutter/backend/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:zdrasti_flutter/widgets/customize_kuker/static_kuker_renderer.dart';



class ProfileTab extends StatelessWidget {
  final local.User user;

  const ProfileTab({super.key, required this.user});

  void _resetPassword(BuildContext context) async {
    await AuthService.sendPasswordReset(user.email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset link sent to your email.')),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = user.name.split(' ').first;
    final kuker = context.watch<KukerProvider>().kuker;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Kuker Avatar (Tappable)
            GestureDetector(
              onTap: () async {
                final isOnline = await KukerItemRepository.isOnline();
                if (!isOnline) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You need internet to customize your Kuker.'),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KukerCustomizationScreen()),
                );
              },

              child: StaticKukerRenderer(kuker: kuker, size: 100),
            ),
            const SizedBox(height: 12),
            Text(
              'Welcome, $firstName!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Info card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow('Full Name', user.name),
                    _infoRow('CEFR Level', user.current_level),
                    _infoRow('XP Total', user.xp_total.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.lock_reset),
                      onPressed: () => _resetPassword(context),
                      label: const Text('Reset Password'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Certificate placeholder
            ElevatedButton.icon(
              icon: const Icon(Icons.school),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Certificate screen coming soon!')),
                );
              },
              label: const Text('View My Certificate'),
            ),
            const SizedBox(height: 8),

            // Settings
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen(user: user)),
                );
              },
              label: const Text('Settings'),
            ),
            const SizedBox(height: 32),

            // Logout
            TextButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Text(value),
        ],
      ),
    );
  }
}