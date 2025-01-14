import 'package:venuebookingsystem/auth.dart';
import 'package:venuebookingsystem/nav_page.dart';
import 'package:venuebookingsystem/pages/Login%20and%20register/login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();

}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return nav_bar();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}