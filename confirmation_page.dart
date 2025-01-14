import 'package:flutter/services.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/pages/Booking/booking.dart';
import 'package:venuebookingsystem/pages/Confirmation/confirm_request_card.dart';

import 'package:venuebookingsystem/pages/Home/home_page.dart';
import 'package:venuebookingsystem/nav_page.dart';
import 'package:venuebookingsystem/pages/Confirmation/past_request_card.dart';
import 'package:venuebookingsystem/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venuebookingsystem/pages/Settings/setting.dart';
import 'package:provider/provider.dart';
import 'package:venuebookingsystem/pages/Settings/setting_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../text_preset.dart';
import 'current_request_card.dart';

class ConfirmationPage extends StatefulWidget {
  ConfirmationPage({Key? key}) : super(key: key);

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPreset(
                    text: 'Pending requests',
                    color: themeNotifier.colorScheme.onSurface,
                    textStyle: textTheme.displaySmall),
                TextPreset(
                    text: 'All pending requests',
                    textStyle: textTheme.titleMedium,
                    color: themeNotifier.colorScheme.onSurface),
                ConfirmRequestCard()
              ],
            ),
          ),
        ));
  }
}
