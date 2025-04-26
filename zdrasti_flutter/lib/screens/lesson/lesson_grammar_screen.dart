import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/screens/lesson/lesson_tip_slang_screen.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';
import 'package:zdrasti_flutter/widgets/lesson_scaffold.dart';

class LessonGrammarScreen extends StatelessWidget {
  final Lesson lesson;
  final User user;

  const LessonGrammarScreen({
    super.key,
    required this.lesson,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final grammar = lesson.grammarTopic;
    final localizedTitle = LocalizationService.getLocalizedText(grammar.title);
    final localizedExplanation = LocalizationService.getLocalizedText(grammar.explanation);
    final usageTip = grammar.usageTip != null
        ? LocalizationService.getLocalizedText(grammar.usageTip!)
        : null;

    return LessonScaffold(
      title: 'Grammar',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonTipSlangScreen(lesson: lesson, user: user),
          ),
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              localizedTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Explanation
            Text(localizedExplanation),
            const SizedBox(height: 20),

            // 🧮 Table
            if (grammar.tableHeaders != null && grammar.tableRows != null)
              _buildGrammarTable(grammar),

            const SizedBox(height: 24),

            // ✍️ Grammar Examples
            if (grammar.examples != null && grammar.examples!.isNotEmpty) ...[
              const Text(
                'Examples:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...grammar.examples!.map((example) {
                final bg = example.bg;
                final translation = example.translation[user.native_language] ?? '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bg, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(translation, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),

            // 💡 Usage Tip
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

  Widget _buildGrammarTable(GrammarTopic grammar) {
    final headers = grammar.tableHeaders![user.native_language]!;
    final rows = grammar.tableRows!;

    TableRow buildHeaderRow() {
      return TableRow(
        decoration: const BoxDecoration(color: Color(0xFFEDE7F6)),
        children: headers.map((header) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      );
    }

    List<TableRow> buildDataRows() {
      return rows.map((row) {
        final paddedRow = List<String>.from(row);
        while (paddedRow.length < headers.length) {
          paddedRow.add('');
        }
        return TableRow(
          children: paddedRow.map((cell) {
            final cellText = _selectLocalizedRow(cell, user.native_language);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cellText),
            );
          }).toList(),
        );
      }).toList();
    }

    return Table(
      border: TableBorder.all(color: Colors.black26),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth()
      },
      children: [
        buildHeaderRow(),
        ...buildDataRows(),
      ],
    );
  }

  String _selectLocalizedRow(String rowText, String lang) {
    final parts = rowText.split(' / ');
    switch (lang) {
      case 'en':
        return parts[0];
      case 'es':
        return parts.length > 1 ? parts[1] : parts[0];
      case 'tr':
        return parts.length > 2 ? parts[2] : parts[0];
      default:
        return parts[0];
    }
  }
}