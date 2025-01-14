import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:venuebookingsystem/text_preset.dart';


class TimestampWidget extends StatelessWidget {
  final Timestamp timestamp;

  TimestampWidget({required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    DateTime dateTime = timestamp.toDate();
    String formattedDateTime = DateFormat('MMMM d, yyyy ').format(dateTime);

    return CardTextPreset(text: formattedDateTime, textStyle: textTheme.bodyMedium, color: themeNotifier.colorScheme.onSurface);
  }
}

class HourTimestampWidget extends StatelessWidget {
  final Timestamp starttimestamp;
  final Timestamp endtimestamp;

  HourTimestampWidget({required this.starttimestamp,required this.endtimestamp});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    DateTime startdateTime = starttimestamp.toDate();
    DateTime enddateTime = endtimestamp.toDate();
    String formattedstartDateTime = DateFormat('h:mm a').format(startdateTime);
    String formattedendDateTime = DateFormat('h:mm a').format(enddateTime);


    return CardTextPreset(text: 'From $formattedstartDateTime to $formattedendDateTime', textStyle: textTheme.bodyMedium, color: themeNotifier.colorScheme.onSurface);
  }
}
