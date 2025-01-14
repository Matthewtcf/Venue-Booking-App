import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:provider/provider.dart';
import '../../text_preset.dart';

import 'package:venuebookingsystem/timestamp_widget.dart';

class ConfirmRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('booking')
          .where('status', isEqualTo: 'pending')
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
          return const Text('');
        }
        if (snapshot.data!.docs.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: TextPreset(
                  text: 'No request',
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
                            TimestampWidget(
                                timestamp: bookingData['start_time_timestamp']),
                            HourTimestampWidget(
                                starttimestamp:
                                    bookingData['start_time_timestamp'],
                                endtimestamp:
                                    bookingData['end_time_timestamp']),
                            CardTextPreset(
                                text: bookingData['user'] ?? 'None',
                                textStyle: textTheme.bodyMedium,
                                color: themeNotifier.colorScheme.onSurface),
                            CardTextPreset(
                                text: bookingData['description'] ?? 'None',
                                textStyle: textTheme.bodyMedium,
                                color: themeNotifier.colorScheme.onSurface),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      await bookingDoc.reference
                                          .update({'status': 'approved'});
                                    },
                                    child: CardTextPreset(
                                        text: 'Approve',
                                        textStyle: textTheme.bodyMedium,
                                        color:
                                            themeNotifier.colorScheme.primary)),
                                TextButton(
                                    onPressed: () async {
                                      await bookingDoc.reference
                                          .update({'status': 'rejected'});
                                    },
                                    child: CardTextPreset(
                                        text: 'Reject',
                                        textStyle: textTheme.bodyMedium,
                                        color:
                                            themeNotifier.colorScheme.primary)),
                              ],
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
