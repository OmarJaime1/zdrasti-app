import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/backend/service/audio/audio_service.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class VocabCard extends StatefulWidget {
  final VocabularyWord word;
  final bool allowReveal;


  const VocabCard({
    super.key,
    required this.word,
    this.allowReveal = true, // default to true for regular lessons
  });

  @override
  State<VocabCard> createState() => _VocabCardState();
}

class _VocabCardState extends State<VocabCard>
    with SingleTickerProviderStateMixin {
  bool _showTranslation = false;

  void _speakBulgarian() {
    AudioService.speak(widget.word.bg);
  }

  @override
  Widget build(BuildContext context) {
    final nativeTranslation =
        LocalizationService.getLocalizedText(widget.word.translation);

    return GestureDetector(
      onTap: () {
        if (!widget.allowReveal) return;
        setState(() => _showTranslation = !_showTranslation);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            final rotate = Tween(begin: pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder: (context, child) {
                final isUnder = ValueKey(_showTranslation) != child!.key;
                final rotationY = isUnder ? pi - rotate.value : rotate.value;
                return Transform(
                  transform: Matrix4.rotationY(rotationY),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: Container(
            key: ValueKey(_showTranslation),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: _showTranslation
                  ? Colors.deepPurple.shade100
                  : const Color(0xFFFDFBF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _showTranslation
                ? Center(
                    child: Text(
                      nativeTranslation,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.word.bg,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        tooltip: LocalizationService.getStaticText('tooltip.playPronunciation'),
                        splashRadius: 24,
                        onPressed: _speakBulgarian,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}