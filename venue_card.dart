import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:provider/provider.dart';

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

  Widget _bookingrow(
      String title, String info, TextStyle? textStyle, Color? color) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textPreset(title, textStyle, color),
            _textPreset(info, textStyle, color)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Venues').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        QueryDocumentSnapshot? document = snapshot.data!.docs
            .firstWhere((doc) => doc['venue_id'] == "$room_no");

        if (document == null) {
          return Text('Document not found');
        }

        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        room_type = '${data['room_type']}';


        return Container(
          child: Column(

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 30.0),
                    child: _textPreset('Booking ${data['Name']}',
                        textTheme.displaySmall, themeNotifier.colorScheme.onBackground),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/${data['room_type']}.jpg',
                        fit: BoxFit.cover,
                        height: 380.0,
                        width: 380.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                    child: _textPreset('Description', textTheme.headlineMedium,
                        themeNotifier.colorScheme.onBackground),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('${data['description']}',
                    style: textTheme.bodyLarge
                        ?.copyWith(color: themeNotifier.colorScheme.primary)),
              ),
              _bookingrow('Name', '${data['Name']}', textTheme.bodyLarge,
                  themeNotifier.colorScheme.onBackground),
              _bookingrow('Capacity', '${data['capacity']}',
                  textTheme.bodyLarge, themeNotifier.colorScheme.onBackground),
              _bookingrow('Floor', 'Floor ${data['floor_no']}',
                  textTheme.bodyLarge, themeNotifier.colorScheme.onBackground),
            ],
          ),
        );
      },
    );
  }
}
