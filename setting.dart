import 'package:flutter/material.dart';
import 'package:venuebookingsystem/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:provider/provider.dart';
import 'setting_card.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _textPreset(String text, TextStyle? textStyle, Color? color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Text(
        text,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () {
        signOut;
      },
      child: const Text('sign out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
              child: _textPreset('Settings', textTheme.displaySmall,
                  themeNotifier.colorScheme.onBackground),
            ),
            SettingCard(),
          ],
        ),
      ),
    );
  }
}
