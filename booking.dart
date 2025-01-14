import 'package:firebase_core/firebase_core.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:flutter/material.dart';
import 'package:venuebookingsystem/pages/Home/home_page_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:venuebookingsystem/font.dart';
import 'venue_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:venuebookingsystem/main.dart';
import 'calendar_page.dart';
import 'package:intl/intl.dart';
import '../../text_preset.dart';
import 'three_color_box.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  late Timestamp selectedStartTimestamp;
  late Timestamp selectedEndTimestamp;
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
      });
    };

    final DateTime now = DateTime.now();
    final DateTime selectedStartDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );
    selectedStartTimestamp = Timestamp.fromDate(selectedStartDateTime);
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    };
    final DateTime now = DateTime.now();
    final DateTime selectedEndDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );
    selectedEndTimestamp = Timestamp.fromDate(selectedEndDateTime);

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  

  Future<void> _SelectedTimeFirestore(
      Timestamp selectedStartTimestamp, Timestamp selectedEndTimestamp) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
          .instance
          .collection('Venues')
          .where('venue_id', isEqualTo: '$room_no')
          .limit(1)
          .get();

      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          querySnapshot.docs.first;

      await documentSnapshot.reference
          .collection('booking')
          .add({
        'user': FirebaseAuth.instance.currentUser?.email,
        'room': room_no,
        'selected_date': selectedDate,
        'start_time_timestamp': selectedStartTimestamp,
        'end_time_timestamp': selectedEndTimestamp,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'description': textfield
      });
      print('Selected time saved to Firestore.');
    } catch (e) {
      print('Error saving selected time to Firestore: $e');
    }
  }

  Widget _textPreset(String text, TextStyle? textStyle, Color? color) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }

  Future<void> _venueFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('Venues').add({
        'venue_id': '113',
        'Name': 'Room 113',
        'room_type': 'computer_room',
        'floor_no': 1,
        'capacity': 30,
        'description': 'A space with desks or tables and computers for use',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Selected time saved to Firestore.');
    } catch (e) {
      print('Error saving selected time to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(''),backgroundColor: themeNotifier.colorScheme.surface,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(useMaterial3: false),
        child: BottomAppBar(
            color: themeNotifier.colorScheme.surface,
            height: 70.0,
            elevation: 0,
            child: Theme(
              data: ThemeData(useMaterial3: true),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _venueFirestore();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Venue',
                          style: textTheme.labelLarge
                              ?.copyWith(color: themeNotifier.colorScheme.primary),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: themeNotifier.colorScheme.surface,
                          side: BorderSide(color: themeNotifier.colorScheme.primary)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _SelectedTimeFirestore(
                            selectedStartTimestamp, selectedEndTimestamp);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Send',
                          style: textTheme.labelLarge
                              ?.copyWith(color: themeNotifier.colorScheme.onPrimary),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: themeNotifier.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: Container(
        color: themeNotifier.colorScheme.surface,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


              VenueCard(),
              _textPreset('Booking info', textTheme.headlineMedium , themeNotifier.colorScheme.onSurface),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CalendarPage(),
              ),
            ColorBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  onChanged: (text) {
                    textfield=text;
                  },
                  decoration: InputDecoration(
                    labelText: 'your booking event or purpose (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 0,
                  color: themeNotifier.colorScheme.secondaryContainer,

                  child: InkWell(
                    onTap: () {
                      _selectDate(context); // call _selectDate instead of _selectStartTime
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today), // calendar icon
                          SizedBox(width: 16.0),
                          Text("Date: ${DateFormat('MMMM d, yyyy').format(selectedDate)}" ,style: textTheme.bodyLarge,)


                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Card(
                      elevation: 0,
                      color: themeNotifier.colorScheme.secondaryContainer,
                      child: InkWell(
                        onTap: () {
                          _selectStartTime(context);

                          // show time picker on tap
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.access_time), // time icon
                              SizedBox(width: 16.0),
                              Text(
                                "From: ${_selectedStartTime.format(context)}",
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Card(
                      elevation: 0,
                      color: themeNotifier.colorScheme.secondaryContainer,
                      child: InkWell(
                        onTap: () {
                          _selectEndTime(context);




                          // show time picker on tap
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.access_time), // time icon
                              SizedBox(width: 16.0),
                              Text(
                                "To: ${_selectedEndTime.format(context)}",
                                style: textTheme.bodyLarge
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
