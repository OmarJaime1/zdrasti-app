import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class TranslationBubble extends StatefulWidget {
  final String bulgarian;
  final String? nativeLanguage;
  final TextStyle? bulgarianTextStyle;
  final TextStyle? nativeTextStyle;
  final bool showTail;

  const TranslationBubble({
    super.key,
    required this.bulgarian,
    this.nativeLanguage,
    this.bulgarianTextStyle,
    this.nativeTextStyle,
    this.showTail = false,
  });

  @override
  State<TranslationBubble> createState() => _TranslationBubbleState();
}

class _TranslationBubbleState extends State<TranslationBubble> {
  bool showTranslation = false;

  @override
  Widget build(BuildContext context) {
    final hasTranslation = widget.nativeLanguage != null &&
        widget.nativeLanguage!.trim().isNotEmpty;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: widget.showTail
              ? const EdgeInsets.only(bottom: 10)
              : EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.bulgarian,
                style: widget.bulgarianTextStyle ??
                    const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              if (hasTranslation && showTranslation)
                Text(
                  widget.nativeLanguage!,
                  style: widget.nativeTextStyle ??
                      const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              if (hasTranslation)
                TextButton(
                  onPressed: () =>
                      setState(() => showTranslation = !showTranslation),
                  child: Text(
                    LocalizationService.getStaticText(
                      showTranslation
                          ? 'translation.hide'
                          : 'translation.show',
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.showTail)
          Positioned(
            bottom: 0,
            child: CustomPaint(
              painter: _BubbleTailPainter(color: Colors.white),
              child: const SizedBox(
                height: 12,
                width: 64,
              ),
            ),
          ),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;

  _BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2 - 6, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 6, 0);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 3, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
