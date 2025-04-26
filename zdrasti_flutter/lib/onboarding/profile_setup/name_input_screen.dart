import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/onboarding/profile_setup/age_check_screen.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:zdrasti_flutter/models/user.dart';

class NameInputScreen extends StatefulWidget {
  final User user;

  const NameInputScreen({super.key, required this.user});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  static const String successMessage = 'Looks great! Your name will appear on your certificate.';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool isValidFullName(String name) {
    return getValidationMessage(name) == successMessage;
  }

  String? getValidationMessage(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) return null;

    if (trimmed.length < 5) {
      return 'That seems too short. Include your full name.';
    }

    final parts = trimmed.split(' ');
    if (parts.length < 2 || parts.any((p) => p.isEmpty)) {
      return 'Tip: Please enter both your first and last name.';
    }

    final validChars = RegExp(r"^[a-zA-Zа-яА-Я\s'-]+$").hasMatch(trimmed);
    if (!validChars) {
      return 'Names should only include letters, spaces, dashes, or apostrophes.';
    }

    return successMessage;
  }


  @override
  Widget build(BuildContext context) {
    final name = _nameController.text;
    final isValid = isValidFullName(name);
    final validationMessage = getValidationMessage(name);

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
                'What’s your full name?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Kuker + reactive bubble
              Column(
                children: [
                  if (name.trim().isNotEmpty)
                  TranslationBubble(
                    bulgarian: validationMessage!,
                    nativeLanguage: '', // disables show translation feature
                    bulgarianTextStyle: validationMessage == successMessage
                        ? const TextStyle(fontSize: 16, color: Colors.green)
                        : const TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/kuker/kuker_helper.png',
                    height: 140,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Text input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g. Ivan Petrov',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Your full name will appear on your CEFR certificate and cannot be changed later.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Continue button
              ElevatedButton(
                onPressed: isValid
                    ? () {
                      //Set the profile name to object
                      widget.user.name = _nameController.text.trim();
                      // Navigate to age_check_screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AgeCheckScreen(user: widget.user)),
                      );
                    }
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}