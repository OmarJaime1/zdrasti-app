import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/onboarding/profile_setup/language_selection_screen.dart';
import 'package:zdrasti_flutter/models/user.dart';

class AgeCheckScreen extends StatefulWidget {
  final User user;
  const AgeCheckScreen({super.key, required this.user});

  @override
  State<AgeCheckScreen> createState() => _AgeCheckScreenState();
}

class _AgeCheckScreenState extends State<AgeCheckScreen> {
  bool? isMinor;

  @override
  Widget build(BuildContext context) {
    final bool safeMode = isMinor == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(title: const Text('Your Info')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Are you under 16 years old?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              const Text(
                'This helps us adjust content and activate Safe Mode for younger learners.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Kuker + speech bubble
              Column(
                children: [
                  if (isMinor != null)
                    TranslationBubble(
                      bulgarian: safeMode
                          ? 'Safe Mode has been activated to simplify content and keep things fun and safe!'
                          : 'You’re all set to continue.',
                      nativeLanguage: '',
                    ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/kuker/kuker_helper_shield.png',
                    height: 140,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              RadioListTile<bool>(
                value: true,
                groupValue: isMinor,
                onChanged: (val) => setState(() => isMinor = val),
                title: const Text("Yes, I’m under 16"),
              ),
              RadioListTile<bool>(
                value: false,
                groupValue: isMinor,
                onChanged: (val) => setState(() => isMinor = val),
                title: const Text("No, I’m 16 or older"),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: isMinor != null
                    ? () {
                        // TODO: Save safeMode flag to user profile
                        final bool safeMode = isMinor!;
                        widget.user.safe_mode = safeMode;
                        // Navigate to language selection screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LanguageSelectionScreen(user: widget.user)),
                        );
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
