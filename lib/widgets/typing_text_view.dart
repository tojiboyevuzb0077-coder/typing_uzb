import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypingTextView extends StatelessWidget {
  final String text;
  final int currentIndex;
  final List<bool?> typedResults; // true = correct, false = wrong, null = untyped
  final double fontSize;

  const TypingTextView({
    super.key,
    required this.text,
    required this.currentIndex,
    required this.typedResults,
    this.fontSize = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<InlineSpan> spans = [];

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final isCurrent = i == currentIndex;
      final result = i < typedResults.length ? typedResults[i] : null;

      Color? textColor;
      Color? bgColor;
      TextDecoration decoration = TextDecoration.none;

      if (result == true) {
        textColor = Colors.green;
      } else if (result == false) {
        textColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.2);
        decoration = TextDecoration.underline;
      } else {
        textColor = isDark ? Colors.white70 : Colors.black87;
      }

      if (isCurrent) {
        bgColor = theme.colorScheme.primary.withOpacity(0.3);
        textColor = theme.colorScheme.primary;
        decoration = TextDecoration.underline;
      }

      spans.add(
        TextSpan(
          text: char == ' ' ? ' ' : char,
          style: GoogleFonts.jetBrainsMono(
            fontSize: fontSize,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: textColor,
            backgroundColor: bgColor,
            decoration: decoration,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: SelectableText.rich(
        TextSpan(children: spans),
        textAlign: TextAlign.left,
      ),
    );
  }
}
