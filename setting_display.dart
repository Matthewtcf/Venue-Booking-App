import 'package:flutter/material.dart';

import 'package:venuebookingsystem/main.dart';
import 'package:provider/provider.dart';
import 'setting_card.dart';

class Setting_display extends StatefulWidget {
  const Setting_display({Key? key}) : super(key: key);

  @override
  State<Setting_display> createState() => _Setting_displayState();
}

class _Setting_displayState extends State<Setting_display> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Select a theme:'),
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => DropdownButton(
              value: notifier.themeIndex,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem(
                  value: 0,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Green Light'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Green Dark'),
                ),
              ],
              onChanged: (value) {
                notifier.themeIndex = value!;
              },
            ),
          ),
        ],
      ),

    );
  }
}
