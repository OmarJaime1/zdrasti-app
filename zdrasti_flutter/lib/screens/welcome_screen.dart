import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/onboarding/try_first_lesson/preview_vocab_screen.dart';
import 'package:zdrasti_flutter/widgets/login_dialog.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/kuker/kuker_helper.png',
                height: 180,
              ),
              const SizedBox(height: 20),

              const Text(
                'Добре дошли!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Zdrasti is your Bulgarian language guide',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PreviewVocabScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Try First Lesson'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  //TODO: Navigate to placement test screen
                },
                child: const Text('Take Placement Test (Coming Soon)'),
              ),

              const SizedBox(height: 24),

              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const LoginDialog(),
                  );
                },
                child: const Text("Already have an account? Log in"),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}