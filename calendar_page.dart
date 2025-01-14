import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Appointment> _appointments = [];
  final String localVenueId = '$room_no';

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final venueDoc = await FirebaseFirestore.instance
        .collection('Venues')
        .where('venue_id', isEqualTo: localVenueId)
        .get();

    if (venueDoc.docs.isNotEmpty) {
      final venueId = venueDoc.docs.first.id;
      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('Venues')
          .doc(venueId)
          .collection('booking')
          .get();

      if (bookingsSnapshot.docs.isNotEmpty) {
        setState(() {
          _appointments = bookingsSnapshot.docs.map((bookingDoc) {
            final data = bookingDoc.data();
            final themeNotifier =
                Provider.of<ThemeNotifier>(context, listen: false);

            return Appointment(
              startTime: data['start_time_timestamp'].toDate(),
              endTime: data['end_time_timestamp'].toDate(),
              subject: data['description'] ?? data['status'],
              color: data['status'] == 'pending'
                  ? themeNotifier.colorScheme.tertiary
                  : data['status'] == 'approved'
                      ? themeNotifier.colorScheme.primary
                      : themeNotifier.colorScheme.error,
            );
          }).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600.0,
      child: SfCalendar(
        view: CalendarView.workWeek,
        timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 7,
            endHour: 20,
            nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
            numberOfDaysInView: 7),
        dataSource: _AppointmentDataSource(_appointments),
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
