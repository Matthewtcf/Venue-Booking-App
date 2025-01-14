import 'package:flutter/material.dart';
class TextPreset extends StatelessWidget {
  final TextStyle? textStyle;
  final String text;
  final Color color;

  const TextPreset({
    super.key,
    required this.text,
    required this.textStyle,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        text,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }
}

class CardTextPreset extends StatelessWidget {
  final TextStyle? textStyle;
  final String text;
  final Color color;

  const CardTextPreset({
    super.key,
    required this.text,
    required this.textStyle,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
      child: Text(
        text,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }
}
