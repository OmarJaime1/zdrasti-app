import 'package:flutter/material.dart';

class BossWritingSection extends StatefulWidget {
  final String prompt;
  final void Function(String userText) onSubmitted;

  const BossWritingSection({
    super.key,
    required this.prompt,
    required this.onSubmitted,
  });

  @override
  State<BossWritingSection> createState() => _BossWritingSectionState();
}

class _BossWritingSectionState extends State<BossWritingSection> {
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  void _confirmBeforeSubmit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Writing'),
        content: const Text(
          'You only get one writing attempt every 24 hours. Are you sure you want to submit this?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _submitting = true);
      widget.onSubmitted(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.prompt),
          const SizedBox(height: 20),

          // Fixed-height TextField with internal scroll
          Container(
            height: 180,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Scrollbar(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                enabled: !_submitting,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type your Bulgarian response here...',
                ),
                onChanged: (_) {
                  setState(() {}); // Triggers button enable/disable
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
          if (!_submitting)
            Center(
              child: ElevatedButton(
                onPressed: _controller.text.trim().isEmpty ? null : _confirmBeforeSubmit,
                child: const Text('Submit for Evaluation'),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
