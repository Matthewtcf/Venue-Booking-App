import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/main.dart';
import '../../auth.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? errorMassage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      userEmail= _controllerEmail.text;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassage = e.message;
      });
    }
  }

  Future<void> createWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('School Venue booking');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _passwordEntryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      obscureText: true,
      obscuringCharacter: '•',
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMassage() {
    return Text(errorMassage == '' ? '' :  '$errorMassage');
  }

  Widget _submitButton() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return SizedBox(
      height: 40.0,
      child: ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createWithEmailAndPassword,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            isLogin ? 'Login' : 'Register',
            style: textTheme.labelLarge?.copyWith(color: themeNotifier.colorScheme.onPrimary),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: themeNotifier.colorScheme.primary,

        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent)
        ),
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register Instead' : 'Login instead',
        style: textTheme.labelLarge?.copyWith(color: themeNotifier.colorScheme.primary),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: Container(

        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
              child: Text(
                'Immaculate Heart of Mary College \nBooking System',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
            ),
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: _entryField('School email*', _controllerEmail),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: _passwordEntryField('password*', _controllerPassword),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: _errorMassage(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: _submitButton(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: _loginOrRegisterButton(),
          ),
        ],
      )

          ],
        ),
      ),
    );
  }
}
