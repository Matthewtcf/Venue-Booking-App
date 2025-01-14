import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';

class VenueCard extends StatefulWidget {
  @override
  _VenueCardState createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {



  Widget _textPreset(String text, TextStyle? textStyle, Color? color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }







  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Venues')
          .where('venue_id', isEqualTo: '$room_no')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        // Get the document data
        final mainData = snapshot.data!.docs.first.data();

        // Use the data to build the UI
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Venues')
              .doc(mainData['documentId'])
              .collection('booking')
              .doc('subDocumentId')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            // Get the document data
            final subData = snapshot.data!.data();

            // Use the data to build the UI
            return Card(
              child: ListTile(
                title: Text('User Email: ${subData!['user']}'),
              ),
            );
          },
        );
      },
    );}}