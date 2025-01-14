import 'package:flutter/material.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/pages/Booking/booking.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import 'home_page_card.dart';


class FloorList extends StatefulWidget {
  const FloorList({Key? key}) : super(key: key);

  @override
  State<FloorList> createState() => _FloorListState();
}

class _FloorListState extends State<FloorList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloorCard(floor: 0,name: 'Ground Floor',),
        FloorCard(floor: 1,name: 'Floor 1'),
        FloorCard(floor: 2,name: 'Floor 2')
      ],
    );
  }
}

class FloorCard extends StatelessWidget {
  final int floor;
  final String name;

  const FloorCard({
    super.key,
    required this.name,
    required this.floor
  });


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Container(child: _textPreset(name, textTheme.titleMedium,themeNotifier.colorScheme.onBackground)),

        Container(
          height: 340,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Venues').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Container();
              }

              List<QueryDocumentSnapshot> documents = snapshot.data!.docs
                  .where((doc) => doc['floor_no'] == floor)
                  .toList();

              if (documents.isEmpty) {
                return Text('No documents found');
              }

              return ListView(
                scrollDirection: Axis.horizontal,
                children: documents.map((document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                  return _buildCard(context, data['Name'], data['venue_id'], data['room_type'] );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _textPreset(String text, TextStyle? textStyle, Color? color) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Text(
      text,
      style: textStyle?.copyWith(color: color),
    ),
  );
}

Widget _buildCard(BuildContext context, String title, String room , String room_type) {
  final themeNotifier = Provider.of<ThemeNotifier>(context);
  return Container(
    width: 210.0,
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    child: InkWell(
        onTap: () {
          room_no = room;

          Navigator.pushNamed(context, '/booking');
        },
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  'assets/$room_type.jpg',
                  height: 340.0,
                  width: 210.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 340.0,
                width: 210.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
    ),
  );
}
