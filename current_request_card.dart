import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../text_preset.dart';
import 'package:provider/provider.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/timestamp_widget.dart';

class CurrentRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('booking')
          .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .where('start_time_timestamp', isGreaterThan: DateTime.now())
          .orderBy('start_time_timestamp', descending: true)
          .limit(10)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return SizedBox(
            height: 100,
            child: Center(
              child: TextPreset(
                  text: 'Something went wrong',
                  textStyle: textTheme.labelLarge,
                  color: themeNotifier.colorScheme.onSurface),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 100);
        }

        if (snapshot.data!.docs.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: TextPreset(
                  text: 'No request at this moment...',
                  textStyle: textTheme.labelLarge,
                  color: themeNotifier.colorScheme.onSurface),
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot bookingDoc) {
            Map<String, dynamic> bookingData =
                bookingDoc.data() as Map<String, dynamic>;
            return StreamBuilder<DocumentSnapshot>(
              stream: bookingDoc.reference.parent.parent!.get().asStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> venueSnapshot) {
                if (venueSnapshot.hasError) {
                  return Text('Something went wrong...');
                }

                if (venueSnapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                }

                Map<String, dynamic> venueData =
                    venueSnapshot.data!.data() as Map<String, dynamic>;

                return Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Card(
                      color: themeNotifier.colorScheme.surfaceVariant,
                      elevation: 0,
                      child: ListTile(
                        title: CardTextPreset(
                            text: venueData['Name'],
                            textStyle: textTheme.headlineSmall,
                            color: themeNotifier.colorScheme.onSurface),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardTextPreset(
                                    text: 'Date:',
                                    textStyle: textTheme.bodyMedium,
                                    color: themeNotifier.colorScheme.onSurface),
                                TimestampWidget(
                                    timestamp:
                                        bookingData['start_time_timestamp']),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardTextPreset(
                                    text: 'Time:',
                                    textStyle: textTheme.bodyMedium,
                                    color: themeNotifier.colorScheme.onSurface),
                                HourTimestampWidget(
                                    starttimestamp:
                                        bookingData['start_time_timestamp'],
                                    endtimestamp:
                                        bookingData['end_time_timestamp'])
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardTextPreset(
                                    text: 'Status:',
                                    textStyle: textTheme.bodyMedium,
                                    color: themeNotifier.colorScheme.onSurface),
                                CardTextPreset(
                                  text: bookingData['status'],
                                  textStyle: textTheme.bodyMedium,
                                  color: bookingData['status'] == 'pending'
                                      ? themeNotifier.colorScheme.tertiary
                                      : bookingData['status'] == 'approved'
                                          ? themeNotifier.colorScheme.primary
                                          : themeNotifier.colorScheme.error,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardTextPreset(
                                    text: 'Description:',
                                    textStyle: textTheme.bodyMedium,
                                    color: themeNotifier.colorScheme.onSurface),
                                CardTextPreset(
                                    text: bookingData['description'] ?? 'None',
                                    textStyle: textTheme.bodyMedium,
                                    color: themeNotifier.colorScheme.onSurface),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
