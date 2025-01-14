import 'package:flutter/material.dart';
import 'package:venuebookingsystem/pages/Booking/booking.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';



class HorizontalCardList extends StatelessWidget {
  final String category;

  const HorizontalCardList({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              .where((doc) => doc['room_type'] == category)
              .toList();

          if (documents.isEmpty) {
            return Text('No documents found');
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: documents.map((document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return _buildCard(context, data['Name'], data['venue_id'], data['room_type']);
            }).toList(),
          );
        },
      ),
    );
  }
}



Widget _buildCard(BuildContext context, String title, String room,String room_type) {
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

