import 'package:flutter/material.dart';

class GrammarExampleCard extends StatefulWidget {
  final String bulgarian;
  final String nativeLanguage;

  const GrammarExampleCard({
    super.key,
    required this.bulgarian,
    required this.nativeLanguage,
  });

  @override
  State<GrammarExampleCard> createState() => _GrammarExampleCardState();
}

class _GrammarExampleCardState extends State<GrammarExampleCard> {
  bool showTranslation = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => showTranslation = !showTranslation);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                widget.bulgarian,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Text(
                  widget.nativeLanguage,
                  style: const TextStyle(color: Colors.grey),
                ),
                crossFadeState: showTranslation
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}