import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/onboarding/profile_setup/login_input_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final User user;

  const LanguageSelectionScreen({super.key, required this.user});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  final Map<String, String> languages = {
    'en': 'English',
    'es': 'Español',
    'tr': 'Türkçe',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(title: const Text('Your Info')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Choose your native language',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'We’ll use this language for all instructions and explanations.\nIt will also appear on your CEFR certificate.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: languages.entries.map((entry) {
                  final iso = entry.key;
                  final label = entry.value;
                  final isSelected = selectedLanguage == iso;

                  return GestureDetector(
                    onTap: () => setState(() => selectedLanguage = iso),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? Colors.deepPurple.shade100 : Colors.white,
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.deepPurple : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: selectedLanguage != null
                    ? () {
                        widget.user.native_language = selectedLanguage!;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginInputScreen(user: widget.user),
                          ),
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