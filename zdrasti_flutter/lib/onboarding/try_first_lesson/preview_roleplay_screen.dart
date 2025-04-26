import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/onboarding/profile_setup/name_input_screen.dart';

class PreviewRoleplayScreen extends StatefulWidget {
  const PreviewRoleplayScreen({super.key});

  @override
  State<PreviewRoleplayScreen> createState() => _PreviewRoleplayScreenState();
}

class _PreviewRoleplayScreenState extends State<PreviewRoleplayScreen> {
  final TextEditingController _controller = TextEditingController();
  String? userResponse;
  bool showFeedback = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(
        title: const Text('Let’s Roleplay!'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kuker speech bubble
              const TranslationBubble(
                bulgarian: '„Добре дошли в магазина ми! Какво търсите?“',
                nativeLanguage: '“Welcome to my shop! What are you looking for?”',
              ),
              const SizedBox(height: 16),

              // Kuker shopkeeper image
              Image.asset(
                'assets/images/kuker/kuker_helper_shopkeeper.png',
                height: 180,
              ),

              const SizedBox(height: 24),

              // User input field
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Type your reply in Bulgarian...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    userResponse = _controller.text.trim();
                    showFeedback = true;
                  });
                },
                child: const Text('Submit'),
              ),

              const SizedBox(height: 24),

              if (showFeedback)
                Column(
                  children: [
                    const Text(
                      '🎉 Great job! That’s a useful phrase.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  //create intial user object
                  final user = local.User(
                    id: '', //set after auth in language selection
                    name: '', // set during name input
                    email: '', //set during login input
                    password: '', //set during login input
                    safe_mode: false, // set during age check
                    native_language: '', // set in language selection
                    current_level: 'A1', // 🧠 important: Try First Lesson default
                    xp_total: 0,
                    streak: 0,
                  );
                  // Navigate to name_input_screen to start profile set up flow
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NameInputScreen(user: user),
                    ),
                  );
                },
                child: const Text('Finish Onboarding'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}