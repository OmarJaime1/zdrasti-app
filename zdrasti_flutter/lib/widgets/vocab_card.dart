import 'package:flutter/material.dart';

class VocabCard extends StatelessWidget {
  final String word;
  final String imagePath;

  const VocabCard({
    super.key,
    required this.word,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(imagePath, height: 60),
            const SizedBox(width: 16),
            Text(
              word,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // Placeholder for audio pronunciation
              },
              icon: const Icon(Icons.volume_up),
            )
          ],
        ),
      ),
    );
  }
}