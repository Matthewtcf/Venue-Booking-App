import 'package:flutter/material.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/pages/Home/home_page_card.dart';
import 'package:venuebookingsystem/font.dart';
import '../Booking/booking.dart';
import '../../nav_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:venuebookingsystem/auth.dart';
import 'package:provider/provider.dart';
import 'package:venuebookingsystem/pages/Home/home_fliterchips.dart';
import 'package:venuebookingsystem/pages/Home/home_page_card_by_floor.dart';



class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('sign out'),
    );
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

  String _selectedCategory = 'classroom';

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                  icon: Icon(Icons.settings, size: 24.0),
                  onPressed: () {
                    Navigator.pushNamed(context, '/setting');
                  }),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textPreset('Hello User', textTheme.displaySmall,
                    themeNotifier.colorScheme.onBackground),
                SizedBox(height: 20),
                HomeFilterChips(
                  onCategoryChanged: _onCategoryChanged,
                ),
                SizedBox(height: 20),
                _textPreset('Selected venue', textTheme.titleMedium,
                    themeNotifier.colorScheme.onBackground),
                HorizontalCardList(
                  category: _selectedCategory,
                ),
                FloorList(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/dayview');
                    },
                    child: Text('DayView')),
                _signOutButton(),
                _textPreset('Hello User', textTheme.displayMedium,
                    themeNotifier.colorScheme.onBackground),
                _textPreset('Hello User', textTheme.labelMedium,
                    themeNotifier.colorScheme.onBackground),
                _textPreset('Hello User', textTheme.headlineMedium,
                    themeNotifier.colorScheme.onBackground),
                _textPreset('Hello User', textTheme.titleMedium,
                    themeNotifier.colorScheme.onBackground),
                _textPreset('Hello User', textTheme.bodyMedium,
                    themeNotifier.colorScheme.onBackground),
              ],

            ),
          ),
        ])));
  }
}
