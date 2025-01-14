import 'package:flutter/material.dart';
import 'package:venuebookingsystem/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';

import 'pages/Home/home_page.dart';

import 'package:provider/provider.dart';
import 'package:venuebookingsystem/main.dart';
import 'pages/Confirmation/request_page.dart';
import 'pages/Confirmation/past_request_card.dart';
import 'pages/Confirmation/confirmation_page.dart';
class HomePage extends StatelessWidget{
  HomePage({Key? key}) : super(key :key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async{
    await Auth().signOut();
  }
  Widget _title(){
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text('sign out'),);
  }



  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),

    );
  }
}



class nav_bar extends StatefulWidget {


   nav_bar({Key? key}) : super(key: key);





  @override
  State<nav_bar> createState() => _nav_barState();
}

class _nav_barState extends State<nav_bar> {

  final User? user = Auth().currentUser;

  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text('sign out'),);
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(bottomNavigationBar: NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: themeNotifier.colorScheme.secondaryContainer,
        labelTextStyle: MaterialStateProperty.all(
          textTheme.bodyMedium?.apply(color: themeNotifier.colorScheme.onSurface),
        ),
      ),
      child: NavigationBar(
        height: 80,
        backgroundColor: themeNotifier.colorScheme.surface,
        elevation: 2,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.explore,
                  color: themeNotifier.colorScheme.onSecondaryContainer),
              icon: Icon(Icons.explore_outlined,
                  color: themeNotifier.colorScheme.onSurfaceVariant),
              label: 'Home'),
          NavigationDestination(
            selectedIcon: Icon(Icons.folder,
                color: themeNotifier.colorScheme.onSecondaryContainer),
            icon: Icon(Icons.folder_open,
                color: themeNotifier.colorScheme.onSurfaceVariant),
            label: 'Bookings',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.folder,
                color: themeNotifier.colorScheme.onSecondaryContainer),
            icon: Icon(Icons.folder_open,
                color: themeNotifier.colorScheme.onSurfaceVariant),
            label: 'Confirmation',
          ),
        ],
      ),
    ),
      body: <Widget>[
        Container(
          child: Home()
          ),
        Container(
          color: themeNotifier.colorScheme.background,
          child: RequestPage(),
        ),
        Container(
          color: themeNotifier.colorScheme.background,
          child: ConfirmationPage(),
        ),
      ][currentPageIndex],
    );
  }
}






