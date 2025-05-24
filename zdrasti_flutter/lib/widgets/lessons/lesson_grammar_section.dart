import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class LessonGrammarSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(bool passed, double score) onCompleted;

  const LessonGrammarSection({
    super.key,
    required this.data,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final GrammarTopic grammar = data['grammar'];
    final title = LocalizationService.getLocalizedText(grammar.title);
    final explanation = LocalizationService.getLocalizedText(grammar.explanation);
    final usageTip = grammar.usageTip != null
        ? LocalizationService.getLocalizedText(grammar.usageTip!)
        : null;

    return LessonScaffold(
      title: LocalizationService.getStaticText('lesson.grammarTitle'),
      onNext: () => onCompleted(true, 1.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(explanation),
            const SizedBox(height: 20),

            if (grammar.tableHeaders != null && grammar.tableRows != null)
              _buildTable(grammar),

            const SizedBox(height: 24),

            if (grammar.examples != null && grammar.examples!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationService.getStaticText('lesson.examplesLabel'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (final example in grammar.examples!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(example.bg, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            example.translation[LocalizationService.nativeLanguage] ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 24),

            if (usageTip != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(usageTip),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(GrammarTopic grammar) {
    final headers = grammar.tableHeaders![LocalizationService.nativeLanguage]!;
    final rows = grammar.tableRows!;

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEDE7F6)),
          children: headers.map((h) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }).toList(),
        ),
        for (final row in rows)
          TableRow(
            children: row.map((cell) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(cell),
              );
            }).toList(),
          ),
      ],
    );
  }
}