import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:provider/provider.dart';

class SettingCard extends StatefulWidget {
  @override
  _SettingCardState createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  Widget _textPreset(String text, TextStyle? textStyle, Color? color , double top , double bottom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, top , 8, bottom),
      child: Text(
        text,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }

  Widget _settingRow(String title, String info, TextStyle? titleStyle,
      TextStyle? infoStyle, Color? color,IconData icon) {
    return Container(
        child: InkWell(
      onTap: () {Navigator.pushNamed(context, '/setting_display');},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row( children: [
          Expanded(
            flex: 15,
            child: Icon(icon),
          ),
          Expanded(
              flex: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textPreset(title, titleStyle, color , 8 ,0),
                  _textPreset(info, infoStyle, color ,0 , 8)
                ],
              )),
        ]),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      child: Column(
        children: [
          _settingRow('Display', 'theme,dark mode', textTheme.titleLarge, textTheme.bodyMedium,
              themeNotifier.colorScheme.onBackground,Icons.display_settings),
          _settingRow('Log out', 'Account logout', textTheme.titleLarge, textTheme.bodyMedium,
              themeNotifier.colorScheme.onBackground,Icons.logout),
          _settingRow('Other setting', 'about other setting', textTheme.titleLarge, textTheme.bodyMedium,
              themeNotifier.colorScheme.onBackground,Icons.settings),
        ],
      ),
    );
  }
}
