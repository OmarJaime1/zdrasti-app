import 'package:flutter/material.dart';

class LessonScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onNext; // ✅ Make this nullable

  const LessonScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onNext, // ✅ Nullable constructor param
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: child),
            const SizedBox(height: 16),
            if (onNext != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: onNext, // ✅ Safe to call
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Next'),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}