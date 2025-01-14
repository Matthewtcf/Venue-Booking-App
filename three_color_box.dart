

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../text_preset.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/main.dart';
class ColorBox extends StatelessWidget {
  const ColorBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ColorBox(text: 'Pending', color: themeNotifier.colorScheme.tertiary),
          _ColorBox(text: 'Approved', color: themeNotifier.colorScheme.primary),
          _ColorBox(text: 'Rejected', color: themeNotifier.colorScheme.error)

        ],
      ),
    );
  }
}



class _ColorBox extends StatelessWidget {

  final String text;
  final Color color;

  const _ColorBox({
    super.key,
    required this.text,

    required this.color
  });



  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        TextPreset(text: '$text', textStyle: textTheme.labelSmall, color: themeNotifier.colorScheme.onSurface)
      ],
    );
  }
}
