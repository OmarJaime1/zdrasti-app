import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/lessons/quiz_question_card.dart';

class ListeningCard extends StatefulWidget {
  final ListeningSection section;
  final void Function(int correct, int total) onCompleted;

  const ListeningCard({
    super.key,
    required this.section,
    required this.onCompleted,
  });

  @override
  State<ListeningCard> createState() => _ListeningCardState();
}

class _ListeningCardState extends State<ListeningCard> {
  final FlutterTts _tts = FlutterTts();
  int _answeredCount = 0;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('bg-BG');
    _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _handleAnswer(bool correct) {
    setState(() {
      _answeredCount++;
      if (correct) _correctCount++;
    });

    if (_answeredCount == widget.section.questions.length) {
      widget.onCompleted(_correctCount, widget.section.questions.length);
    }
  }

  void _playScript() {
    _tts.stop();
    _tts.speak(widget.section.script);
  }

  @override
  Widget build(BuildContext context) {
    final script = widget.section.script;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Script box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  script,
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: 'Play Script',
                onPressed: _playScript,
              ),
            ],
          ),
        ),

        // Listening questions
        ...widget.section.questions.map(
          (q) => QuizQuestionCard(
            question: q,
            onAnswered: _handleAnswer,
          ),
        ),
      ],
    );
  }
}